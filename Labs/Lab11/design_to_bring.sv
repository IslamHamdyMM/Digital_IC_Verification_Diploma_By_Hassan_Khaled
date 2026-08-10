module arbiter #(
    parameter N = 4
)(
    input  logic                  clk,
    input  logic                  rst,
    input  logic [N-1:0]          req,
    output logic [N-1:0]          gnt
);

    logic [$clog2(N)-1:0] ptr;
    int index;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            ptr <= 0;
            gnt <= 0;
        end else begin
            gnt <= 0;
            for (int i = 0; i < N; i++) begin
                index = (ptr + i) % N;
                if (req[index]) begin
                    gnt[index] <= 1;
                    ptr <= index + 1;
                    break;
                end
            end
        end
    end

endmodule

