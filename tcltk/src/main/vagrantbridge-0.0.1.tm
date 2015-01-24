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

proc getGlobalStatus {} {
	foreach line [split [exec vagrant global-status] \n] {
		if {[string first "id" $line] == 0} {
			continue
		}
		if {[string first "-----" $line] == 0} {
			continue
		}
		set line [string trim $line]
		if {[string length $line] == 0} {
			break
		}
		set i 0
		foreach column {id name provider state directory} {
		dict append status $column [lindex $line $i]
			incr i
		}
		dict append statuses [dict get $status id] $status
		unset status
	}
	return $statuses
}

proc getVersion {} {
	return [split [lindex [exec vagrant --version] end] .]
}

proc startVm {path} {
	set pwd [pwd]
	cd $path
	puts "Starting VM in $path"
	set output [exec vagrant up]
	cd $pwd
	return $output
}

proc suspendVm {path} {
	set pwd [pwd]
	cd $path
	puts "Suspending VM in $path"
	set output [exec vagrant suspend]
	cd $pwd
	return $output
}

proc stopVm {path} {
	set pwd [pwd]
	cd $path
	puts "Stopping VM in $path"
	set output [exec vagrant halt]
	cd $pwd
	return $output
}

proc reloadVm {path} {
	set pwd [pwd]
	cd $path
	puts "Reloading VM in $path"
	set output [exec vagrant reload]
	cd $pwd
	return $output
}
