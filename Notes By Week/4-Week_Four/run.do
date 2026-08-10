vlib work
vlog Coverage1.sv design_tst.sv
vsim -voptargs=+acc work.tb
add wave *
run -all
#quit -sim