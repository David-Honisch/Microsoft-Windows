// Small, safe bridge between the page and the desktop app (main.cjs).
// The page uses it from frontend/src/desktop.ts.

const { contextBridge, ipcRenderer } = require('electron');

if (location.protocol === 'file:') {
  // The setup page (setup.html).
  contextBridge.exposeInMainWorld('lc2opencalendarSetup', {
    connect: (url) => ipcRenderer.invoke('lc2opencalendar:connect', String(url)),
  });
} else {
  // The lc2opencalendar web app from the server.
  contextBridge.exposeInMainWorld('lc2opencalendarDesktop', {
    notify: (n) =>
      ipcRenderer.send('lc2opencalendar:notify', {
        title: String(n?.title ?? ''),
        body: String(n?.body ?? ''),
        tag: String(n?.tag ?? ''),
        data: n?.data,
      }),
    showWindow: () => ipcRenderer.send('lc2opencalendar:show-window'),
    onSnooze: (fn) => {
      const listener = (_e, data) => fn(data);
      ipcRenderer.on('lc2opencalendar:snooze', listener);
      return () => ipcRenderer.removeListener('lc2opencalendar:snooze', listener);
    },
  });
}
