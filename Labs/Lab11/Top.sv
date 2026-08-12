module Top#(
    parameter N = 4
);

    logic [N-1:0] req;
    logic [N-1:0] gnt;
    bit clk,rst;

    always #50 clk = ~clk;

    arb_if        #(N) arbif(clk);
    arbiter       #(N) a1(arbif.DUT);
    test_with_ifc #(N) t1(arbif.TB);
    monitor       #(N) m1(arbif.MONITOR);

endmodule 