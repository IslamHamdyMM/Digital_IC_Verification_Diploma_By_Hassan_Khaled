module test_with_ifc (arb_if.TEST arbif);

    initial begin
        arbif.rst = 1'b1;
        arbif.request = 2'b00;

        @(posedge arbif.clk);
        #1 arbif.rst = 1'b0;

        @(posedge arbif.clk);
        arbif.request <= 2'b01;
        $display("@%0t: Drove req = 01", $time);

        repeat(2) @(posedge arbif.clk);
        #1;

        if (arbif.grant == 2'b01)
            $display("@%0t: Success: grant == 2'b01", $time);
        else
            $display("@%0t: Error: grant != 2'b01 (grant = %b)", $time, arbif.grant);

        $finish(); 
    end

endmodule