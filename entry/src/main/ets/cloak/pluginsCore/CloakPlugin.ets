import { common } from "@kit.AbilityKit";

// Decorator
export interface PluginMetadata extends ESObject {
  name: string;
  version: string;
  description: string;
  methods: string[];
}

export function PluginMethod(target: CloakPlugin, propertyName: string, descriptor: PropertyDescriptor) {
  target.addPluginMethodName(propertyName);
}

export default abstract class CloakPlugin {
  private static pluginNamePrefix = "_cloak_plugin_"
  protected abstract _name: string;
  protected abstract _version: string;
  protected _description: string = '';

  protected static applicationContext: common.ApplicationContext;
  protected static webviewController: WebviewController;

  protected _pluginMethods!: string[];

  public addPluginMethodName(methodName: string) {
    // Decorator before class instance constructor
    if (!this._pluginMethods) {
      this._pluginMethods = [];
    }
    this._pluginMethods.push(methodName);
  }

  public get name() {
    return this._name;
  }


  public pluginMethods(): string[] {
    return this._pluginMethods.slice();
  }

  public register(context: common.ApplicationContext, webviewController: WebviewController) {
    CloakPlugin.applicationContext = context;
    CloakPlugin.webviewController = webviewController;
    try {
      webviewController.registerJavaScriptProxy(this, `${CloakPlugin.pluginNamePrefix}${this._name}`,
        this._pluginMethods.concat('getMetadata'))
    } catch (error) {
      console.error(`registerJavaScriptProxy error: ${error}`);
    }
  }

  public getMetadata(): PluginMetadata {
    return {
      name: this._name,
      version: this._version,
      description: this._description,
      methods: this._pluginMethods
    }
  }
}