// cloak-plugin-app.d.ts
import '@wisdomgarden/cloak';

declare module '@wisdomgarden/cloak' {

  export interface BackButtonEvent {
    canGoBack: boolean;
  }

  export type CloakEventMap = {
    backButton: BackButtonEvent;
  }

  export interface AppPlugin extends PluginBase {
    getMetadata(): PluginMetadata;

    canGoBack(): boolean;

    exitApp(): void;

    addEventListener<K extends keyof CloakEventMap>(
      event: K,
      handler: (event: CloakEventMap[K]) => void
    ): string;

    removeEventListener(event: 'backButton', handlerId?: string): void;

    clearAllEvents(): void;
  }

  export interface CloakPlugins {
    App: AppPlugin;
  }
}