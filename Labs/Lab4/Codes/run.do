vlib work
vlog adder.sv lab4_tb.sv
vsim -voptargs=+acc work.lab4_tb
add wave *
run -all
#quit -sim