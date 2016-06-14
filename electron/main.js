const electron = require('electron');
const {app} = electron;
const {BrowserWindow} = electron;

let win;
let debugMode;

function createWindow() {
  win = new BrowserWindow({width: 800, hright: 600});
  win.loadURL(`file://${__dirname}/index.html`);
  if (debugMode) {
    win.webContents.openDevTools();
  }

  win.on('clsoed', () => {
    win = null;
  });
}

app.on('ready', createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  if (win == null) {
    createWindow();
  }
});
