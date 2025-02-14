// InAPPBrowser
// SlashScreen
// 如何给 window 注入对象
// name 可能注入懂啊 window 上的某个对象上


interface PluginMataData {
  name: string;
  version: string;
  description: string;
  methods: string[];
}

export default abstract class CloakPlugin {
  private static pluginNamePrefix = "_cloak_plugin_"
  protected abstract _name: string;
  protected abstract _version: string;
  protected _description: string = '';
  protected _pluginMethods!: string[];

  public get name() {
    return this._name;
  }

  public addPluginMethod(methodName: string) {
    // TODO: @PluginMethod 修饰起执行的时候，_pluginMethods 还没初始化， 所以在这里初始化
    if (!this._pluginMethods) {
      this._pluginMethods = [];
    }
    this._pluginMethods.push(methodName);
  }

  public pluginMethods(): string[] {
    return this._pluginMethods.slice();
  }

  public register(webviewController: WebviewController) {
    // TODO: name 能否注入到 window.xxx.yyy 上?
    try {
      webviewController.registerJavaScriptProxy(this, `${CloakPlugin.pluginNamePrefix}${this._name}`,
        this._pluginMethods.concat('getMataData'))
    } catch (error) {
      console.error(`registerJavaScriptProxy error: ${error}`);
    }
  }

  public getMataData(): PluginMataData {
    return {
      name: this._name,
      version: this._version,
      description: this._description,
      methods: this._pluginMethods
    }
  }
}