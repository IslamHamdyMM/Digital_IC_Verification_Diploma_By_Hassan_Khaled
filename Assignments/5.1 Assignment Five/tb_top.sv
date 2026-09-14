//------------------------------------------------------------------------
// tb_top.sv
// Top-level testbench: generates clk/rst_n, instantiates the DUT and the
// router_if, publishes the virtual interface through uvm_config_db, and
// kicks off UVM via run_test().
//------------------------------------------------------------------------
`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"
import router_pkg::*;

module tb_top;

  logic clk;
  logic rst_n;

  // Clock: 10ns period
  initial clk = 0;
  always #5 clk = ~clk;

  // Active-low reset, released after a couple of clock edges
  initial begin
    rst_n = 0;
    repeat (3) @(posedge clk);
    rst_n = 1;
  end

  router_if vif (.clk(clk), .rst_n(rst_n));

  router dut (
    .clk        (clk),
    .rst_n      (rst_n),
    .data_in0   (vif.data_in0),
    .data_in1   (vif.data_in1),
    .data_in2   (vif.data_in2),
    .data_in3   (vif.data_in3),
    .valid_in0  (vif.valid_in0),
    .valid_in1  (vif.valid_in1),
    .valid_in2  (vif.valid_in2),
    .valid_in3  (vif.valid_in3),
    .data_out0  (vif.data_out0),
    .data_out1  (vif.data_out1),
    .valid_out0 (vif.valid_out0),
    .valid_out1 (vif.valid_out1)
  );

  initial begin
    uvm_config_db#(virtual router_if)::set(null, "*", "vif", vif);
    run_test(); // test name supplied on the command line via +UVM_TESTNAME
  end

  // Safety timeout so a stuck simulation doesn't run forever
  initial begin
    #100000;
    `uvm_fatal("TB_TOP", "Simulation timeout - watchdog expired")
  end

endmodule : tb_top
