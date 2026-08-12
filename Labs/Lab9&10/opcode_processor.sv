module opcode_processor (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [3:0]  opcode,   // 4-bit opcode input
    input  logic [7:0]  data,     // 8-bit data input
    output logic [7:0]  result    // 8-bit output
);

    // Internal register
    logic [7:0] regfile;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            regfile <= 8'b0;
            result  <= 8'b0;
        end else begin
            case (opcode)
                4'b0000: result <= data;                  // Pass-through
                4'b0001: regfile <= data;                 // Load
                4'b0010: result  <= regfile;              // Store
                4'b0011: result  <= ~data;                // Bitwise NOT
                4'b0100: result  <= data + regfile;       // ADD
                4'b0101: result  <= data - regfile;       // SUB
                4'b0110: result  <= data & regfile;       // AND
                4'b0111: result  <= data | regfile;       // OR
                4'b1000: result  <= data ^ regfile;       // XOR
                4'b1111: result  <= 8'hFF;                // Error (for illegal bin coverage)
                default: result <= 8'h00;                 // Default fallback
            endcase
        end
    end

endmodule
