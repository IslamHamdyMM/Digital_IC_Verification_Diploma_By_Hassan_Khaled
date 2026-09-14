#------------------------------------------------------------------------
# run.do  -  Assignment 5 automation script (ModelSim / Questa)
#
# Compiles the DUT + full UVM testbench once, then elaborates and runs.
# The ONLY thing that changes between the four required runs is the
# +UVM_VERBOSITY plusarg passed as an argument to this script - no
# source file is ever edited between runs.
#
# Usage (from the ModelSim/Questa "do" prompt, an OS shell, or a batch
# script), run once per verbosity level:
#
#   vsim -c -do "do run.do UVM_LOW"
#   vsim -c -do "do run.do UVM_MEDIUM"
#   vsim -c -do "do run.do UVM_HIGH"
#   vsim -c -do "do run.do UVM_FULL"
#
# Or, equivalently, from an OS shell in batch mode:
#   vsim -c -do "do run.do UVM_LOW; quit -f"
#------------------------------------------------------------------------

# ---- resolve requested verbosity (defaults to UVM_MEDIUM if omitted) --
if {[info exists 1]} {
    set VERBOSITY $1
} else {
    set VERBOSITY "UVM_MEDIUM"
}
echo "=== run.do: requested verbosity = $VERBOSITY ==="

# ---- clean + (re)build the work library --------------------------------
if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vmap work work

# ---- compile DUT ---------------------------------------------------------
vlog -sv +incdir+. router.v

# ---- compile interface (must precede the package: classes inside the
#      package reference the global "router_if" type) --------------------
vlog -sv +incdir+. router_if.sv

# ---- locate UVM headers (uvm_macros.svh) ---------------------------------
# Prefer an explicitly-set UVM_HOME. If it isn't set, fall back to no extra
# +incdir - most Questa installs already resolve `include "uvm_macros.svh"
# against their bundled UVM library without any extra path. If your
# compile fails on uvm_macros.svh, set UVM_HOME once before calling this
# script, e.g. (Transcript window):
#   set env(UVM_HOME) {C:/questasim64_10.6c/verilog_src/uvm-1.2}
if {[info exists ::env(UVM_HOME)]} {
    set UVM_INC "+incdir+$::env(UVM_HOME)/src"
    echo "=== run.do: using UVM_HOME=$::env(UVM_HOME) ==="
} else {
    set UVM_INC ""
    echo "=== run.do: UVM_HOME not set, compiling without extra +incdir ==="
}

# ---- compile the UVM package (pulls in every class via `include) --------
eval vlog -sv +incdir+. $UVM_INC router_pkg.sv

# ---- compile the top-level testbench module ------------------------------
eval vlog -sv +incdir+. $UVM_INC tb_top.sv

# ---- elaborate and run ----------------------------------------------------
vsim -c -voptargs="+acc" work.tb_top +UVM_TESTNAME=router_base_test +UVM_VERBOSITY=$VERBOSITY

run -all

# Only force-quit the whole tool when this script was launched in batch
# mode (vsim -c -do run.do ...). If you typed "do run.do UVM_LOW" inside
# an already-open GUI session, keep the GUI open afterward so you can
# inspect the transcript / waveforms.
if {[batch_mode]} {
    quit -f
}
