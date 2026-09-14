interface arb_if#(
    parameter N = 4
)(input bit clk);

    bit         rst;
    logic [N-1:0] req;
    logic [N-1:0] gnt;

    clocking cb @(posedge clk);
        default input #2ns output negedge;
        output  req;
        input   gnt;
    endclocking

    `ifdef CLOCKING_BLOCK
       modport TEST (
        clocking cb,
        output rst,
        input clk
       );
    `else
       modport TEST (
        output req,rst,
        input  gnt,clk
       );
    `endif

    modport TB(output req,rst,
               input gnt,clk);

    modport DUT(input req,rst,clk,
                output gnt);

    modport MONITOR(clocking cb);

    

endinterface