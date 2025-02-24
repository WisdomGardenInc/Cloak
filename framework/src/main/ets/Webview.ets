import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { url } from '@kit.ArkTS';
import Config from './Config';
import { abilityAccessCtrl, common } from '@kit.AbilityKit';
import * as DialogUtils from './DialogUtils';
import * as Utils from './Utils';
import PluginManager from './plugin/PluginManager';


// should expose webview, controller, context to plugins
@Component
export default struct CloakWebview {
  webviewController = new webview.WebviewController();

  aboutToAppear(): void {
    try {
      webview.WebviewController.setWebDebuggingAccess(Config.IS_DEBUG);
    } catch (error) {
      console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
    }
  }

  onDidBuild(): void {
    this.requestPermissionForTest();
  }

  requestPermissionForTest() {
    let context = getContext(this) as common.UIAbilityContext;
    let atManager = abilityAccessCtrl.createAtManager();

    atManager.requestPermissionsFromUser(context,
      ["ohos.permission.LOCATION", "ohos.permission.APPROXIMATELY_LOCATION", "ohos.permission.CAMERA",
        "ohos.permission.MICROPHONE",
      ]).then((data) => {
      console.info('data:' + JSON.stringify(data));
      console.info('data permissions:' + data.permissions);
      console.info('data authResults:' + data.authResults);
    }).catch((error: BusinessError) => {
      console.error(`Failed to request permissions from user. Code is ${error.code}, message is ${error.message}`);
    })
  }

  build() {
    Column() {
      Web({
        src: Config.APP_HOST,
        controller: this.webviewController,
        renderMode: RenderMode.ASYNC_RENDER
      })
        .layoutMode(WebLayoutMode.NONE)
        .overScrollMode(OverScrollMode.NEVER)
        .nestedScroll({
          scrollForward: NestedScrollMode.SELF_ONLY,
          scrollBackward: NestedScrollMode.SELF_ONLY,
        })
        .mixedMode(MixedMode.All)
        .javaScriptAccess(true)
        .fileAccess(true)
        .onlineImageAccess(true)
        .domStorageAccess(true)
        .imageAccess(true)
        .databaseAccess(true)
        .geolocationAccess(true)
        .onGeolocationShow(event => {
          // event?.geolocation.invoke(event.origin, true, false);
          if (event) {
            DialogUtils.showConfirm($r('app.string.permission_location_reason'), (isConfirmed) => {
              if (isConfirmed) {
                event.geolocation.invoke(event.origin, true, true);
              } else {
                event.geolocation.invoke(event.origin, false, true);
              }

            }, $r('app.string.common_ui_dialog_webview_request_permission_title'))
          }
        })
        .onPermissionRequest(event => {
          // event?.request.grant(event.request.getAccessibleResource());
          if (event) {
            const accessible = event.request.getAccessibleResource();
            let message: string | Resource = `request permisson ${accessible.join(", ")}`

            if (accessible.includes("TYPE_VIDEO_CAPTURE")) {
              message = $r('app.string.permission_camera_reason')
            } else if (accessible.includes("TYPE_AUDIO_CAPTURE")) {
              message = $r('app.string.permission_microphone_reason')
            }

            DialogUtils.showConfirm(message, (isConfirmed) => {
              if (isConfirmed) {
                event.request.grant(accessible);
              } else {
                event.request.deny();
              }
            }, $r('app.string.common_ui_dialog_webview_request_permission_title'))
          }
        })
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
        .horizontalScrollBarAccess(false)
        .verticalScrollBarAccess(false)
        .mediaOptions({
          resumeInterval: 0, audioExclusive: true
        })
        .onAlert((event) => {
          event && event.message && DialogUtils.showAlert(event.message, () => {
            event.result.handleConfirm();
          });
          return true;
        })
        .onConfirm((event) => {
          event && event.message && DialogUtils.showConfirm(event.message, (success: boolean) => {
            if (success) {
              event.result.handleConfirm();
            } else {
              event.result.handleCancel();
            }
          });
          return true;
        })
        .onPrompt(() => {
          return false;
        })
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
            const custom_agent_items = [Config.CLOAK_IDENTITY_USER_AGENT]
            if (Config.APP_IDENTITY_USER_AGENT) {
              custom_agent_items.push(Config.APP_IDENTITY_USER_AGENT);
            }
            let userAgent = this.webviewController.getUserAgent() + " " + custom_agent_items.join(" ");
            this.webviewController.setCustomUserAgent(userAgent);
          } catch (error) {
            console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
          }
          PluginManager.setWebviewController(this.webviewController);
          PluginManager.registerPlugins();

          // in onControllerAttached function don't need refresh
          // this.webviewController.refresh();
        })
        .onPageEnd((event) => {
          PluginManager.initCloakClient();
        })
    }
    .width("100%")
    .height("100%")
  }
}
