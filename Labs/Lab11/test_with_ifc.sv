module test_with_ifc #(parameter N = 4) (arb_if.TB arbif);

    initial begin

        arbif.rst = 1'b1;
        arbif.req = 2'b00;
        @(posedge arbif.clk);

        #1 arbif.rst = 1'b0;
        for (int i = 0; i < N; i++) begin
            @(posedge arbif.clk);
            arbif.req[i] <= 1'b1;
            $display("@%0t: Drove req[%0d] = 1'b1", $time, i);

            repeat(2) @(posedge arbif.clk);
            if (arbif.gnt[i] == 1'b1)
                $display("@%0t: Success: grant[%0d] == 1'b1", $time, i);
            else
                $display("@%0t: Error: grant[%0d] != 1'b1 (grant = %b)", $time, i, arbif.gnt[i]);

            arbif.req[i] <= 1'b0;
        end
        $finish();
    end

endmodule