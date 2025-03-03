import { InAppWebview, InAppWebviewOptions } from './InAppWebview'
import { webview } from '@kit.ArkWeb';
import { ComponentContent } from '@kit.ArkUI';
import { PluginMethod, CloakPlugin } from '@wisdomgarden/cloak';

export default class InAppBrowser extends CloakPlugin {
  protected _name = "InAppBrowser";
  protected _version = "1.0.0";
  protected _description = ''

  @PluginMethod()
  public async open(url: string, onWindowNewEvent?: OnWindowNewEvent) {
    // TODO: close, event, jsInject, etc.
    const inAppWebviewController: webview.WebviewController = new webview.WebviewController();

    const closeBrowser = () => {
      CloakPlugin.uiContext.getPromptAction().closeCustomDialog(inappbrowserContent)
      inappbrowserContent.dispose();
    }

    const inappbrowserOptions = new InAppWebviewOptions(inAppWebviewController, url, closeBrowser);

    const inappbrowserContent: ComponentContent<Object> =
      new ComponentContent(CloakPlugin.uiContext, wrapBuilder(InAppWebview), inappbrowserOptions);


    CloakPlugin.uiContext.getPromptAction().openCustomDialog(inappbrowserContent, {
      alignment: DialogAlignment.TopStart,
      autoCancel: false,
      // onWillDismiss
      // https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/js-apis-promptaction-V5#basedialogoptions11

      // onWillAppear
      // onDidAppear

      // onWillDisappear
      // onDidDisappear
    })
  }
}