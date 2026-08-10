package Uart_packet;

import enum_pkg::*;

class Uart_class;
    rand logic [7:0] data_in;
    rand enum_pkg::Parity_t parity_in;

    constraint Data_C {
        data_in dist { 8'h00 :/ 30, 8'hFF :/ 30, [8'h01:8'hFE] :/ 40};
        parity_in dist {No_Parity :/ 20, ODD_Parity :/ 40, EVEN_Parity :/ 40};
    }

    // --- FUNCTIONAL COVERAGE DEFINITION ---
    covergroup uart_cg;
        // Cover point for data input values (0x00, 0xFF, and middle values)
        cp_data_in: coverpoint data_in {
            bins zero = {8'h00};
            bins max  = {8'hFF};
            bins mid  = {[8'h01:8'hFE]};
        }

        // Cover point for parity modes
        cp_parity_in: coverpoint parity_in {
            bins no_p   = {No_Parity};
            bins odd_p  = {ODD_Parity};
            bins even_p = {EVEN_Parity};
        }

        // Cross coverage between Data and Parity modes
        cross_data_parity: cross cp_data_in, cp_parity_in;
    endgroup

    function new();
        uart_cg = new(); // Instantiate covergroup
    endfunction

    function void Print();
        $display("displaying the stimulus values : data_in = %0h, parity_in = %0s",
                  data_in, parity_in.name());
    endfunction

    function Uart_class generate_stimulus();
        Uart_class pkt = new();
        if (pkt.randomize()) begin
            pkt.uart_cg.sample(); // Sample coverage on successful randomization
            pkt.Print();
            return pkt;
        end else begin
            $display("Randomization failed");
            return null;
        end
    endfunction

    task golden_model(ref logic expected_queue[$]);
        expected_queue.delete();

        expected_queue.push_back(1'b0);

        for (int i = 0; i < 8; i++) begin
            expected_queue.push_back(this.data_in[i]);
        end

        if (this.parity_in == enum_pkg::EVEN_Parity) begin
            expected_queue.push_back(~(^this.data_in));
        end else if (this.parity_in == enum_pkg::ODD_Parity) begin
            expected_queue.push_back(^this.data_in);
        end

        expected_queue.push_back(1'b1);
    endtask
    
    task drive_stim(
        ref bit clk,
        ref bit tx_busy,
        ref bit tx_start,
        ref logic [7:0] tb_data_in,
        ref bit parity_en,
        ref bit even_parity
    );
        if (tx_busy) begin
            $display("Notice: Transmitter is busy, waiting for it to finish...");
            wait (tx_busy == 1'b0);            
        end

        @(posedge clk);
        tx_start    = 1'b1;
        tb_data_in  = this.data_in;
        parity_en   = (this.parity_in != enum_pkg::No_Parity);
        even_parity = (this.parity_in == enum_pkg::EVEN_Parity);
        
        @(posedge clk);
        tx_start    = 1'b0;
    endtask

    task collect_output(
        ref bit clk,
        ref bit tx_busy,
        ref bit tx,
        ref logic actual_queue[$]
    );
        int total_bits;
        total_bits = (this.parity_in == enum_pkg::No_Parity) ? 10 : 11;

        wait (tx_busy == 1'b1);
        wait (tx == 1'b0);
        repeat (total_bits) begin
            @(negedge clk);
            actual_queue.push_back(tx);
        end
        wait (tx_busy == 1'b0);
    endtask

    task check_result(ref logic actual_queue[$], ref logic expected_queue[$]);
        bit match = 1;

        if (actual_queue.size() != expected_queue.size()) begin
            $display("[ERROR] Size mismatch! expected_size = %0d, actual_size = %0d", 
                      expected_queue.size(), actual_queue.size());
            match = 0;
        end else begin
            foreach (expected_queue[i]) begin
                if (expected_queue[i] != actual_queue[i]) begin
                    $display("[MISMATCH] Bit [%0d]: Expected = %0b, Actual = %0b", 
                             i, expected_queue[i], actual_queue[i]);
                    match = 0;
                end else begin
                    $display("[MATCH] Bit [%0d]: Expected = %0b, Actual = %0b", 
                             i, expected_queue[i], actual_queue[i]);
                end
            end
        end

        if (match) begin
            $display("[TEST PASSED] Frame transmitted correctly!\n");
        end else begin
            $display("[TEST FAILED] Mismatch detected in transmission!\n");
        end

        expected_queue.delete();
        actual_queue.delete();
    endtask

endclass
endpackage