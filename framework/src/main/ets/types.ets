import { common } from '@kit.AbilityKit';
import { webview } from '@kit.ArkWeb';

export interface IChannelMessage {
  payload: ESObject,
  pluginName: string,
}

export interface ICloakContext {
  applicationContext: common.ApplicationContext;
  uiContext: UIContext;
  webviewController: WebviewController;
  channelCloakPort: webview.WebMessagePort
}