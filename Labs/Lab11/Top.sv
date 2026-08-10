module Top#(
    parameter N = 4
);

    logic [N-1:0] req;
    logic [N-1:0] gnt;
    bit clk,rst;

    always #50 clk = ~clk;

    


endmodule 