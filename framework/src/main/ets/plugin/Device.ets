import { CloakPlugin, PluginMethod } from './CloakPlugin';
import BuildProfile from '../../../../BuildProfile';
import { deviceInfo } from '@kit.BasicServicesKit';
import { bundleManager } from '@kit.AbilityKit';
import { i18n } from '@kit.LocalizationKit';

export interface DeviceInfo {
  appVersion: string;
  appBuild: string;
  appId: string;
  operatingSystem: string;
  osVersion: string;
  platform: string;
  uuid: string;
}

export default class Device extends CloakPlugin {
  protected _name = 'Device';
  protected _version = BuildProfile.HAR_VERSION;
  protected _description = 'Device information plugin';

  @PluginMethod()
  async getInfo(): Promise<DeviceInfo> {
    const bundleInfo = await bundleManager.getBundleInfoForSelf(
      bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT
    );

    const info: DeviceInfo = {
      appVersion: bundleInfo.versionName,
      appBuild: String(bundleInfo.versionCode),
      appId: bundleInfo.name,
      operatingSystem: 'harmonyos',
      osVersion: deviceInfo.osFullName,
      platform: 'harmonyos',
      uuid: deviceInfo.ODID,
    };

    return info;
  }

  @PluginMethod()
  async getSystemLanguage(): Promise<string> {
    return i18n.System.getSystemLanguage();
  }
}