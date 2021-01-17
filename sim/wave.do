onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate /tb/reset
add wave -noupdate /tb/de
add wave -noupdate /tb/h_sync
add wave -noupdate /tb/v_sync
add wave -noupdate /tb/red
add wave -noupdate /tb/green
add wave -noupdate /tb/blue
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {7783 ps} 0} {{Cursor 3} {7799 ps} 0} {{Cursor 4} {7811 ps} 0} {{Cursor 5} {7817 ps} 0}
quietly wave cursor active 4
configure wave -namecolwidth 129
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {7769 ps} {7888 ps}
