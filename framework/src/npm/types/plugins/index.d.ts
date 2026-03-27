export * from "./app";
export * from "./device";

import type { AppPlugin } from "./app";
import type { DevicePlugin } from "./device";

export interface CloakPlugins {
  App: AppPlugin;
  Device: DevicePlugin;
}
