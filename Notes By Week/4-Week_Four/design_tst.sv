module design_tst (
    input  logic [2:0] x,
    input  logic [2:0] y,
    output logic [2:0] z
);
    // 3-bit addition (overflow wraps around)
    assign z = x + y;

endmodule