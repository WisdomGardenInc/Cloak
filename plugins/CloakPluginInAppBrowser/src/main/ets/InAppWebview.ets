import { webview } from '@kit.ArkWeb';


export class InAppWebviewOptions {
  private _webviewController: webview.WebviewController;
  private _url: string;
  private _closeDialog: Function;

  constructor(webviewController: webview.WebviewController, url: string, closeDialog: Function) {
    this._webviewController = webviewController;
    this._url = url;
    this._closeDialog = closeDialog;
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
}

@Builder
export function InAppWebview(options: InAppWebviewOptions) {
  Column() {
    Web({ src: options.url, controller: options.webviewController })
      .javaScriptAccess(true)
      .multiWindowAccess(false)
      .allowWindowOpenMethod(false)
      .onWindowExit(() => {
        console.info("NewWebViewComp onWindowExit");
        options.closeDialog();
      })
      .onControllerAttached(() => {
        //
      })
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
          Text('forward')
            .fontSize(16)
            .fontColor(Color.White)
            .onClick(() => {
              options.webviewController.forward()
            })
        }

        Button() {
          Text('back')
            .fontSize(16)
            .fontColor(Color.White)
            .onClick(() => {
              options.webviewController.backward()
            })
        }.margin({ left: 10 })
      }

    }.width('100%').justifyContent(FlexAlign.SpaceBetween)
  }
  .width("100%")
  .height("100%");

}