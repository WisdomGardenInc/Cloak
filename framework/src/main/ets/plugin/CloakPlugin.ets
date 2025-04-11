import { common } from '@kit.AbilityKit';
import { webview } from '@kit.ArkWeb';
import { ICloakContext } from '../types';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import logger from '../logger';


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
  protected browserEventsHandlers = new Map<string, Map<string, (event: ESObject) => void>>();
  protected browserMessages = new Set<string>();

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
        this._pluginMethods.concat('getMetadata', 'addEventListener', 'removeEventListener', 'clearAllEvents',
          'addMessage', 'removeMessage', 'clearAllMessages'))
    } catch (error) {
      logger.error(
        'registerJavaScriptProxy error. ErrorCode: %{public}s,  Message: %{public}s',
        (error as BusinessError).code,
        (error as BusinessError).message,
      );
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

  public addEventListener(event: string, handler: (event: ESObject) => void) {
    if (!handler) {
      return;
    }
    if (!this.browserEventsHandlers.has(event)) {
      this.browserEventsHandlers.set(event, new Map());
    }
    // let handlerId = Reflect.get(handler, 'handlerId') as string;
    // if (!handlerId?.length) {
    //   handlerId = util.generateRandomUUID();
    // }

    const handlerId = util.generateRandomUUID();

    if (this.browserEventsHandlers.get(event)?.has(handlerId)) {
      return;
    }

    this.browserEventsHandlers.get(event)?.set(handlerId, handler)

    return handlerId;
  }

  public removeEventListener(event: string, handlerId?: string) {
    const handlers = this.browserEventsHandlers.get(event);
    if (!handlers?.size) {
      return;
    }

    if (!handlerId) {
      this.browserEventsHandlers.delete(event);
      return;
    }

    this.browserEventsHandlers.get(event)?.delete(handlerId)
  }

  public clearAllEvents() {
    this.browserEventsHandlers.clear();
  }

  protected hasEvent(event: string): boolean {
    return this.browserEventsHandlers.has(event)
  }

  protected _sendEvent(eventType: string, payload: ESObject) {
    if (!this.hasEvent(eventType)) {
      return;
    }
    const handlers = this.browserEventsHandlers.get(eventType);
    handlers?.forEach((handler) => {
      handler(payload)
    })
  }

  public addMessage(messageType: string) {
    if (!messageType) {
      return;
    }
    this.browserMessages.add(messageType)
  }

  public removeMessage(messageType: string) {
    this.browserMessages.delete(messageType)
  }

  public clearAllMessages() {
    this.browserMessages.clear();
  }

  public hasMessage(messageType: string) {
    return this.browserMessages.has(messageType)
  }

  public onMessage(payload: ESObject) {
    //
  }

  protected wrapMessage(payload: ESObject) {
    return JSON.stringify({
      pluginName: this._name,
      payload: payload
    })
  }

  protected _sendMessage(messageType: string, payload: ESObject) {
    if (!this.hasMessage(messageType)) {
      return;
    }
    CloakPlugin.channelCloakPort.postMessageEvent(this.wrapMessage(payload));
  }
}