module router (
  input          clk,
  input          rst_n,
  input   [7:0]  data_in0,
  input   [7:0]  data_in1,
  input   [7:0]  data_in2,
  input   [7:0]  data_in3,
  input          valid_in0,
  input          valid_in1,
  input          valid_in2,
  input          valid_in3,
  output  [7:0]  data_out0,
  output  [7:0]  data_out1,
  output         valid_out0,
  output         valid_out1
);
  // Simple routing: even-numbered inputs go to out0, odd to out1
  //
  // BUG-CHECK NOTE (Assignment 5): clk and rst_n are declared ports but
  // are never referenced below - the module is purely combinational.
  // This was deliberately NOT "fixed" by registering the outputs,
  // because doing so would change the DUT's documented protocol timing
  // (same-cycle combinational response) that this testbench was written
  // against, and the assignment gives no spec for reset value or pipe
  // latency. It is flagged here, and in the report, as a design
  // oversight worth raising with the DUT owner: as written, clk/rst_n
  // are dead ports and the router has no defined reset state for
  // data_out0/data_out1/valid_out0/valid_out1 before the first valid
  // input arrives.
  //
  // Functional routing logic verified against the testbench's reference
  // model (see router_scoreboard.sv) and found correct for the spec as
  // documented in this comment: in0 has priority over in2 on out0,
  // in1 has priority over in3 on out1, valid_out asserts on either
  // contributing valid_in.
  assign data_out0  = valid_in0 ? data_in0 : data_in2;
  assign valid_out0 = valid_in0 | valid_in2;

  assign data_out1  = valid_in1 ? data_in1 : data_in3;
  assign valid_out1 = valid_in1 | valid_in3;

endmodule
