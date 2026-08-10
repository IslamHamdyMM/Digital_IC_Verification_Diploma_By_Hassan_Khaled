module ALU #(
	parameter N   = 8, 
	OPERAND_WIDTH = N, 
    FUN_WIDTH     = 4,
    OUTPUT_WIDTH  = 2*N)
( 
	// Input Ports
	input  wire 		              CLK, RST,
	input  wire [OPERAND_WIDTH-1:0]   A, B, 
	input  wire [FUN_WIDTH-1:0]       ALU_FUN,
	input  wire 					  enable, 
	
	// Output Ports
	output reg   				   ALU_OUT_VALID,
	output reg  [OUTPUT_WIDTH-1:0] ALU_OUT
);
	
	/* ======== Functionality ======== */
	always @(posedge CLK or negedge RST) begin 
		if(!RST) begin
			ALU_OUT          = 0;
			ALU_OUT_VALID    = 0;
		end
		else begin
		if (enable) begin
			ALU_OUT_VALID    = 1;

			case(ALU_FUN) 
			4'b0000: begin
				ALU_OUT = A + B;
			end
			4'b0001: begin
				ALU_OUT = A - B;
			end
			4'b0010: begin
				ALU_OUT = A * B;
			end
			4'b0011: begin
				if (B == 'b0) begin
					ALU_OUT  = {OUTPUT_WIDTH{1'b1}};
					// Indication to infinity, A/0 -> INFINITY 
				end
				else begin
					ALU_OUT = A / B;
				end
			end
			4'b0100: begin
				ALU_OUT = A & B;
			end
			4'b0101: begin
				ALU_OUT = A | B;
			end
			4'b0110: begin
				ALU_OUT = ~(A & B);
			end
			4'b0111: begin
				ALU_OUT = ~(A | B);			
			end
			4'b1000: begin
				ALU_OUT = A ^ B;			
			end
			4'b1001: begin
				ALU_OUT = ~(A ^ B);
			end
			4'b1010: begin
				if ( A == B) begin
					ALU_OUT = 'hA;  
				end else begin
					ALU_OUT = 'h0;
				end
			end
			4'b1011: begin
				if ( A > B) begin
					ALU_OUT = 'hB;
				end else begin
					ALU_OUT = 'h0;
				end		
			end
			4'b1100: begin
				if ( A < B) begin
					ALU_OUT = 'hC;
				end else begin
					ALU_OUT = 'h0;
				end
			end
			4'b1101: begin
				ALU_OUT = A >> 1;
			end
			4'b1110: begin
				ALU_OUT = A << 1;
			end
			default: begin
				ALU_OUT      = 'b0;
			end 
		endcase
		end else begin
			ALU_OUT_VALID    = 0;
		end
	end
	end

endmodule