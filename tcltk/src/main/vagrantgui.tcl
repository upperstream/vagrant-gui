#!/usr/bin/env wish
#
# Copyright (C) 2015 Upper Stream Software
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package require Tk
package require msgcat

set path [file dirname [info script]]

puts "Locale: [msgcat::mclocale]"
msgcat::mcload [file join $path msgs]

source [file join $path vagrantbridge-0.0.1.tm]
source [file join $path vagrantguitk-0.0.1.tm]

proc refreshTable {statuses} {
	.tree delete [.tree children {}]
	foreach status [dict values $statuses] {
		.tree insert {} end -id [dict get $status id] -values [dict values $status]
	}
}

proc refresh {} {
	global vms
	set vms [getGlobalStatus]
	refreshTable $vms
}

proc getVmStatus {id} {
	global vms
	return [dict get [dict get $vms $id] state]
}

proc getVmDirectory {id} {
	global vms
	return [dict get [dict get $vms $id] directory]
}

proc isVmUp {id} {
	if {[string equal [getVmStatus $id] running]} {
		return 1
	} else {
		return 0
	}
}

proc isVmOff {id} {
	if {[string equal [getVmStatus $id] poweroff]} {
		return 1
	} else {
		return 0
	}
}

proc start {id} {
	if {[isVmUp $id]} {
		alertDialog [msgcat::mc "%s is already up"]
		return
	}
	global vms
	puts [startVm [getVmDirectory $id]]
	refresh
}

proc suspend {id} {
	if {[isVmUp $id] != 1} {
		alertDialog [msgcat::mc "%s is not running"]
		return
	}
	global vms
	puts [suspendVm [getVmDirectory $id]]
	refresh
}

proc stop {id} {
	if {[isVmOff $id]} {
		alertDialog [format [msgcat::mc "%s is already powered off"] $id]
		return
	}
	global vms
	puts [stopVm [getVmDirectory $id]]
	refresh
}

proc reload {id} {
	puts [reloadVm [getVmDirectory $id]]
	refresh
}

if {[catch {lassign [getVersion] major minor micro} errorMessage]} {
	set message [msgcat::mc "Can't find Vagrant (%s)"]
	puts stderr $message
	alertDialog $message
	exit 1
}
if {$major < 1 || $minor < 6} {
	set message [msgcat::mc "Vagrant version must be 1.6 onwards"]
	puts stderr $message
	alertDialog $message
	exit 1
}

createGui
set vms [getGlobalStatus]
refreshTable $vms
