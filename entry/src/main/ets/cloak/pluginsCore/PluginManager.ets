import CloakGlobalObject from './CloakGlobalObject';
import CloakPlugin from './CloakPlugin';
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';

export default class PluginManager {
  private static _plugins = new Map<string, CloakPlugin>();
  private static _applicationContext: common.ApplicationContext;
  private static _webviewController: WebviewController;
  private static cloakClientJS: string;

  public static setApplicationContext(context: common.ApplicationContext) {
    PluginManager._applicationContext = context;
  }

  public static setWebviewController(controller: WebviewController) {
    PluginManager._webviewController = controller;
  }

  public static addPlugin(plugin: CloakPlugin) {
    PluginManager._plugins.set(plugin.name, plugin)
  }

  public static registerPlugins() {
    PluginManager._plugins.forEach(plugin => {
      plugin.register(PluginManager._applicationContext, PluginManager._webviewController);
    })

    // process global Cloak
    const cloakGlobalObject = new CloakGlobalObject();
    PluginManager._webviewController.registerJavaScriptProxy(cloakGlobalObject, "Cloak",
      ["getMetadata", "registerPlugins"])
  }

  public static initCloakClient() {

    if (!PluginManager.cloakClientJS) {
      const content = PluginManager._applicationContext.resourceManager.getRawFileContentSync('CloakClient.js');

      const textDecoder = util.TextDecoder.create('utf-8', {
        ignoreBOM: true
      });
      const contentStr = textDecoder.decodeToString(content)

      PluginManager.cloakClientJS = contentStr;
    }

    if (PluginManager.cloakClientJS) {
      PluginManager._webviewController.runJavaScript(PluginManager.cloakClientJS);
    }
  }
}