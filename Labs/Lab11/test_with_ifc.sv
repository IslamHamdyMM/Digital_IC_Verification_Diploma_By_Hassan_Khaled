module test_with_ifc(arb_if.DUT arbif);
    initial begin
        @(posedge arbif.clk);
        arbif.req <= 2'b01;
        $display("@%0t: Drove req = 01",$time);
        repeat(2) @(posedge arbif.clk);
        if (arbif.gnt != 2'b01)
        $display("@%0t: Error: grant != 2'b01",$time);
        $finish();
    end
endmodule