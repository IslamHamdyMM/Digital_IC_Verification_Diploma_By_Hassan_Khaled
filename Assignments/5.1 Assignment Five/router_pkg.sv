//------------------------------------------------------------------------
// router_pkg.sv
// Package that pulls together every UVM class in the correct
// dependency order. router_if.sv is NOT included here because
// interfaces cannot live inside a package - it is compiled/imported
// separately (see tb_top.sv).
//------------------------------------------------------------------------
package router_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "router_config.sv"
  `include "router_seq_item.sv"
  `include "router_sequence.sv"
  `include "router_sequencer.sv"
  `include "router_driver.sv"
  `include "router_monitor.sv"
  `include "router_agent.sv"
  `include "router_coverage.sv"
  `include "router_scoreboard.sv"
  `include "router_env.sv"
  `include "router_test.sv"

endpackage : router_pkg
