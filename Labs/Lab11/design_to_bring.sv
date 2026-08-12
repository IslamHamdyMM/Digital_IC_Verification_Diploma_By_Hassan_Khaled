module arbiter #(
    parameter N = 4
)(arb_if.DUT arbif);

    logic [$clog2(N)-1:0] ptr;
    int index;

    always_ff @(posedge arbif.clk or posedge arbif.rst) begin
        if (arbif.rst) begin
            ptr <= 0;
            arbif.gnt <= 0;
        end else begin
            arbif.gnt <= 0;
            for (int i = 0; i < N; i++) begin
                index = (ptr + i) % N;
                if (arbif.req[index]) begin
                    arbif.gnt[index] <= 1;
                    ptr <= (index + 1)% N;
                    break;
                end
            end
        end
    end

endmodule

