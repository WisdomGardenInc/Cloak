import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { url } from '@kit.ArkTS';
import Config from './Config';
import * as DialogUtils from './DialogUtils';
import * as Utils from './Utils';
import PluginManager from './plugin/PluginManager';
import { IChannelMessage } from './types';
import { window } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';
import Cloak from './Cloak';
import logger from './logger/framework';


// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V13/ts-basic-components-web-V13
// https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/js-apis-webview-V5

@Component
export default struct CloakWebview {
  webviewController = new webview.WebviewController();
  channelCloakPort?: webview.WebMessagePort;
  channelClientPort?: webview.WebMessagePort;
  private pluginsRegistered: boolean = false;

  aboutToAppear(): void {
    if (Config.IS_DEBUG) {
      try {
        webview.WebviewController.setWebDebuggingAccess(Config.IS_DEBUG);
      } catch (error) {
        logger.warn(
          'setWebDebuggingAccess error. ErrorCode: %{public}s,  Message: %{public}s',
          (error as BusinessError).code,
          (error as BusinessError).message,
        );
      }
    }

    this.initSafeArea(getContext() as common.UIAbilityContext)
  }

  private async initSafeArea(context: common.UIAbilityContext): Promise<void> {
    try {
      const mainWindow = await window.getLastWindow(context);

      const avoidAreaTop = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      Cloak.SAFE_TOP = px2vp(avoidAreaTop.topRect.height);

      const avoidAreaBottom = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      Cloak.SAFE_BOTTOM = px2vp(avoidAreaBottom.bottomRect.height);
    } catch (error) {
      logger.error(
        'getWindowAvoidArea error. ErrorCode: %{public}s,  Message: %{public}s',
        (error as BusinessError).code,
        (error as BusinessError).message,
      );
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
      logger.fatal(
        'initMessageChannel error. ErrorCode: %{public}s,  Message: %{public}s',
        (error as BusinessError).code,
        (error as BusinessError).message,
      );
    }
  }

  private interceptExternalLink(request: WebResourceRequest): boolean {
    if (!request.isMainFrame() || !request.isRequestGesture() || request.isRedirect() ||
      request.getRequestMethod() !== 'GET') {
      return false;
    }

    try {
      const destination = url.URL.parseURL(request.getRequestUrl());
      if (destination.protocol !== 'http:' && destination.protocol !== 'https:') {
        return false;
      }
      if (destination.origin === url.URL.parseURL(Config.APP_HOST).origin ||
        Config.APP_ALLOW_NAVIGATION?.includes(destination.hostname)) {
        return false;
      }

      this.openExternalLink(destination.href);
      return true;
    } catch (error) {
      logger.warn('Unable to parse WebView navigation URL: %{public}s', String(error));
      return false;
    }
  }

  private async openExternalLink(uri: string): Promise<void> {
    const want: Want = {
      uri,
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'],
    };

    try {
      await Cloak.getAbility().context.startAbility(want);
    } catch (error) {
      const failure = error as BusinessError;
      logger.error('Unable to open external link. Code: %{public}s, message: %{private}s',
        String(failure.code), failure.message);
      try {
        this.getUIContext().getPromptAction().showToast({ message: $r('app.string.external_link_open_failed') });
      } catch (toastError) {
        logger.warn('Unable to display external link error: %{public}s', String(toastError));
      }
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
        .cacheMode(!Config.IS_DEBUG ? CacheMode.Default : CacheMode.Online)
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
        .onLoadIntercept((event) => {
          return event ? this.interceptExternalLink(event.data) : false;
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
            const request = url.URL.parseURL(requestUrl, Config.APP_HOST);
            if (request.origin !== url.URL.parseURL(Config.APP_HOST).origin) {
              return null;
            }
            const resourceInfo = Utils.getResourceInfo(request.pathname)
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
            logger.warn(
              'Loading h5 resource error. URL: %{public}s, ErrorCode: %{public}s, Message: %{public}s',
              requestUrl,
              (error as BusinessError).code,
              (error as BusinessError).message,
            );
            return null
          }
        })
        .onControllerAttached(() => {
          this.pluginsRegistered = false;
          // user agent
          try {
            const custom_agent_items = [Config.CLOAK_IDENTITY_USER_AGENT]
            if (Config.APP_IDENTITY_USER_AGENT) {
              custom_agent_items.push(Config.APP_IDENTITY_USER_AGENT);
            }
            let userAgent = this.webviewController.getUserAgent() + " " + custom_agent_items.join(" ");
            this.webviewController.setCustomUserAgent(userAgent);
          } catch (error) {
            logger.error(
              'onControllerAttached set userAgent error. ErrorCode: %{public}s,  Message: %{public}s',
              (error as BusinessError).code,
              (error as BusinessError).message,
            );
          }

          this.initMessageChannel();

          if (!this.channelCloakPort) {
            logger.fatal('Cloak Webview init failed');
            return;
          }

          PluginManager.setContext({
            applicationContext: getContext().getApplicationContext(),
            uiContext: this.getUIContext(),
            webviewController: this.webviewController,
            channelCloakPort: this.channelCloakPort,
          });
          this.pluginsRegistered = PluginManager.registerPlugins();

          // in onControllerAttached function don't need refresh
          // this.webviewController.refresh();
          if (this.pluginsRegistered) {
            logger.info('Cloak Webview init success');
          }
        })
        .onPageBegin((event) => {
          if (this.channelCloakPort) {
            this.channelCloakPort.close();
            this.channelCloakPort = undefined;
            this.channelClientPort = undefined;
          }
        })
        .onPageEnd((event) => {
          if (!this.pluginsRegistered) {
            return;
          }
          // when page reload post message will not work, so must re-ini it again
          PluginManager.initCloakClient().then(() => {
            if (!this.channelCloakPort) {
              this.initMessageChannel();
              if (this.channelCloakPort) {
                PluginManager.updateContext(this.channelCloakPort)
              }
            }
            if (!this.channelCloakPort || !this.channelClientPort) {
              throw new Error('Unable to initialize the Cloak message channel.');
            }
            this.webviewController.postMessage('Cloak__init_port__', [this.channelClientPort], '*');
            Cloak.setStartupCompleted();
            logger.info('Cloak Webview initCloakClient success');
          }).catch((error: Error) => {
            logger.fatal('Unable to initialize the Cloak WebView bridge: %{public}s', String(error));
          });
        })
    }
    .width("100%")
    .height("100%")
  }
}
