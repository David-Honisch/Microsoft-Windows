// lc2opencalendar desktop app (Electron main process).
//
// - Shows the web app of an lc2opencalendar server (the user enters its URL once).
// - Closing the window only hides it: the app keeps running in the tray, so
//   the page keeps checking reminders and shows native notifications.
// - "Quit" in the tray menu really quits.
// - Data is never stored here: it lives on the server, so web and desktop stay
//   in sync (the page gets live updates from the server).

const { app, BrowserWindow, Menu, Notification, Tray, ipcMain, nativeImage, net, shell } = require('electron');
const fs = require('node:fs');
const path = require('node:path');
const { pathToFileURL } = require('node:url');

const APP_ID = 'org.lc2opencalendar.desktop';
const ICON = path.join(__dirname, 'icons', 'icon.png');
const TRAY_ICON = path.join(__dirname, 'icons', process.platform === 'win32' ? 'icon-16.png' : 'icon-32.png');
const SETUP_PAGE = path.join(__dirname, 'setup.html');
const SETUP_URL = pathToFileURL(SETUP_PAGE).href;
const startHidden = process.argv.includes('--hidden'); // used when started at login

let win = null;
let tray = null;
let quitting = false;
// Notifications must stay referenced, or their click/Snooze handlers are lost.
const shown = new Map();

// ---- Config (server URL) ----

const configFile = () => path.join(app.getPath('userData'), 'config.json');

function readConfig() {
  try {
    return JSON.parse(fs.readFileSync(configFile(), 'utf8'));
  } catch {
    return {};
  }
}

function writeConfig(patch) {
  const next = { ...readConfig(), ...patch };
  fs.mkdirSync(path.dirname(configFile()), { recursive: true });
  fs.writeFileSync(configFile(), JSON.stringify(next, null, 2));
  return next;
}

// "lc2opencalendar.example.com" → "https://lc2opencalendar.example.com". Returns '' when invalid.
function cleanServerUrl(raw) {
  let text = String(raw || '').trim();
  if (!text) return '';
  if (!/^https?:\/\//i.test(text)) text = `${/^(localhost|127\.|\[::1\])/.test(text) ? 'http' : 'https'}://${text}`;
  try {
    const u = new URL(text);
    if (u.protocol !== 'http:' && u.protocol !== 'https:') return '';
    // Keep a sub-path (reverse proxy), drop query and hash.
    return `${u.origin}${u.pathname.replace(/\/+$/, '')}`;
  } catch {
    return '';
  }
}

const serverUrl = () => cleanServerUrl(readConfig().serverUrl);
const serverOrigin = () => {
  const url = serverUrl();
  return url ? new URL(url).origin : '';
};

async function frontendServerError(url) {
  let response;
  try {
    response = await net.fetch(`${url}/`, { signal: AbortSignal.timeout(8000) });
  } catch (err) {
    return `Could not reach ${url}: ${err.message}`;
  }

  const html = await response.text();
  if (html.includes('The frontend is not built into this binary.')) {
    return `${url} is running, but its backend binary does not include the frontend. Rebuild the server with "npm run build:app" and restart it.`;
  }
  if (!response.ok || !response.headers.get('content-type')?.includes('text/html') ||
      !html.includes('id="root"')) {
    return `${url} does not serve a built lc2opencalendar frontend. Rebuild the server with "npm run build:app" and restart it.`;
  }
  return '';
}

// ---- Window ----

function showSetup(error) {
  const query = { server: serverUrl() };
  if (error) query.error = error;
  win.loadFile(SETUP_PAGE, { query });
}

async function loadServer() {
  const url = serverUrl();
  if (!url) {
    showSetup();
    return;
  }
  const error = await frontendServerError(url);
  if (error) {
    showSetup(error);
    return;
  }
  win.loadURL(`${url}/`);
}

function showWindow() {
  if (!win) return;
  if (win.isMinimized()) win.restore();
  win.show();
  win.focus();
}

function createWindow() {
  win = new BrowserWindow({
    width: 1280,
    height: 850,
    minWidth: 360,
    minHeight: 480,
    show: false,
    title: 'lc2opencalendar',
    icon: ICON,
    autoHideMenuBar: true,
    webPreferences: {
      preload: path.join(__dirname, 'preload.cjs'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: true,
      // Keep timers running at full speed while hidden, so reminders show on time.
      backgroundThrottling: false,
      // The notification chime must play without a click first.
      autoplayPolicy: 'no-user-gesture-required',
    },
  });

  win.once('ready-to-show', () => {
    if (!startHidden) win.show();
  });

  // Closing hides the window; the app stays in the tray.
  win.on('close', (e) => {
    if (!quitting) {
      e.preventDefault();
      win.hide();
    }
  });

  // Server not reachable: show the setup page with the error.
  win.webContents.on('did-fail-load', (_e, code, desc, url, isMainFrame) => {
    if (!isMainFrame || code === -3 /* aborted */ || url.startsWith('file:')) return;
    showSetup(`Could not open ${url} (${desc}).`);
  });

  // The page crashed (it may be hidden for days): load it again, or reminders would stop.
  win.webContents.on('render-process-gone', (_e, details) => {
    if (!quitting && details.reason !== 'clean-exit') setTimeout(loadServer, 1000);
  });

  // Links to other sites open in the normal browser.
  const external = (url) => {
    if (/^https?:\/\//i.test(url) || /^mailto:/i.test(url)) shell.openExternal(url);
  };
  win.webContents.setWindowOpenHandler(({ url }) => {
    external(url);
    return { action: 'deny' };
  });
  win.webContents.on('will-navigate', (e, url) => {
    if (url.split('?')[0] === SETUP_URL) return;
    try {
      if (new URL(url).origin === serverOrigin()) return;
    } catch {
      /* bad URL: block */
    }
    e.preventDefault();
    external(url);
  });

  // The app needs no browser permissions (notifications are native).
  win.webContents.session.setPermissionRequestHandler((_wc, permission, done) =>
    done(permission === 'clipboard-sanitized-write'),
  );

  loadServer();
}

// ---- Notifications (called from the page through preload.cjs) ----

function notify(sender, { title, body, tag, data }) {
  if (!Notification.isSupported()) return;
  shown.get(tag)?.close();
  const n = new Notification({
    title: String(title || 'lc2opencalendar'),
    body: String(body || ''),
    icon: ICON,
    silent: true, // the page plays its own sound (if turned on)
    // Buttons work on macOS and Windows. On Linux they depend on the desktop.
    actions: [{ type: 'button', text: 'Snooze' }],
  });
  const forget = () => shown.delete(tag);
  n.on('click', () => {
    forget();
    showWindow();
  });
  n.on('action', () => {
    forget();
    if (!sender.isDestroyed()) sender.send('lc2opencalendar:snooze', data);
  });
  n.on('close', forget);
  n.on('failed', forget);
  shown.set(tag, n);
  n.show();
}

// Only the lc2opencalendar page itself may use the bridge.
const fromServer = (e) => {
  try {
    return e.senderFrame && new URL(e.senderFrame.url).origin === serverOrigin();
  } catch {
    return false;
  }
};
const fromSetup = (e) => e.senderFrame?.url.split('?')[0] === SETUP_URL;

ipcMain.on('lc2opencalendar:notify', (e, n) => {
  if (fromServer(e) && n && typeof n === 'object') notify(e.sender, n);
});
ipcMain.on('lc2opencalendar:show-window', (e) => {
  if (fromServer(e)) showWindow();
});

// Setup page: check that the URL is an lc2opencalendar server, then save it.
ipcMain.handle('lc2opencalendar:connect', async (e, raw) => {
  if (!fromSetup(e)) return { error: 'Not allowed.' };
  const url = cleanServerUrl(raw);
  if (!url) return { error: 'Enter a server address, like http://localhost:10085.' };
  try {
    const res = await net.fetch(`${url}/api/health`, { signal: AbortSignal.timeout(8000) });
    const body = await res.json().catch(() => null);
    if (!res.ok || body?.status !== 'ok') return { error: `${url} does not look like an lc2opencalendar server.` };
  } catch (err) {
    return { error: `Could not reach ${url}: ${err.message}` };
  }
  const frontendError = await frontendServerError(url);
  if (frontendError) return { error: frontendError };
  writeConfig({ serverUrl: url });
  updateTrayMenu();
  loadServer();
  return { ok: true };
});

// ---- Start at login ----

// Linux has no system API for this in Electron, so write an autostart file.
const linuxAutostartFile = () => path.join(app.getPath('appData'), 'autostart', 'lc2opencalendar.desktop');

function startsAtLogin() {
  if (process.platform === 'linux') return fs.existsSync(linuxAutostartFile());
  return app.getLoginItemSettings().openAtLogin;
}

function setStartAtLogin(on) {
  if (process.platform !== 'linux') {
    app.setLoginItemSettings({ openAtLogin: on, args: ['--hidden'] });
    return;
  }
  const file = linuxAutostartFile();
  if (!on) {
    fs.rmSync(file, { force: true });
    return;
  }
  // An AppImage moves its files on each start; its own path is in APPIMAGE.
  const exe = process.env.APPIMAGE || process.execPath;
  const args = app.isPackaged ? '' : ` "${app.getAppPath()}"`;
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(
    file,
    ['[Desktop Entry]', 'Type=Application', 'Name=lc2opencalendar', `Exec="${exe}"${args} --hidden`, 'X-GNOME-Autostart-enabled=true', ''].join(
      '\n',
    ),
  );
}

// ---- Tray ----

function updateTrayMenu() {
  if (!tray) return;
  tray.setContextMenu(
    Menu.buildFromTemplate([
      { label: 'Open lc2opencalendar', click: showWindow },
      { label: 'Reload', click: () => (showWindow(), loadServer()) },
      { label: 'Change server…', click: () => (showWindow(), showSetup()) },
      { type: 'separator' },
      {
        label: 'Start at login',
        type: 'checkbox',
        checked: startsAtLogin(),
        click: (item) => {
          setStartAtLogin(item.checked);
          updateTrayMenu();
        },
      },
      { type: 'separator' },
      { label: 'Quit lc2opencalendar', click: () => app.quit() },
    ]),
  );
}

function createTray() {
  tray = new Tray(nativeImage.createFromPath(TRAY_ICON));
  tray.setToolTip('lc2opencalendar');
  tray.on('click', showWindow); // Windows and some Linux desktops
  updateTrayMenu();
}

// ---- App ----

if (!app.requestSingleInstanceLock()) {
  app.quit();
} else {
  app.setAppUserModelId(APP_ID); // Windows: needed for notifications
  app.on('second-instance', showWindow);
  app.on('before-quit', () => {
    quitting = true;
  });
  // macOS: clicking the dock icon opens the window.
  app.on('activate', showWindow);
  // Keep running when all windows are hidden (the window is never really closed).
  app.on('window-all-closed', () => {});

  app.whenReady().then(() => {
    if (process.platform !== 'darwin') Menu.setApplicationMenu(null);
    createWindow();
    createTray();
  });
}
