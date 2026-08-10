vlib work
vlog Top.sv opcode_processor.sv +cover=sbecf
vsim -voptargs=+acc work.top -coverage
add wave *
run -all
coverage save top.ucdb -onexit 
vcover report top.ucdb -cvg -details -output cov_report.txt