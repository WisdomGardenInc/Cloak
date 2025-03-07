import { InAppWebview, InAppWebviewOptions } from './InAppWebview';
import { webview } from '@kit.ArkWeb';
import { ComponentContent, OnPageBeginEvent } from '@kit.ArkUI';
import { CloakPlugin, PluginMethod } from '@wisdomgarden/cloak';
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import {
  IBrowser,
  IBrowserEvent,
  IBrowserEventPayload,
  IBrowserExecutePayload,
  ICreateBrowserOptions,
  IOpenTarget,
  IWebviewHooks
} from './types';
import { getBrowserOptions } from './utils';


export default class InAppBrowser extends CloakPlugin {
  protected _name = "InAppBrowser";
  protected _version = "1.0.0";
  protected _description = ''
  private isOpened = false;
  private isShowing = false;
  private inappbrowserContent?: ComponentContent<Object>;
  private inAppWebviewController?: webview.WebviewController;

  private async openSystemBrowser(url: string) {
    let want: Want = {
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'],
      uri: url
    };

    try {
      await (getContext() as common.UIAbilityContext).startAbility(want)

      return true;
    } catch (err) {
      const error = (err as BusinessError);
      console.error(`Failed to startAbility. Code: ${error.code}, message: ${error.message}`);
      return false;
    }
  }

  @PluginMethod()
  public createBrowser(url: string, target: IOpenTarget = '_blank',
    clientOptions: ESObject = {}): IBrowser | null {


    if (target === '_system') {
      this.openSystemBrowser(url);
      return null;
    }

    if (this.isOpened) {
      return null;
    }

    this.clearAllEvents();
    this.clearAllMessages();

    const options: ICreateBrowserOptions = getBrowserOptions(clientOptions);

    this.inAppWebviewController = new webview.WebviewController();


    const webviewHooks: IWebviewHooks = {
      onPageBegin: this.onPageBegin.bind(this),
      onPageEnd: this.onPageEnd.bind(this),
    }

    const inappbrowserOptions = new InAppWebviewOptions({
      webviewController: this.inAppWebviewController,
      url,
      closeDialog: this.close.bind(this),
      webviewHooks,
      createBrowserOptions: options
    });

    this.inappbrowserContent =
      new ComponentContent(CloakPlugin.uiContext, wrapBuilder(InAppWebview), inappbrowserOptions);


    return new Browser({
      open: this.open.bind(this),
      close: this.close.bind(this),
      show: this.show.bind(this),
      hide: this.hide.bind(this),
      executeScript: this.executeScript.bind(this),
      insertCSS: this.insertCSS.bind(this),
      addEventListener: this.addEventListener.bind(this),
    })
  }

  // exposed to client
  private open(): boolean {
    if (!this.inappbrowserContent) {
      return false;
    }
    if (this.isOpened) {
      return false;
    }
    CloakPlugin.uiContext.getPromptAction().openCustomDialog(this.inappbrowserContent, {
      alignment: DialogAlignment.TopStart,
      autoCancel: false,
      onDidDisappear: () => {
        // finally close the dialog will execute this function so clear in here
        this.isOpened = false;
        this.isShowing = false;

        this.sendBrowserEventAndMessage('exit')
        this.clearAllEvents();
        this.clearAllMessages();
      }
    })

    this.isOpened = true;
    this.isShowing = true;

    return true;
  }

  // exposed to client
  private close() {
    if (!this.inappbrowserContent) {
      return false;
    }

    if (!this.isOpened) {
      return false;
    }

    CloakPlugin.uiContext.getPromptAction().closeCustomDialog(this.inappbrowserContent)
    this.inappbrowserContent.dispose();
    this.inappbrowserContent = undefined;
    return true;
  }

  // exposed to client
  private show() {
    if (!this.inappbrowserContent) {
      return false;
    }

    if (!this.isOpened) {
      return false;
    }

    if (this.isShowing) {
      return false;
    }

    return true;
  }

  // exposed to client
  private hide() {
    if (!this.inappbrowserContent) {
      return false;
    }

    if (!this.isOpened) {
      return false;
    }

    if (!this.isShowing) {
      return false;
    }

    return true;
  }

  // exposed to client
  private async executeScript(payload: IBrowserExecutePayload): Promise<ESObject> {
    if (!this.isOpened) {
      return {
        error: 'not opened',
        successes: false
      }
    }

    if (!this.inAppWebviewController) {
      return {
        error: 'no webview controller',
        successes: false
      }
    }

    try {
      const result = await this.inAppWebviewController.runJavaScript(payload.code)
      return result;
    } catch (err) {
      return {
        error: err,
        successes: false
      }
    }
  }

  // exposed to client
  private async insertCSS(payload: IBrowserExecutePayload): Promise<ESObject> {
    if (!this.isOpened) {
      return {
        error: 'not opened',
        successes: false
      }
    }

    if (!this.inAppWebviewController) {
      return {
        error: 'no webview controller',
        successes: false
      }
    }

    try {
      await this.inAppWebviewController.runJavaScript('const node=document.createElement("style");node.innerHTML=`' +
      payload.code + '`;document.head.appendChild(node);')
      return {
        successes: true
      };
    } catch (err) {
      return {
        error: err,
        successes: false
      }
    }
  }

  private onPageBegin(event: OnPageBeginEvent) {
    this.sendBrowserEventAndMessage('loadstart', event.url)
  }

  private onPageEnd(event: OnPageBeginEvent) {
    this.sendBrowserEventAndMessage('loadstop', event.url)
  }


  private sendBrowserEventAndMessage(eventType: IBrowserEvent, url?: string) {
    this.sendBrowserEvent(eventType, url);
    this.sendBrowserMessage(eventType, url);
  }

  private sendBrowserEvent(eventType: IBrowserEvent, url?: string) {
    const eventData: IBrowserEventPayload = {
      event: eventType,
      url: url ?? ''
    }
    this._sendEvent(eventType, eventData);
  }

  private sendBrowserMessage(eventType: IBrowserEvent, url?: string) {
    const eventData: IBrowserEventPayload = {
      event: eventType,
      url: url ?? ''
    }
    this._sendMessage(eventType, eventData)
  }
}

class Browser implements IBrowser {
  methodNameListForJsProxy = ["open", "close", "show", "hide", "executeScript", "insertCSS", "addEventListener"];
  browser: IBrowser

  constructor(browser: IBrowser) {
    this.browser = browser;
  }

  open() {
    return this.browser.open();
  }

  close() {
    return this.browser.close();
  }

  show() {
    return this.browser.hide();
  }

  hide() {
    return this.browser.hide();
  }

  executeScript(payload: IBrowserExecutePayload) {
    return this.browser.executeScript(payload);
  }

  insertCSS(payload: IBrowserExecutePayload) {
    return this.browser.insertCSS(payload);
  }

  addEventListener(event: IBrowserEvent, handler: (event: IBrowserEventPayload) => void) {
    this.browser.addEventListener(event, handler);
  }
}