// Bridge to the lc2opencalendar desktop app (desktop/preload.cjs).
// In a normal browser `desktop` is undefined and nothing here is used.

export interface DesktopNotification {
  title: string;
  body: string;
  tag: string;
  // Sent back to the page when the user clicks "Snooze".
  data: unknown;
}

export interface DesktopBridge {
  // Native notification. Shows even when the window is closed (the app keeps running in the tray).
  notify(n: DesktopNotification): void;
  // Brings the window to the front (used for in-page alerts).
  showWindow(): void;
  // Called with the notification's `data` when its Snooze button is clicked.
  onSnooze(fn: (data: unknown) => void): () => void;
}

export const desktop: DesktopBridge | undefined = (window as unknown as { lc2opencalendarDesktop?: DesktopBridge })
  .lc2opencalendarDesktop;
