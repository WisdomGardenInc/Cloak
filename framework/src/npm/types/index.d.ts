export * from "./base";
export * from "./plugins";

import type { MessagePort } from "./base";
import type { PluginMetadata } from "./base";
import type { CloakPlugins } from "./plugins";

export interface CloakMetadata extends PluginMetadata {
  platform: "HarmonyOS";
}

export interface Cloak {
  readonly channel: MessagePort;
  readonly plugins: CloakPlugins;
  readonly metadata: CloakMetadata;
  readonly name: "Cloak";
  readonly registered: boolean;
  getMetadata(): CloakMetadata;
}

export const Cloak: Cloak;

declare global {
  interface WindowEventMap {
    CloakReady: Event;
  }
  interface Window {
    Cloak: Cloak;
  }
}

export {};
