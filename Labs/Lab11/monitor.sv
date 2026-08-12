module monitor #(parameter N = 4)(arb_if.MONITOR arbif);

    for (genvar i = 0; i < N; i++) begin : g_mon
        always @(posedge arbif.req[i]) begin
            $display("@%0t: request[%0d] asserted", $time, i);
            @(posedge arbif.gnt[i]);
            $display("@%0t: grant[%0d] asserted", $time, i);
        end
    end

endmodule