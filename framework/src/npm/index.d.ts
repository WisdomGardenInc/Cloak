declare module "@wisdomgarden/cloak" {
  export interface ESObject {
    [key: string]: number | boolean | string | null | undefined | ESObject;
  }

  export type NormalType = ESObject | boolean | string | null | undefined | ESObject;

  export interface MessagePort {
    postMessage(message: string): void;
    onmessage: (event: { data: string }) => void;
  }

  export interface PluginMetadata {
    name: string;
    version: string;
    description: string;
    methods: string[];
  }

  export interface PluginBase {
    name: string;
    // messageHandler?: (message: MessagePayload) => void; // private
    setMessageHandler(callback: (message: NormalType) => void): void;
    onMessage(message: NormalType): void;
    sendMessage(message: NormalType): void;
    register(plugin: Plugin): void;
  }

  export interface Plugin extends PluginBase {
    metadata: PluginMetadata;
    getMetadata: () => PluginMetadata;
    [key: string]: (...args: any) => NormalType | Promise<NormalType>;
  }

  export interface CloakPlugins {
    [pluginName: string]: Plugin;
  }

  export interface Cloak {
    channel: MessagePort;
    plugins: CloakPlugins;
    metadata: PluginMetadata;
    platform: "HarmonyOS";
    getMetadata(): PluginMetadata;
  }

  export const Cloak: Cloak;
}

declare global {
  interface WindowEventMap {
    CloakReady: Event;
  }

  interface Window {
    Cloak: Cloak;
  }
}

export {};
