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

proc popupMenu {x y} {
	if {[llength [.tree selection]] > 0} {
		tk_popup .popup_menu $x $y
	}
}

proc createGui {} {
	option add *Menu.tearOff 0

	wm title . {GUI for Vagrant}

	menu .mbar
	. configure -menu .mbar
	.mbar add cascade -label [msgcat::mc File] -menu .mbar.file -underline [msgcat::mc File_key]
	.mbar add cascade -label [msgcat::mc View] -menu .mbar.view -underline [msgcat::mc View_key]
	
	menu .mbar.file
	.mbar.file add command -label [msgcat::mc Exit] -underline [msgcat::mc Exit_key] -command { exit }
	
	menu .mbar.view
	.mbar.view add command -label [msgcat::mc Refresh] -underline [msgcat::mc Refresh_key] -command { refresh }

	set columns {id name provider state directory}
	ttk::treeview .tree -columns $columns -displaycolumns $columns -show headings -selectmode browse \
		-xscrollcommand {.hbar set} -yscrollcommand {.vbar set}
	for {set i 0} {$i < [llength $columns]} {incr i} {
		.tree heading #[expr $i+1] -text [lindex $columns $i]
	}
	ttk::scrollbar .hbar -orient horizontal -command {.tree xview}
	ttk::scrollbar .vbar -orient vertical -command {.tree yview}
	grid .tree -row 0 -column 0 -sticky nsew
	grid .vbar -row 0 -column 1 -sticky ns
	grid .hbar -row 1 -column 0 -sticky ew
	grid columnconfigure . 0 -weight 1
	grid rowconfigure . 0 -weight 1

	if {[tk windowingsystem]=="aqua"} {
		bind .tree <ButtonPress-2> { popupMenu %X %Y }
		bind .tree <Control-ButtonPress-1> { popupMenu %X %Y }
	} else {
		bind .tree <ButtonPress-3> {
			popupMenu %X %Y
		}
	}

	menu .popup_menu
	.popup_menu add command -label [msgcat::mc Start] -underline [msgcat::mc Start_key] -command { start [.tree selection] }
	.popup_menu add command -label [msgcat::mc Suspend] -underline [msgcat::mc Suspend_key] -command { suspend [.tree selection] }
	.popup_menu add command -label [msgcat::mc Stop] -underline [msgcat::mc Stop_key] -command { stop [.tree selection] }
	.popup_menu add command -label [msgcat::mc Reload] -underline [msgcat::mc Reload_key] -command { reload [.tree selection] }
}

proc alertDialog {msg} {
	tk_messageBox -icon warning -type ok -message $msg -parent .
}
