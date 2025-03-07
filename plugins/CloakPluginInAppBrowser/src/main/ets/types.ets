export interface IBrowserMessageEvent {
  /** the event name */
  type: string;

  /** the URL that was loaded. */
  url: string;

  /** the error code, only in the case of loaderror. */
  code: number;

  /** the error message, only in the case of loaderror. */
  message: string;

  /** the postMessage data, only in the case of message. */
  data: ESObject;
}

export interface ICreateBrowserOptions {
  clearCache?: boolean | null,
  clearSessionCache?: boolean | null,
  session?: string | null,
  closeButtonCaption?: string | null,
  footer?: boolean | null,
  footerColor?: string | null,
  hideNavigationButtons?: boolean | null
}

export type IOpenTarget = "_self" | "_blank" | "_system" | null;


export type IBrowserEvent = "loadstart" | "loadstop" | "loaderror" | "exit"


export interface IBrowserExecutePayload { code: string }

export interface IBrowserEventPayload {
  event: IBrowserEvent;
  url: string
}

export interface IBrowser {
  open: () => boolean,
  close: () => boolean,
  show: () => boolean,
  hide: () => boolean,
  executeScript: (payload: IBrowserExecutePayload) => Promise<ESObject>,
  insertCSS: (payload: IBrowserExecutePayload) => Promise<ESObject>,
  addEventListener: (event: IBrowserEvent, handler: (event: IBrowserEventPayload) => void) => void,
}

export interface IWebviewHooks {
  onPageBegin: (event: OnPageBeginEvent) => void;
  onPageEnd: (event: OnPageEndEvent) => void;
}