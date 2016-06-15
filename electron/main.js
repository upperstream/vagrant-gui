/*
 * Copyright (c) 2016 Upper Stream Software.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

"use strict";

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

/**
 * Retrieves Vagrant version number.
 * @return {string} version number in x.y.z form.
 */
function vagrantGetVersion() {
  let spawnSync = require('child_process').spawnSync('vagrant', ['--version']);
  return spawnSync.stdout.toString().split(/[\t ]+/, 2)[1];
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

const {ipcMain} = require('electron');
ipcMain.on('vagrant-get-version', (event) => {
  try {
    event.returnValue = [vagrantGetVersion(), null];
  } catch (e) {
    event.returnValue = [null, 'Vagrant installation not found'];
  }
});
