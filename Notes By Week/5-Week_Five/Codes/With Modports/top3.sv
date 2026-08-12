module top3;
    bit   clk;
    always #50 clk = ~clk;

    arb_if arbif(clk);
    arb_with_ifc  a1 (arbif.DUT);
    test_with_ifc t1 (arbif.TEST);
endmodule