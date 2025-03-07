import { Plugin, Cloak, ESObject, CloakPlugins } from "@wisdomgarden/cloak";

// the type prefixed with `I` means it is copied from ets definition
export interface IBrowserExecutePayload {
  code: string;
}
export type IBrowserEvent = "loadstart" | "loadstop" | "loaderror" | "exit";
export type IOpenTarget = "_self" | "_blank" | "_system" | null;

export interface ICreateBrowserOptions {
  clearCache?: boolean | null;
  clearcache?: boolean | null;
  clearSessionCache?: boolean | null;
  clearsessioncache?: boolean | null;
  session?: string | null;
  closeButtonCaption?: string | null;
  closebuttoncaption?: string | null;
  footer?: boolean | null;
  footerColor?: string | null;
  footercolor?: string | null;
  hideNavigationButtons?: boolean | null;
  hidenavigationbuttons?: boolean | null;
}

export interface IBrowserEventPayload {
  event: IBrowserEvent;
  url: string;
}

export interface InAppBrowserObject {
  open: () => boolean;
  close: () => boolean;
  show: () => boolean;
  hide: () => boolean;
  executeScript: (payload: IBrowserExecutePayload) => Promise<ESObject>;
  insertCSS: (payload: IBrowserExecutePayload) => Promise<ESObject>;
  addEventListener: (event: IBrowserEvent, handler?: (event: IBrowserEventPayload) => void) => void;
}

export interface InAppBrowserInstanceRxjs extends InAppBrowserObject {
  on: (event: IBrowserEvent) => {
    subscribe: (handler: (event: IBrowserEventPayload) => void) => void;
  };
}

export interface InAppBrowserPlugin extends Plugin {
  currentBrowser: InAppBrowserObject | null;
  create(url: string, target?: IOpenTarget, options?: ICreateBrowserOptions): InAppBrowserObject;
  createBrowser(url: string, target?: string, options?: ICreateBrowserOptions): InAppBrowserObject;
}

export const register: () => void;
export const InAppBrowser: InAppBrowserPlugin;

declare module "@wisdomgarden/cloak" {
  export interface CloakPlugins {
    InAppBrowser: InAppBrowserPlugin;
  }
}
