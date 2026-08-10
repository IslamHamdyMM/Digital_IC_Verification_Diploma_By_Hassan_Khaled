// Using 'logic' instead of 'reg' or 'wire' because it is a 4-valued logic data type 
// (0, 1, X, Z) that permits both procedural assignments and continuous assignments, 
// preventing any net vs. variable type conflicts in SystemVerilog.
typedef struct packed {
    logic [7:0] data_in;
    bit   [1:0] op_sel;
} stim_t;

module multi_op_processor_tb;

    logic [7:0] data_in;
    bit   [1:0] op_sel;
    logic [7:0] data_out_dut;

    stim_t      stimulus_array[];
    logic [7:0] Queue_Output[$];
    logic [7:0] Expected_Values[int];

    // Reads binary tokens from a file, checks bit width, and pushes them into a queue
    task automatic read_bin_file (
        input string file_name,
        input int width,
        ref logic [31:0] q[$]
    );
        int file_desc;
        logic [31:0] temp_val;

        q.delete(); // Clear queue before reading

        file_desc = $fopen(file_name, "r");
        if (file_desc == 0) begin
            $fatal(1, "[FATAL] Failed to open file: %s", file_name);
        end

        // Read binary values until end-of-file
        while (!$feof(file_desc)) begin
            if ($fscanf(file_desc, "%b\n", temp_val) == 1) begin
                // Terminate if any value exceeds the expected bit width
                if (temp_val >= (1 << width)) begin
                    $fatal(1, "[FATAL] Width mismatch in file %s. Value %b exceeds %0d bits.", 
                           file_name, temp_val, width);
                end
                q.push_back(temp_val);
            end
        end

        $fclose(file_desc);
    endtask

    // Loads stimulus and golden files, unpacks input tokens, and fills arrays
    task automatic load_file_stimulus();
        logic [31:0] temp_stim_q[$];
        logic [31:0] temp_gold_q[$];

        // Read files into temporary queues
        read_bin_file("inputs.txt", 10, temp_stim_q);
        read_bin_file("expected_Out.txt", 8, temp_gold_q);

        stimulus_array = new[temp_stim_q.size()];

        // Unpack 10-bit token: upper 8 bits to data_in, lower 2 bits to op_sel
        foreach (temp_stim_q[i]) begin
            stimulus_array[i].data_in = temp_stim_q[i][9:2];
            stimulus_array[i].op_sel  = temp_stim_q[i][1:0];
        end

        // Store golden results in the associative array
        foreach (temp_gold_q[i]) begin
            Expected_Values[i] = temp_gold_q[i][7:0];
        end

        $display("[INFO] Successfully loaded %0d stimulus vectors and %0d expected golden values.", 
                 stimulus_array.size(), Expected_Values.num());
    endtask

    task drive_stim_and_collect ();
        foreach(stimulus_array[i]) begin
            data_in = stimulus_array[i].data_in;
            op_sel  = stimulus_array[i].op_sel;
            #1ns;
            collect_output_data();
        end
    endtask

    function void collect_output_data ();
            Queue_Output.push_back(data_out_dut);
    endfunction

    task check_results (logic [7:0] Expected_Values[int], logic [7:0] Queue_Output[$]);
        foreach(Expected_Values[i]) begin
            if (Expected_Values[i] !== Queue_Output[i]) begin
                $display("Mismatch at index %0d: Expected %0d, Got %0d", i, Expected_Values[i], Queue_Output[i]);
            end else begin
                $display("Match at index %0d: Value %0d", i, Expected_Values[i]);
            end
        end
    endtask

    multi_op_processor DUT(
        .data_in(data_in),
        .op_sel(op_sel),
        .data_out(data_out_dut)
    );

    // Main simulation flow control
    initial begin
        // 1. Read input files and prepare stimulus
        load_file_stimulus();

        // 2. Drive stimulus patterns to the DUT and collect outputs
        drive_stim_and_collect();

        // 3. Compare collected design outputs against expected results
        check_results(Expected_Values, Queue_Output);

        // 4. End the simulation
        $finish;
    end

endmodule