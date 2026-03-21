// cloak-plugin-device.d.ts
import '@wisdomgarden/cloak';

declare module '@wisdomgarden/cloak' {

  export interface DeviceInfo {
    appVersion: string;
    appBuild: string;
    appId: string;
    operatingSystem: string;
    osVersion: string;
    platform: string;
    uuid: string;
  }

  export interface DevicePlugin extends PluginBase {
    getMetadata(): PluginMetadata;
    getInfo(): Promise<DeviceInfo>;
    getSystemLanguage(): Promise<string>;
  }

  export interface CloakPlugins {
    Device: DevicePlugin;
  }
}