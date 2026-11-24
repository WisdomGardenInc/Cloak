import { bundleManager, Want } from '@kit.AbilityKit';
import Cloak from '../Cloak';
import { CloakPlugin, PluginMethod } from './CloakPlugin';
import { getLogger } from '../logger/index';
import BuildProfile from '../../../../BuildProfile';


export default class App extends CloakPlugin {
  protected _name = 'App';
  protected _version = BuildProfile.HAR_VERSION;
  protected _description = 'Built-in app lifecycle and hardware events plugin';
  private logger = getLogger('AppPlugin');
  private EVENT_BACK_BUTTON = "backButton";

  public get hasBackButtonListeners() {
    return this.hasEvent(this.EVENT_BACK_BUTTON);
  }

  public fireBackButton() {
    if (this.hasBackButtonListeners) {
      this._sendEvent(this.EVENT_BACK_BUTTON, {
        canGoBack: this.canGoBack()
      });
      return;
    }

    if (this.canGoBack()) {
      try {
        CloakPlugin.webviewController.backward();
      } catch (error) {
        this.logger.error('fireBackButton backward error: %{public}s', String(error));
      }
    } else {
      this.exitApp();
    }
  }

  @PluginMethod()
  exitApp() {
    Cloak.getAbility().context.terminateSelf().catch(() => {
    });
  }

  @PluginMethod()
  async openAppGallery(): Promise<void> {
    try {
      const bundleInfo = await bundleManager.getBundleInfoForSelf(
        bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT
      );
      const want: Want = {
        action: 'ohos.want.action.appdetail',
        uri: `store://appgallery.huawei.com/app/detail?id=${bundleInfo.name}`,
      };
      await Cloak.getAbility().context.startAbility(want);
    } catch (error) {
      this.logger.error('openAppGallery error: %{public}s', String(error));
      throw new Error('Unable to open the current app in AppGallery.');
    }
  }

  @PluginMethod()
  canGoBack(): boolean {
    try {
      const result = CloakPlugin.webviewController.accessBackward();
      return result;
    } catch (error) {
      this.logger.error('canGoBack error: %{public}s', String(error));
      return false;
    }
  }
}
