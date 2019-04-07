'use strict'

const electron = require('electron');
const app = electron.app;
const globalShortcut = electron.globalShortcut;
const os = require('os');
const path = require('path');
const rootLib = require('app-root-path');
const appRoot = path.dirname((''+rootLib).replace("resources",""));
const config = require(path.join(__dirname, 'package.json'));
const model = require(path.join(__dirname, 'app', 'model.js'));
const BrowserWindow = electron.BrowserWindow;

app.setName(config.productName);
var mainWindow = null;
app.on('ready', function () {
  mainWindow = new BrowserWindow({
    backgroundColor: 'lightgray',
    title: config.productName,
    show: false,
    webPreferences: {
      nodeIntegration: true,
      defaultEncoding: 'UTF-8'
    }
  })

  model.initDb(appRoot,//app.getPath('userData'),
    // Load a DOM stub here. See renderer.js for the fully composed DOM.
    mainWindow.loadURL(`file:${__dirname}/app/html/index.html`)
  )

  // Enable keyboard shortcuts for Developer Tools on various platforms.
  let platform = os.platform();
  if (platform === 'darwin') {
    globalShortcut.register('Command+Option+I', () => {
      mainWindow.webContents.openDevTools();
    })
  } else if (platform === 'linux' || platform === 'win32') {
    globalShortcut.register('Control+Shift+I', () => {
      mainWindow.webContents.openDevTools();
    })
  }

  mainWindow.once('ready-to-show', () => {
    //mainWindow.setMenu(null);
    mainWindow.show();
  })

  mainWindow.onbeforeunload = (e) => {
    // Prevent Command-R from unloading the window contents.
    e.returnValue = false
  }

  mainWindow.on('closed', function () {
    mainWindow = null
  })
})

app.on('window-all-closed', () => { app.quit() })
const template = [{
  label: "Application",
  submenu: [{
          label: "About Hapag Lloyd-SAP UI Chart Viewer",
          click: function () {
              mainWindow.webContents.send('open-about');
          }
      },
      {
          type: "separator"
      },
      {
          label: "Reload",
          accelerator: "CommandOrControl+Option+J",
          click: function () {
              mainWindow.loadURL(`file:${__dirname}/app/html/index.html`)
              // mainWindow.loadURL(url.format({
              //     pathname: path.join(__dirname, 'index.html'),
              //     protocol: 'file:',
              //     slashes: true
              //   }))
          }
      },
      {
          label: "Toggle Developer Tools",
          accelerator: "CommandOrControl+Option+J",
          click: function () {
              mainWindow.webContents.openDevTools();
          }
      },
      {
          type: "separator"
      },
      {
          label: "Quit",
          accelerator: "CommandOrControl+Q",
          click: function () {
              electron.app.quit();
          }
      }
  ]
},
{
  label: "Edit",
  submenu: [{
          label: "Undo",
          accelerator: "CmdOrCtrl+Z",
          role: "undo"
      },
      {
          label: "Redo",
          accelerator: "Shift+CmdOrCtrl+Z",
          role: "redo"
      },
      {
          type: "separator"
      },
      {
          label: "Cut",
          accelerator: "CmdOrCtrl+X",
          role: "cut"
      },
      {
          label: "Copy",
          accelerator: "CmdOrCtrl+C",
          role: "copy"
      },
      {
          label: "Paste",
          accelerator: "CmdOrCtrl+V",
          role: "paste"
      },
      {
          label: "Select All",
          accelerator: "CmdOrCtrl+A",
          role: "selectall"
      }
  ]
},
{
  label: "Support",
  submenu: [{
          label: "Help",
          click: function () {
              electron.shell.openExternal('https://letztechance.org/contact.html');
          }
      },
      {
          label: "Docs",
          click: function () {
              electron.shell.openExternal('https://letztechance.org/');
          }
      },
      {
          type: "separator"
      },
      {
          label: "Homepage",
          click: function () {
              electron.shell.openExternal('https://letztechance.org/');
          }
      },
  ]
},
{
  label: "Terms of use",
  submenu: [{
          label: "Disclaimer",
          click: function () {
              electron.shell.openExternal('https://letztechance.org');
          }
      }]
},
];
electron.Menu.setApplicationMenu(electron.Menu.buildFromTemplate(template));
