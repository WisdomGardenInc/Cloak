import { resourceManager } from '@kit.LocalizationKit'
import CloakGlobalObject from "./CloakGlobalObject";
import CloakPlugin from "./CloakPlugin";

export default class PluginManager {
  private static _plugins = new Map<string, CloakPlugin>();

  public static addPlugin(plugin: CloakPlugin) {
    PluginManager._plugins.set(plugin.name, plugin)
  }

  public static registerPlugins(webviewController: WebviewController) {
    PluginManager._plugins.forEach(plugin => {
      plugin.register(webviewController);
    })

    const cloakGlobalObject = new CloakGlobalObject();

    webviewController.registerJavaScriptProxy(cloakGlobalObject, "Cloak", ["getMetadata", "registerPlugins"])
    webviewController.refresh();
  }

  public static initCloakClient(webviewController: WebviewController,
    resourceManager?: resourceManager.ResourceManager) {
    PluginManager._plugins.forEach(plugin => {
      plugin.register(webviewController);
    })

    // resourceManager?.getStringValue($rawfile('CloakClient.js'), (err, jsFileContent) => {
    //   if (err) {
    //     console.error(err.message)
    //   } else {
    //     webviewController.runJavaScript(jsFileContent)
    //   }
    // })


    webviewController.runJavaScript(`
(function () {
    const cloakPlugins = Object.keys(window).filter(key => key.startsWith('_cloak_plugin_'))
    Cloak.plugins = {};
    Cloak.metadata = Cloak.getMetadata();
    cloakPlugins.forEach(pluginName => {
        const newName = pluginName.substr(14);
        Cloak.plugins[newName] = window[pluginName];
        Cloak.plugins[newName].metadata = Cloak.plugins[newName].getMetadata();
    })
})()
`)
    webviewController.runJavaScript('window.document.body.dispatchEvent(new Event("CloakReady"));')
  }
}