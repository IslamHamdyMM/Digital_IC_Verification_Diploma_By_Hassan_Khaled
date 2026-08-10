vlib work
vlog Testbench.sv enum_pkg.sv Uart_packet.sv uart_tx.v
vsim -voptargs=+acc work.Testbench
do wave.do
run -all
#quit -sim