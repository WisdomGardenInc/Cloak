import type { Plugin } from "../base";

export interface DevicePlugin extends Plugin {
  readonly name: "Device";

  /**
   * Retrieves device and application information.
   *
   * @returns Promise resolving to DeviceInfo containing device details.
   */
  getInfo(): Promise<DeviceInfo>;

  /**
   * Gets the current system language.
   *
   * @returns Promise resolving to the language code (e.g., "en", "zh-CN").
   */
  getSystemLanguage(): Promise<string>;
}

/**
 * Device and application identification information.
 */
export interface DeviceInfo {
  /**
   * Installed application version.
   * @example "1.0.0"
   */
  appVersion: string;
  /**
   * Application build number.
   * @example "100"
   */
  appBuild: string;
  /**
   * Unique application identifier assigned by the app store.
   */
  appId: string;
  /**
   * Operating system name.
   * @example "harmonyos"
   */
  operatingSystem: string;
  /**
   * Operating system version.
   * @example "4.0.0"
   */
  osVersion: string;
  /**
   * Platform identifier.
   * @example "harmonyos"
   */
  platform: string;
  /**
   * Unique device identifier.
   * Note: May be masked or restricted on some OS versions.
   */
  uuid: string;
}
