import { webview } from '@kit.ArkWeb';
import { ICreateBrowserOptions, IWebviewHooks } from './types';


interface InAppWebviewOptionsData {
  webviewController: webview.WebviewController,
  url: string,
  closeDialog: Function,
  webviewHooks: IWebviewHooks,
  createBrowserOptions: ICreateBrowserOptions
}


export class InAppWebviewOptions {
  private _webviewController: webview.WebviewController;
  private _url: string;
  private _closeDialog: Function;
  private _webviewHooks: IWebviewHooks;
  private _createBrowserOptions: ICreateBrowserOptions;

  constructor(options: InAppWebviewOptionsData) {
    this._webviewController = options.webviewController;
    this._url = options.url;
    this._closeDialog = options.closeDialog;
    this._webviewHooks = options.webviewHooks;
    this._createBrowserOptions = options.createBrowserOptions;
  }

  public get webviewController(): webview.WebviewController {
    return this._webviewController;
  }

  public get url(): string {
    return this._url;
  }

  public get closeDialog(): Function {
    return this._closeDialog;
  }

  public get webviewHooks(): IWebviewHooks {
    return this._webviewHooks;
  }

  public get createBrowserOptions(): ICreateBrowserOptions {
    return this._createBrowserOptions;
  }
}

@Builder
export function InAppWebview(options: InAppWebviewOptions) {
  Column() {
    Web({ src: options.url, controller: options.webviewController })
      .javaScriptAccess(true)
      .multiWindowAccess(false)
      .allowWindowOpenMethod(false)
      .onControllerAttached(() => {
        //
      })
      .onPageBegin(options.webviewHooks.onPageBegin)
      .onPageEnd(options.webviewHooks.onPageEnd)
      .width('100%')
      .height('90%')

    Row() {
      Button() {
        Text('close')
          .fontSize(16)
          .fontColor(Color.White)
          .onClick(() => {
            options.closeDialog();
          })
      }

      Row() {
        Button() {
          Text('<')
            .fontSize(16)
            .fontColor(Color.White)
            .onClick(() => {
              options.webviewController.backward()
            })
        }

        Button() {
          Text('>')
            .fontSize(16)
            .fontColor(Color.White)
            .onClick(() => {
              options.webviewController.forward()
            })
        }.margin({ left: 10 })
      }

    }.width('100%').justifyContent(FlexAlign.SpaceBetween)
  }
  .width("100%")
  .height("100%");

}