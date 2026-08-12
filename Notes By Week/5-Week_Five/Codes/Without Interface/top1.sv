module top1;
    logic [1:0] grant, request;
    bit   clk, rst;

    always #50 clk = ~clk;

    arb_with_port  a1 (.grant(grant), .request(request), .rst(rst), .clk(clk));
    test_with_port t1 (.grant(grant), .request(request), .rst(rst), .clk(clk));
endmodule