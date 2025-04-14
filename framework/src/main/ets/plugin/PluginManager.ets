import CloakGlobalObject from './CloakGlobalObject';
import { CloakPlugin } from './CloakPlugin';
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import { IChannelMessage, ICloakContext } from '../types';
import { webview } from '@kit.ArkWeb';
import { Cloak } from '../../../../Index';


export default class PluginManager {
  private static _plugins = new Map<string, CloakPlugin>();
  private static _applicationContext: common.ApplicationContext;
  private static _uiContext: UIContext;
  private static _webviewController: WebviewController;
  private static _channelCloakPort: webview.WebMessagePort;
  private static cloakClientJS: string;

  public static setContext(context: ICloakContext) {
    PluginManager._applicationContext = context.applicationContext;
    PluginManager._uiContext = context.uiContext;
    PluginManager._webviewController = context.webviewController;
    PluginManager._channelCloakPort = context.channelCloakPort;

    CloakPlugin.setContext(context)
  }

  public static updateContext(channelCloakPort: webview.WebMessagePort) {
    PluginManager._channelCloakPort = channelCloakPort;
    CloakPlugin.updateContext(channelCloakPort)
  }

  public static get applicationContext(): common.ApplicationContext {
    return PluginManager._applicationContext;
  }

  public static get uiContext(): UIContext {
    return PluginManager._uiContext;
  }

  public static get webviewController(): WebviewController {
    return PluginManager._webviewController;
  }

  public static get channelCloakPort(): webview.WebMessagePort {
    return PluginManager._channelCloakPort;
  }

  public static addPlugin(plugin: CloakPlugin) {
    PluginManager._plugins.set(plugin.name, plugin)
  }

  public static registerPlugins() {
    PluginManager._plugins.forEach(plugin => {
      plugin.beforeRegister();
      plugin.register();
      plugin.afterRegister();
    })

    // process global Cloak
    const cloakGlobalObject = new CloakGlobalObject();
    PluginManager._webviewController.registerJavaScriptProxy(cloakGlobalObject, "Cloak",
      ["getMetadata"])
  }

  public static async initCloakClient() {

    if (!PluginManager.cloakClientJS) {
      const content = PluginManager._applicationContext.resourceManager.getRawFileContentSync('CloakClient.js');

      const textDecoder = util.TextDecoder.create('utf-8', {
        ignoreBOM: true
      });
      const contentStr = textDecoder.decodeToString(content)

      PluginManager.cloakClientJS = contentStr;
    }

    if (PluginManager.cloakClientJS) {
      // window.event `CloakReady` will be triggered
      await PluginManager._webviewController.runJavaScript(PluginManager.cloakClientJS);
    }


    PluginManager._plugins.forEach(plugin => {
      plugin.onAttach();
    })
    Cloak.setStartupCompleted()
  }

  public static onMessage(message: IChannelMessage) {
    const plugin = PluginManager._plugins.get(message.pluginName);
    plugin?.onMessage(message?.payload)
  }
}