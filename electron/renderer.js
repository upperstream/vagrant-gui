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

/**
 * Retrieves Vagrant version number.
 * @return {string} version number in x.y.z form.
 */
function vagrantGetVersion() {
  const {ipcRenderer} = require('electron');
  let returnValue = ipcRenderer.sendSync('vagrant-get-version');
  if (returnValue[1] !== null) {
    throw new Error(returnValue[1]);
  }
  return returnValue[0].split('.', 3);
}

/**
 * Retrieves Vagrant global status.
 * @return {array} array of VM statuses.
 */
function vagrantGetGlobalStatus(listener) {
  const {ipcRenderer} = require('electron');
  ipcRenderer.on('vagrant-get-global-status-async-reply', (event, arg) => {
    listener(arg);
  });
  ipcRenderer.send('vagrant-get-global-status-async');
}

/**
 * Formats a string.
 * Replaces "{i}" in this string (template string) with the designated arguments[i].
 * @param {array} arguments to be inserted into the template string.
 * @return {string} formatted string.
 */
String.prototype.format = function() {
  let returnString = this;
  for (let i = 0; i < arguments.length; ++i) {
    const placeholder = '{' + i + '}';
    returnString = returnString.replace(placeholder, arguments[i]);
  }
  return returnString;
}
