import { resourceManager } from '@kit.LocalizationKit'
import CloakGlobalObject from "./CloakGlobalObject";
import CloakPlugin from "./CloakPlugin";

export default class PluginManager {
  private static _plugins = new Map<string, CloakPlugin>();

  public static addPlugin(plugin: CloakPlugin) {
    PluginManager._plugins.set(plugin.name, plugin)
  }

  public static registerPlugins(webviewController: WebviewController,
    resourceManager?: resourceManager.ResourceManager) {
    PluginManager._plugins.forEach(plugin => {
      plugin.register(webviewController);
    })

    const cloakGlobalObject = new CloakGlobalObject();

    webviewController.registerJavaScriptProxy(cloakGlobalObject, "Cloak", ["getMataData", "registerPlugins"])


    // resourceManager?.getStringValue($rawfile('CloakClient.js'), (err, jsFileContent) => {
    //   if (err) {
    //     console.error(err.message)
    //   } else {
    //     webviewController.runJavaScript(jsFileContent)
    //   }
    // })

    webviewController.refresh();


    // TODO: 生命周期， 页面刷新后还得调用
    // TODO: 从文件读取
    setTimeout(() => {
      webviewController.runJavaScript(`
(function () {
    const clockPlugins = Object.keys(window).filter(key => key.startsWith('_cloak_plugin_'))
    Cloak.plugins = {};
    Cloak.matadata = Cloak.getMataData();
    clockPlugins.forEach(pluginName => {
        const newName = pluginName.substr(14);
        Cloak.plugins[newName] = window[pluginName];
        Cloak.plugins[newName].matadata = Cloak.plugins[newName].getMataData();
    })
})()
`)
      webviewController.runJavaScript('window.document.body.dispatchEvent(new Event("CloakReady"));')
    }, 1000)


  }
}