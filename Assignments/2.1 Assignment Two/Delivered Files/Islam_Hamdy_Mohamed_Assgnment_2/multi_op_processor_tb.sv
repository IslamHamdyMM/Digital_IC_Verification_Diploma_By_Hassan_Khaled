// Using 'logic' instead of 'reg' or 'wire' because it is a 4-valued logic data type 
// (0, 1, X, Z) that permits both procedural assignments and continuous assignments, 
// preventing any net vs. variable type conflicts in SystemVerilog.
typedef struct{
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

    function void configure_stim_storage (int size);
        stimulus_array = new[size];
        Queue_Output.delete();
        Expected_Values.delete();
    endfunction

    function automatic void generate_stimulus (ref stim_t stimulus_array[]);
            foreach(stimulus_array[i]) begin
                stimulus_array[i].data_in = $urandom();
                stimulus_array[i].op_sel  = $urandom_range(0,3);
            end
    endfunction

    task drive_stim_and_collect ();
        foreach(stimulus_array[i]) begin
            data_in = stimulus_array[i].data_in;
            op_sel  = stimulus_array[i].op_sel;
            #1ns;
            collect_output_data();
        end
    endtask

    task automatic golden_model();
        foreach(stimulus_array[i]) begin
            case (stimulus_array[i].op_sel)
                2'b00: Expected_Values[i] = stimulus_array[i].data_in + 1;       
                2'b01: Expected_Values[i] = stimulus_array[i].data_in - 1;       
                2'b10: Expected_Values[i] = ~stimulus_array[i].data_in;          
                2'b11: Expected_Values[i] = stimulus_array[i].data_in << 1;      
                default: Expected_Values[i] = stimulus_array[i].data_in;
            endcase
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

    function automatic void reconfigure_stim (ref stim_t stimulus_array[]);
        stimulus_array.shuffle();
    endfunction

    multi_op_processor DUT(
        .data_in(data_in),
        .op_sel(op_sel),
        .data_out(data_out_dut)
    );

    initial begin

        // Requirement: Configure size with 100 locations, generate, drive, and check results
        $display("Executing Requirement: 100 locations test");
        configure_stim_storage(100);
        generate_stimulus(stimulus_array);
        golden_model();
        drive_stim_and_collect();
        check_results(Expected_Values,Queue_Output);

        #10ns;

        // Requirement: Repeat the process with 200 locations
        $display("Executing Requirement: 200 locations test");
        configure_stim_storage(200);
        generate_stimulus(stimulus_array);
        golden_model();
        drive_stim_and_collect();
        check_results(Expected_Values,Queue_Output);

        #10ns;

        // Requirement: Shuffle stimulus array, clean arrays, recalculate, drive, and check results
        $display("Executing Requirement: Shuffle and re-test");
        reconfigure_stim(stimulus_array);
        Queue_Output.delete();
        Expected_Values.delete();
        golden_model();
        drive_stim_and_collect();
        check_results(Expected_Values,Queue_Output);

        #10ns;
        $finish;
    end

endmodule