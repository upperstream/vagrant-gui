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

set path [file dirname [file normalize $argv0]]
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
		alertDialog "$id is already up"
		return
	}
	global vms
	puts [startVm [getVmDirectory $id]]
	refresh
}

proc suspend {id} {
	if {[isVmUp $id] != 1} {
		alertDialog "$id is not running"
		return
	}
	global vms
	puts [suspendVm [getVmDirectory $id]]
	refresh
}

proc stop {id} {
	if {[isVmOff $id]} {
		alertDialog "$id is already powered off"
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

createGui
set vms [getGlobalStatus]
refreshTable $vms
