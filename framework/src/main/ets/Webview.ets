import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { url } from '@kit.ArkTS';
import Config from './Config';
import * as DialogUtils from './DialogUtils';
import * as Utils from './Utils';
import PluginManager from './plugin/PluginManager';
import { IChannelMessage } from './types';


@Component
export default struct CloakWebview {
  webviewController = new webview.WebviewController();
  channelCloakPort?: webview.WebMessagePort;
  channelClientPort?: webview.WebMessagePort;

  aboutToAppear(): void {
    try {
      webview.WebviewController.setWebDebuggingAccess(Config.IS_DEBUG);
    } catch (error) {
      console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
    }
  }

  initMessageChannel() {
    try {
      const ports = this.webviewController.createWebMessagePorts();
      this.channelClientPort = ports[0];
      this.channelCloakPort = ports[1];

      this.channelCloakPort.onMessageEvent((result: webview.WebMessage) => {

        if (typeof result !== 'string') {
          return;
        }

        const message: IChannelMessage = JSON.parse(result);

        PluginManager.onMessage(message);
      })
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
          if (Config.WEB_VIEW_USE_APP_PERMISSION || !event) {
            event?.geolocation.invoke(event.origin, true, true);
          } else {
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
          if (Config.WEB_VIEW_USE_APP_PERMISSION || !event) {
            event?.request.grant(event.request.getAccessibleResource());
          } else {
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
        .mediaPlayGestureAccess(true)
        .multiWindowAccess(false)
        .allowWindowOpenMethod(false)
        .horizontalScrollBarAccess(false)
        .verticalScrollBarAccess(false)// .keyboardAvoidMode()
        .cacheMode(CacheMode.None)
        .copyOptions(CopyOptions.LocalDevice)
        .blockNetwork(false)
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
          if (Config.APP_USE_REAL_HOST_RESOURCE) {
            return null;
          }
          const requestUrl = event.request.getRequestUrl()


          if (!requestUrl.startsWith(Config.APP_HOST)) {
            return null;
          }

          try {
            const pathname = url.URL.parseURL(requestUrl, Config.APP_HOST).pathname
            const resourceInfo = Utils.getResourceInfo(pathname)
            const mimeType = Utils.getMimeType(resourceInfo.extension)

            let response = new WebResourceResponse()
            response.setResponseData($rawfile(resourceInfo.resourcePath));
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

          this.initMessageChannel();

          if (!this.channelCloakPort) {
            console.error('Cloak Webview init failed');
            return;
          }

          PluginManager.setContext({
            applicationContext: getContext().getApplicationContext(),
            uiContext: this.getUIContext(),
            webviewController: this.webviewController,
            channelCloakPort: this.channelCloakPort,
          });
          PluginManager.registerPlugins();

          // in onControllerAttached function don't need refresh
          // this.webviewController.refresh();


        })
        .onPageBegin((event) => {
          if (this.channelCloakPort) {
            this.channelCloakPort.close();
            this.channelCloakPort = undefined;
            this.channelClientPort = undefined;
          }
        })
        .onPageEnd((event) => {
          // when page reload post message will not work, so must re-ini it again
          PluginManager.initCloakClient().then(() => {
            if (!this.channelCloakPort) {
              this.initMessageChannel();
              if(this.channelCloakPort) {
                PluginManager.updateContext(this.channelCloakPort)
              }
            }
            try {
              this.webviewController.postMessage('Cloak__init_port__', [this.channelClientPort], '*');

            } catch (e) {
              console.error(`ErrorCode: ${(e as BusinessError).code},  Message: ${(e as BusinessError).message}`);
            }

          });
        })
    }
    .width("100%")
    .height("100%")
  }
}
