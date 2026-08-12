vlib work
vlog -cover sbcft opcode_processor.sv Top.sv
vsim -coverage -voptargs=+acc work.top

add wave *
run -all

# Save and generate reports
coverage save coverage_report.ucdb
coverage report -detail -cvg -file functional_coverage.txt
coverage report -detail -codeAll -file code_coverage.txt

# Option to view in GUI before quitting
# quit -sim