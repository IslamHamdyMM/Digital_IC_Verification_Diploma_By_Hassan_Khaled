vlib work
vlog multi_op_processor_tb.sv multi_op_processor.sv
vsim -voptargs=+acc work.multi_op_processor_tb
add wave *
run -all
#quit -sim