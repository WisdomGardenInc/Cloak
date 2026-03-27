import type { Plugin } from "../base";

export interface AppPlugin extends Plugin {
  readonly name: "App";

  /**
   * Checks whether the current page can navigate back.
   *
   * @returns Promise resolving to true if back navigation is possible, false otherwise.
   */
  canGoBack(): Promise<boolean>;

  /**
   * Terminates the current application.
   * Note: Behavior may be restricted by the OS on certain devices.
   */
  exitApp(): Promise<void>;

  /**
   * Registers a handler for app events.
   *
   * @param event - The event to listen for (e.g., "backButton").
   * @param handler - Callback invoked when the event fires.
   * @returns Handler ID, used to remove the listener later.
   */
  addListener(event: "backButton", handler: BackButtonHandler): string;

  /**
   * Removes a registered event listener.
   *
   * @param event - The event type.
   * @param handlerId - Optional handler ID. If omitted, removes all handlers for this event.
   */
  removeEventListener(event: "backButton", handlerId?: string): Promise<void>;
}

/**
 * Callback function type for handling back button events.
 */
export type BackButtonHandler = (backButton: BackButtonEvent) => void;

/**
 * Event payload emitted when the back button is pressed.
 */
export interface BackButtonEvent {
  /**
   * Indicates whether the app can navigate back in its navigation stack
   */
  canGoBack: boolean;
}
