`include "Coverage_Class.sv"
module top;

    bit        clk;
    logic      rst_n;
    logic [3:0] opcode;
    logic [7:0] data;
    logic [7:0] result;

    coverage_class Cov_Obj;

    opcode_processor dut(.*);

    initial begin
        clk = 0;
        forever #2ns clk = ~clk;
    end

    initial begin
        Cov_Obj = new();

        rst_n = 0;
        @(negedge clk);
        @(negedge clk);
        rst_n = 1;

        for(int i = 0; i < 100; i++) begin
            @(negedge clk);
            assert(Cov_Obj.randomize()) else $finish();

            opcode = Cov_Obj.opcode;
            data   = Cov_Obj.data;

            Cov_Obj.cg.sample();

            $display("opcode = 4'b%0b, data = 8'h%0h", opcode, data);
        end
        $stop;
    end

endmodule