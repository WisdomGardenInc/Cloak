import { common } from '@kit.AbilityKit';
import { webview } from '@kit.ArkWeb';
import { ICloakContext } from '../types';


export interface PluginMetadata {
  name: string;
  version: string;
  description: string;
  methods: string[];
}

// Decorator
export function PluginMethod() {
  return (target: CloakPlugin, propertyName: string, descriptor: PropertyDescriptor) => {
    target.addPluginMethodName(propertyName);
  }
}


export interface ICloakPlugin {
  name: string;

  pluginMethods(): string[];

  getMetadata(): PluginMetadata;

  register(context: common.ApplicationContext, uiContext: UIContext, webviewController: WebviewController): void;
}

export abstract class CloakPlugin implements ICloakPlugin {
  private static pluginNamePrefix = "_cloak_plugin_"
  protected static applicationContext: common.ApplicationContext;
  protected static webviewController: WebviewController;
  protected static uiContext: UIContext;
  private static pluginsMethodsMap = new Map<string, string[]>();
  protected static channelCloakPort: webview.WebMessagePort;
  protected _name: string = this.constructor.name;
  protected abstract _version: string;
  protected _description: string = '';
  private _pluginMethods: string[];

  public addPluginMethodName(methodName: string) {
    // Decorator before class instance constructor
    if (!CloakPlugin.pluginsMethodsMap.has(this.constructor.name)) {
      CloakPlugin.pluginsMethodsMap.set(this.constructor.name, [methodName]);
    } else {
      CloakPlugin.pluginsMethodsMap.get(this.constructor.name)!.push(methodName);
    }
  }

  constructor() {
    this._pluginMethods = CloakPlugin.pluginsMethodsMap.get(this.constructor.name) ?? [];
  }

  public get name() {
    return this._name;
  }


  public pluginMethods(): string[] {
    return this._pluginMethods.slice();
  }


  public static setContext(context: ICloakContext) {
    CloakPlugin.applicationContext = context.applicationContext;
    CloakPlugin.uiContext = context.uiContext;
    CloakPlugin.webviewController = context.webviewController;
    CloakPlugin.channelCloakPort = context.channelCloakPort;
  }

  public static updateContext(channelCloakPort: webview.WebMessagePort) {
    CloakPlugin.channelCloakPort = channelCloakPort;
  }

  public register() {
    try {
      CloakPlugin.webviewController.registerJavaScriptProxy(this, `${CloakPlugin.pluginNamePrefix}${this._name}`,
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

  public  onMessage(payload: ESObject) {
    //
  }

  protected wrapMessage(payload: ESObject) {
    return JSON.stringify({
      pluginName: this._name,
      payload: payload
    })
  }

  protected _sendMessage(payload: ESObject) {
    CloakPlugin.channelCloakPort.postMessageEvent(this.wrapMessage(payload));
  }
}