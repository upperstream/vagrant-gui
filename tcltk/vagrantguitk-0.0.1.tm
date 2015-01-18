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

proc createGui {} {
	option add *Menu.tearOff 0
	menu .mbar
	. configure -menu .mbar
	.mbar add cascade -label File -menu .mbar.file -underline 0
	.mbar add cascade -label View -menu .mbar.view -underline 0
	
	menu .mbar.file
	.mbar.file add command -label Exit -underline 1 -command { exit }
	
	menu .mbar.view
	.mbar.view add command -label Refresh -underline 1 -command { refresh }

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

	bind .tree <ButtonPress-3> {
		if {[llength [.tree selection]] > 0} {
			tk_popup .popup_menu %X %Y
		}
	}

	menu .popup_menu
	.popup_menu add command -label Start -underline 0 -command { start [.tree selection] }
	.popup_menu add command -label Suspend -underline 1 -comman { suspend [.tree selection] }
	.popup_menu add command -label Stop -underline 3 -comman { stop [.tree selection] }
}

proc alertDialog {msg} {
	tk_messageBox -icon warning -type ok -message $msg -parent .
}
