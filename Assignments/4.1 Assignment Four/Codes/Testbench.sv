module Testbench;

    import Uart_packet::*;
    bit clk, rst_n, tx_start;
    logic [7:0] data_in;
    bit parity_en;     // 1 = enable parity
    bit even_parity;   // 1 = even, 0 = odd
    bit tx, tx_busy;
    logic actual_queue[$], expected_queue[$];

    // Clk generation
    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    // DUT connections
    uart_tx DUT (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_start(tx_start),
        .parity_en(parity_en),
        .even_parity(even_parity)
    );   

    Uart_class pkt;

initial begin

        // Reset all
        rst_n = 0;
        tx_start = 0;

        // Check reset
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        if (tx == 1'b1 && tx_busy == 1'b0) begin
            $display("=====> Reset button work correctly <=====");
        end else begin
            $display("=====> Reset button does not work correctly <=====");
        end

        // Check transition from IDLE to Start
        rst_n = 1'b1;
        tx_start = 1'b1;
        @(negedge clk);
        tx_start = 1'b0; // Clear tx_start so DUT can complete and clear tx_busy!

        if (tx == 1'b1 || tx_busy == 1'b1) begin
            $display("Transition from IDLE to START state DONE");
        end else begin
            $display("Transition from IDLE to START state FAILED");
        end

        // Wait for DUT to return to IDLE before starting the stimulus loop
        wait (tx_busy == 1'b0);

        // Sending Data
        repeat(100) begin
            pkt = new();
            pkt = pkt.generate_stimulus();
            
            pkt.golden_model(expected_queue);
            pkt.drive_stim(clk, tx_busy, tx_start, data_in, parity_en, even_parity);
            pkt.collect_output(clk, tx_busy, tx, actual_queue);
            pkt.check_result(actual_queue, expected_queue);
        end

        $display("=====> All Tests Completed <=====");
        $stop();

    end

endmodule