// Live updates from the server (Server-Sent Events, GET /api/stream).
// After any change (in this browser, another browser or the desktop app) the
// server sends the topic that changed. The app then loads that data again.
// Changes made by this page carry its CLIENT_ID, so they are skipped here.

import { useEffect, useRef } from 'react';

export type Topic = 'events' | 'calendars' | 'settings';
const TOPICS: Topic[] = ['events', 'calendars', 'settings'];

// One id per page load (each tab and each desktop window is its own client).
export const CLIENT_ID =
  typeof crypto !== 'undefined' && 'randomUUID' in crypto
    ? crypto.randomUUID()
    : `${Date.now().toString(36)}-${Math.random().toString(36).slice(2)}`;

type Listener = (topic: Topic) => void;
const listeners = new Set<Listener>();
let source: EventSource | null = null;

function emit(topic: Topic) {
  for (const fn of listeners) fn(topic);
}

function connect() {
  if (source || typeof EventSource === 'undefined') return;
  let wasOpen = false;
  let lost = false;
  source = new EventSource('/api/stream');
  source.onopen = () => {
    // Back after a break (server restart, network, computer asleep):
    // changes may have been missed, so load everything again.
    if (wasOpen && lost) TOPICS.forEach(emit);
    wasOpen = true;
    lost = false;
  };
  source.onerror = () => {
    lost = true; // EventSource retries on its own
  };
  source.onmessage = (e: MessageEvent<string>) => {
    try {
      const msg = JSON.parse(e.data) as { topic?: string; client?: string };
      if (msg.client === CLIENT_ID) return;
      if (TOPICS.includes(msg.topic as Topic)) emit(msg.topic as Topic);
    } catch {
      /* not our message: ignore */
    }
  };
}

// Calls onChange(topic) when data changed somewhere else.
export function useLiveUpdates(onChange: (topic: Topic) => void) {
  const latest = useRef(onChange);
  latest.current = onChange;
  useEffect(() => {
    const fn: Listener = (t) => latest.current(t);
    listeners.add(fn);
    connect();
    return () => {
      listeners.delete(fn);
    };
  }, []);
}
