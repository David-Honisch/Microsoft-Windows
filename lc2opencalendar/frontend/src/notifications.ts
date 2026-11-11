// Event notifications (reminders), like the classic calendar:
// - Each event has reminders: minutes before its start.
// - The open calendar tab checks every few seconds which reminders are due,
//   and shows them as desktop notifications or as an alert in the page.
// - Desktop notifications have a "Snooze" button. A snoozed notification shows
//   again "snoozeBefore" minutes before the event.
// Nothing is sent by the server, so notifications only show while a tab is open,
// or while the desktop app runs (it keeps its page running in the tray when the window is closed).

import { useCallback, useEffect, useRef, useState } from 'react';
import { api } from './api';
import { desktop } from './desktop';
import * as T from './time';
import type { CalendarEvent, Settings } from './types';

// The minimal event data kept for a notification.
export interface SlimEvent {
  id: number;
  title: string;
  start: number;
  end: number;
}

// A reminder to show. `key` is unique for each event, start and reminder.
export interface NotificationItem {
  key: string;
  event: SlimEvent;
}

interface Snoozed extends NotificationItem {
  at: number;
}

export type Permission = NotificationPermission | 'unsupported';

// Choices offered in the event form and in settings (minutes before the event).
export const REMINDER_PRESETS = [0, 5, 10, 15, 30, 60, 120, 1440, 2880, 10080];
export const MAX_REMINDERS = 5; // same limit as the backend

const SHOWN_KEY = 'lc2opencalendar.notified'; // { key: shownAt } (shared by all tabs)
const SNOOZED_KEY = 'lc2opencalendar.snoozed'; // [{ key, at, event }]
const TICK = 10 * 1000;
const REFETCH_EVERY = 5 * T.MINUTE;
const FETCH_AHEAD = 29 * T.DAY; // longest reminder is 4 weeks
const LATE_LIMIT = 10 * T.MINUTE; // don't show reminders that are older than this (tab was closed, computer asleep)
const SNOOZE_LATER = 5 * T.MINUTE; // when the snooze time has already passed

function readStore<V>(key: string, initial: V): V {
  try {
    const raw = localStorage.getItem(key);
    return raw === null ? initial : JSON.parse(raw);
  } catch {
    return initial;
  }
}

function writeStore(key: string, value: unknown) {
  try {
    localStorage.setItem(key, JSON.stringify(value));
  } catch {
    /* storage not available: ignore */
  }
}

// ---- Browser permission ----

// "unsupported", "default", "granted" or "denied".
export function notificationPermission(): Permission {
  if (desktop) return 'granted'; // the desktop app shows native notifications itself
  if (typeof Notification === 'undefined' || !window.isSecureContext) return 'unsupported';
  return Notification.permission;
}

export async function requestNotificationPermission(): Promise<Permission> {
  if (desktop) return 'granted';
  if (notificationPermission() === 'unsupported') return 'unsupported';
  try {
    return await Notification.requestPermission();
  } catch {
    return Notification.permission;
  }
}

let swRegistration: ServiceWorkerRegistration | null = null;
function registerServiceWorker() {
  if (desktop) return; // the desktop app has its own notifications with Snooze
  if (!('serviceWorker' in navigator) || !window.isSecureContext) return;
  navigator.serviceWorker.register('/sw.js').then(
    (reg) => {
      swRegistration = reg;
    },
    () => {
      /* no service worker: notifications have no Snooze button */
    },
  );
}

// ---- Sound ----

let audio: AudioContext | null = null;
function audioContext() {
  if (!audio) {
    // Older Safari only has the prefixed name.
    const Ctx =
      window.AudioContext ||
      (window as unknown as { webkitAudioContext?: typeof AudioContext }).webkitAudioContext;
    if (!Ctx) return null;
    audio = new Ctx();
  }
  if (audio.state === 'suspended') audio.resume().catch(() => {});
  return audio;
}

// A short two-note chime, made in code (no sound file to ship).
export function playChime() {
  const ctx = audioContext();
  if (!ctx) return;
  const t0 = ctx.currentTime + 0.05;
  (
    [
      [880, 0],
      [1318.5, 0.18],
    ] as const
  ).forEach(([freq, delay]) => {
    const osc = ctx.createOscillator();
    const gain = ctx.createGain();
    osc.type = 'sine';
    osc.frequency.value = freq;
    gain.gain.setValueAtTime(0.0001, t0 + delay);
    gain.gain.exponentialRampToValueAtTime(0.25, t0 + delay + 0.02);
    gain.gain.exponentialRampToValueAtTime(0.0001, t0 + delay + 0.7);
    osc.connect(gain).connect(ctx.destination);
    osc.start(t0 + delay);
    osc.stop(t0 + delay + 0.75);
  });
}

// ---- Showing ----

async function showDesktop(item: NotificationItem, body: string) {
  const { event } = item;
  const title = event.title || '(No title)';
  if (desktop) {
    desktop.notify({ title, body, tag: item.key, data: { key: item.key, event } });
    return;
  }
  const options: NotificationOptions = {
    body,
    tag: item.key,
    icon: '/logo.svg',
    silent: true, // the page plays its own sound (if turned on)
    data: { key: item.key, event },
  };
  if (swRegistration) {
    // `actions` only works for notifications shown by a service worker.
    await swRegistration.showNotification(title, {
      ...options,
      actions: [{ action: 'snooze', title: 'Snooze' }],
    } as NotificationOptions);
    return;
  }
  const n = new Notification(title, options);
  n.onclick = () => {
    window.focus();
    n.close();
  };
}

// The minimal event data kept for a notification (it is stored and sent to the service worker).
const slim = (e: CalendarEvent): SlimEvent => ({ id: e.id, title: e.title, start: e.start, end: e.end });

// Keeps track of due reminders and shows them.
// describe(event) gives the text under the title ("Friday, 11/6/2026 · 10 – 11am").
// changeKey: anything that changes when events are saved, so the list is loaded again.
export function useNotifications({
  settings,
  describe,
  changeKey,
}: {
  settings: Settings;
  describe: (event: SlimEvent) => string;
  changeKey: unknown;
}) {
  const off = settings.notifications === 'off';
  const [alerts, setAlerts] = useState<NotificationItem[]>([]); // in-page alerts: [{ key, event }]
  const upcoming = useRef<CalendarEvent[]>([]);
  const shownHere = useRef(new Set<string>());
  const latest = useRef({ settings, describe });
  latest.current = { settings, describe };

  // Show each reminder once, also when several tabs are open.
  const claim = (key: string) => {
    if (shownHere.current.has(key)) return false;
    shownHere.current.add(key);
    const now = Date.now();
    const shown = readStore<Record<string, number>>(SHOWN_KEY, {});
    if (shown[key]) return false;
    for (const k of Object.keys(shown)) if (now - shown[k] > 2 * T.DAY) delete shown[k];
    shown[key] = now;
    writeStore(SHOWN_KEY, shown);
    return true;
  };

  const show = (item: NotificationItem) => {
    const { settings: s, describe: d } = latest.current;
    if (s.notificationSound) playChime();
    const toAlert = () => {
      setAlerts((list) => [...list, item]);
      desktop?.showWindow(); // the window may be closed to the tray
    };
    if (s.notifications === 'desktop' && notificationPermission() === 'granted') {
      // If the browser refuses, the user still sees the alert in the page.
      showDesktop(item, d(item.event)).catch(toAlert);
    } else {
      // "Alerts", or desktop notifications that the browser does not allow.
      toAlert();
    }
  };

  const tick = () => {
    if (latest.current.settings.notifications === 'off') return;
    const now = Date.now();
    const due: NotificationItem[] = [];
    for (const e of upcoming.current) {
      for (const m of e.reminders || []) {
        const at = e.start - m * T.MINUTE;
        if (at <= now && now - at < LATE_LIMIT && now < e.end) {
          due.push({ key: `${e.id}:${e.start}:${m}`, event: slim(e) });
        }
      }
    }
    const snoozed = readStore<Snoozed[]>(SNOOZED_KEY, []);
    const waiting = snoozed.filter((s) => s.at > now);
    for (const s of snoozed) {
      if (s.at <= now && now < s.event.end) due.push({ key: `${s.key}:snooze:${s.at}`, event: s.event });
    }
    if (waiting.length !== snoozed.length) writeStore(SNOOZED_KEY, waiting);
    for (const item of due) if (claim(item.key)) show(item);
  };
  const tickRef = useRef(tick);
  tickRef.current = tick;

  const snooze = useCallback((data: NotificationItem | undefined) => {
    if (!data?.event) return;
    const { event, key } = data;
    const now = Date.now();
    let at = event.start - latest.current.settings.snoozeBefore * T.MINUTE;
    if (at <= now) at = now + SNOOZE_LATER;
    const list = readStore<Snoozed[]>(SNOOZED_KEY, []).filter((s) => s.key !== key);
    list.push({ key, at, event });
    writeStore(SNOOZED_KEY, list);
  }, []);

  // Service worker (for the Snooze button) and unlocking sound on the first click.
  useEffect(() => {
    registerServiceWorker();
    const onMessage = (e: MessageEvent) => e.data?.type === 'lc2opencalendar-snooze' && snooze(e.data.data);
    navigator.serviceWorker?.addEventListener('message', onMessage);
    const offDesktop = desktop?.onSnooze((data) => snooze(data as NotificationItem));
    const unlock = () => {
      if (latest.current.settings.notificationSound) audioContext();
    };
    window.addEventListener('pointerdown', unlock, true);
    window.addEventListener('keydown', unlock, true);
    return () => {
      navigator.serviceWorker?.removeEventListener('message', onMessage);
      offDesktop?.();
      window.removeEventListener('pointerdown', unlock, true);
      window.removeEventListener('keydown', unlock, true);
    };
  }, [snooze]);

  // Load the events that can have a reminder soon.
  useEffect(() => {
    if (off) return undefined;
    let cancelled = false;
    const load = () => {
      const now = Date.now();
      api.listEvents(now - T.HOUR, now + FETCH_AHEAD).then(
        (list) => {
          if (cancelled) return;
          upcoming.current = list;
          tickRef.current();
        },
        () => {
          /* offline: keep the last list */
        },
      );
    };
    load();
    const id = setInterval(load, REFETCH_EVERY);
    return () => {
      cancelled = true;
      clearInterval(id);
    };
  }, [off, changeKey]);

  useEffect(() => {
    if (off) return undefined;
    const id = setInterval(() => tickRef.current(), TICK);
    return () => clearInterval(id);
  }, [off]);

  // Show the reminder in the tab title too, so it is seen in a background tab.
  useEffect(() => {
    const base = 'lc2opencalendar';
    document.title = alerts.length ? `🔔 ${alerts[0].event.title || '(No title)'} – ${base}` : base;
  }, [alerts]);

  const dismissAlerts = useCallback(() => setAlerts([]), []);
  return { alerts, dismissAlerts };
}
