interface arb_if#(
    parameter N = 4
)(input clk);

    bit         rst;
    logic [N-1:0] req;
    logic [N-1:0] gnt;

    modport TB(output req,rst
               input gnt,clk);

    modport DUT(input req,rst,clk
                output gnt);

endinterface