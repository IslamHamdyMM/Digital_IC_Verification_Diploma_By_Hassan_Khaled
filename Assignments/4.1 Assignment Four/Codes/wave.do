onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Testbench/clk
add wave -noupdate /Testbench/rst_n
add wave -noupdate -format Literal /Testbench/tx
add wave -noupdate -format Literal /Testbench/tx_busy
add wave -noupdate -format Literal /Testbench/tx_start
add wave -noupdate -color Magenta /Testbench/DUT/state
add wave -noupdate -format Literal /Testbench/parity_en
add wave -noupdate -format Literal /Testbench/even_parity
add wave -noupdate /Testbench/data_in
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {6 ns}
