export interface ESObject {
  [key: string]: number | boolean | string | null | undefined | ESObject;
}

export type NormalType = ESObject | boolean | string | number | null | undefined;

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
  readonly name: string;
  setMessageHandler(callback: (message: NormalType) => void): void;
  onMessage(message: NormalType): void;
  sendMessage(message: NormalType): void;
  register(plugin: Plugin): void;
}

export interface Plugin extends PluginBase {
  readonly metadata: PluginMetadata;
  getMetadata(): PluginMetadata;
  clearAllEvents(): void;
}
