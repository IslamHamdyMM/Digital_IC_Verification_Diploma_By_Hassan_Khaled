//------------------------------------------------------------------------
// router_if.sv
// Interface wrapping the router.v DUT ports.
//------------------------------------------------------------------------
interface router_if (input logic clk, input logic rst_n);

  logic [7:0] data_in0, data_in1, data_in2, data_in3;
  logic       valid_in0, valid_in1, valid_in2, valid_in3;
  logic [7:0] data_out0, data_out1;
  logic       valid_out0, valid_out1;

  // Modport used by the DUT instantiation in tb_top
  modport DUT (
    input  clk, rst_n,
    input  data_in0, data_in1, data_in2, data_in3,
    input  valid_in0, valid_in1, valid_in2, valid_in3,
    output data_out0, data_out1, valid_out0, valid_out1
  );

endinterface : router_if
