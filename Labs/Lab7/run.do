if {[file exists work]} { vdel -lib work -all }
vlib work
vlog ALU.v
vlog Top.sv
vsim -voptargs=+acc work.top -sv_seed random
add wave *
run -all