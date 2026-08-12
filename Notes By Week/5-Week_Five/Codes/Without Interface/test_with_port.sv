module test_with_port (
    input  logic [1:0] grant,
    output logic [1:0] request,
    output bit         rst,
    input  bit         clk
);

    initial begin
        rst = 1'b1;
        request = 2'b00;

        @(posedge clk);
        #1 rst = 1'b0;

        @(posedge clk);
        request <= 2'b01;
        $display("@%0t: Drove req = 01", $time);

        repeat(2) @(posedge clk);
        #1;

        if (grant == 2'b01)
            $display("@%0t: Success: grant == 2'b01", $time);
        else
            $display("@%0t: Error: grant != 2'b01 (grant = %b)", $time, grant);

        $finish(); 
    end

endmodule