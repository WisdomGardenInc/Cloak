import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { url } from '@kit.ArkTS';
import Config from './Config';
// import * as DevUtils from './DevUtils';
import * as Utils from './Utils';

@Component
export default struct CloakWebView {
  webviewController = new webview.WebviewController();

  aboutToAppear(): void {
    try {
      webview.WebviewController.setWebDebuggingAccess(true);
    } catch (error) {
      console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
    }
  }

  build() {
    Column() {
      Web({
        src: Config.APP_HOST,
        controller: this.webviewController,
        renderMode: RenderMode.ASYNC_RENDER
      })
        .layoutMode(WebLayoutMode.FIT_CONTENT)
        .overScrollMode(OverScrollMode.NEVER)
        .mixedMode(MixedMode.All)
        .javaScriptAccess(true)
        .fileAccess(true)
        .onlineImageAccess(true)
        .domStorageAccess(true)
        .imageAccess(true)
        .databaseAccess(true)
        .geolocationAccess(true)
        .zoomAccess(false)
        .overviewModeAccess(false)
        .mediaPlayGestureAccess(true)// 在新窗口中打开页面
          // https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/web-open-in-new-window-V5
        .multiWindowAccess(true)
        .allowWindowOpenMethod(true)// .onWindowNew()
        .horizontalScrollBarAccess(false)
        .verticalScrollBarAccess(false)// .keyboardAvoidMode()
        .cacheMode(CacheMode.None)
        .copyOptions(CopyOptions.LocalDevice)
        .blockNetwork(false)
        .allowWindowOpenMethod(true)// ?
        .mediaOptions({
          resumeInterval: 0, audioExclusive: true
        })// .onAlert((event) => {
          //   DevUtils.showAlert(event.message);
          //   return true;
          // })
          // .onPrompt((event) => {
          //   DevUtils.showAlert(event.message);
          //   return true;
          // })
        .onInterceptRequest((event) => {
          if (!event) {
            return null;
          }
          const requestUrl = event.request.getRequestUrl()


          if (!requestUrl.startsWith(Config.APP_HOST)) {
            return null;
          }

          try {
            const pathname = url.URL.parseURL(requestUrl, Config.APP_HOST).pathname
            const resourcePath = Utils.getResourcePath(pathname)
            const mimeType = Utils.getMimeType(resourcePath)

            let response = new WebResourceResponse()
            response.setResponseData($rawfile(resourcePath));
            response.setResponseEncoding('utf-8')
            response.setResponseMimeType(mimeType)
            response.setResponseCode(200)
            response.setReasonMessage('OK')
            response.setResponseIsReady(true)
            return response
          } catch (error) {
            console.error(`Error loading h5 resource: ${requestUrl}`, error)
            return null
          }
        })
        .onControllerAttached(() => {
          // user agent
          try {
            let userAgent = this.webviewController.getUserAgent() + " " + Config.APP_IDENTITY_USER_AGENT;
            this.webviewController.setCustomUserAgent(userAgent);
          } catch (error) {
            console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
          }
        })

      // .onPageEnd((event) => {
      //   if (event) {
      //     console.log('onPageEnd url:' + event.url);
      //   }
      // })

      // .javaScriptProxy({
      //   object: this.testNativeObj,
      //   name: "testNativeObj",
      //   methodList: ["test"],
      //   controller: this.controller,
      // })
    }
    .width("100%")
    .height("100%")
  }
}
