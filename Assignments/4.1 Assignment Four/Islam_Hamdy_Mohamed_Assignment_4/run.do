vlib work
vlog -cover sbcft Testbench.sv enum_pkg.sv Uart_packet.sv uart_tx.v
vsim -coverage -voptargs=+acc work.Testbench
do wave.do
run -all

# Save and generate reports
coverage save coverage_report.ucdb
coverage report -detail -cvg -file functional_coverage.txt
coverage report -detail -codeAll -file code_coverage.txt

# Option to view in GUI before quitting
# quit -sim