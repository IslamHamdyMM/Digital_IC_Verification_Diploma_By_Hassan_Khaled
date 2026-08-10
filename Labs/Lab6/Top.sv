`include "Stim_Class.sv"
import Pkg::*

module top;
    bit		          CLK;
    logic             RST;
	logic   [7:0]    A, B;
	logic   [3:0] ALU_FUN;
	logic		   enable; 
	logic   ALU_OUT_VALID;
	logic  [15:0] ALU_OUT;

    ALU DUT(.CLK(CLK),.RST(RST),.A(A),.B(B),.ALU_FUN(ALU_FUN),
            .enable(enable),.ALU_OUT_VALID(ALU_OUT_VALID),.ALU_OUT(ALU_OUT));

    
    stimulus stim;

    initial begin
        CLK = 0;
        forever begin
            #5ns CLK = ~CLK;
            stim.clk = CLK;
        end
    end

    function automatic logic [15:0] golden_model(
        input logic en,
        input logic [3:0] FUN,
        input logic [7:0] a,
        input logic [7:0] b);

        if(!en) begin
            return 16'h0000;
        end
        else begin
            case(FUN)
                4'h0 : return a + b;
                4'h1 : return a - b;
                4'h2 : return a * b;
                4'h3 : 
                if (b == 'b0) begin
					return {16{1'b1}};
					// Indication to infinity, A/0 -> INFINITY 
				end
				else begin
					return a / b;
                end
                4'h4 : return a & b;
                4'h5 : return a | b;
                4'h6 : return ~(a & b);
                4'h7 : return ~(a | b);
                4'h8 : return a ^ b;
                4'h9 : return ~(a ^ b);
                4'hA : begin
                if ( a == b) begin
					return 'hA;  
				end else begin
					return 'h0;
				end
                end
                4'hB :begin
				if ( a > b) begin
					return 'hB;
				end else begin
					return 'h0;
				end		
			    end
                4'hC : begin
				if ( a < b) begin
					return 'hC;
				end else begin
					return 'h0;
				end
			    end
                4'hD : begin
				return a >> 1;
			    end
                4'hE : begin
				return a << 1;
			    end
                default : return 16'h0000;
            endcase
        end
    endfunction

    task automatic check(
        input logic en,
        input logic rst,
        input logic [3:0] FUN,
        input logic [7:0] a,
        input logic [7:0] b);

        logic [15:0] exp;

        if(!en || !rst) return;

        exp = golden_model(en,FUN,a,b);
        if(ALU_OUT === exp) begin
            $display("========== DUT Output = 0x%04h , Expected Output = 0x%04h ==========",ALU_OUT,exp);
            $display("========== PASSED ==========");
        end
        else begin
            $display("========== DUT Output = 0x%04h , Expected Output = 0x%04h ==========",ALU_OUT,exp);
            $display("========== FAILED ==========");
        end
    
    endtask

    initial begin

        stim = new();

        // APPLY RESET ==> 0
        RST     = 0;
        A       = 0;
        B       = 0;
        ALU_FUN = 0;
        enable  = 0;

        $display("--------- RST = 0 ----------");

        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);

        RST = 1;
        @(posedge CLK);

        $display("--------- RST = 1 ----------");
    
        // RELEASE RESET ==> 1
        repeat(50) begin
            assert(stim.randomize()) else $display("Randomization Failed");
            stim.drive(A,B,ALU_FUN,enable,RST);
            @(posedge CLK);
            check(enable,RST,ALU_FUN,A,B);
        end

        $display("---------- TB Done ----------");
        $stop;
    end
endmodule
