// Service worker for event notifications.
// It is only needed so desktop notifications can have a "Snooze" button
// (browsers only allow buttons on notifications shown by a service worker).
// Scheduling happens in the page (src/notifications.js), so the calendar tab must be open.

self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', (e) => e.waitUntil(self.clients.claim()));

self.addEventListener('notificationclick', (e) => {
  e.notification.close();
  const data = e.notification.data || {};
  e.waitUntil(
    (async () => {
      const list = await self.clients.matchAll({ type: 'window', includeUncontrolled: true });
      if (e.action === 'snooze') {
        for (const c of list) c.postMessage({ type: 'lc2opencalendar-snooze', data });
        return;
      }
      // Click on the notification itself: bring the calendar to the front.
      if (list.length) await list[0].focus();
      else await self.clients.openWindow('/');
    })(),
  );
});
