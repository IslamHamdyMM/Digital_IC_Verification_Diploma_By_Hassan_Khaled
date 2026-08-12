class coverage_class;

    rand logic [3:0]  opcode;   // 4-bit opcode input
    rand logic [7:0]  data;     // 8-bit data input
    bit clk;


    // Holds opcode post-randomize for transition constraint 
    bit [3:0] opcode_post_rand;

    function void post_randomize();
    opcode_post_rand = opcode;
    endfunction 

    // Steers opcode to be STORE whenever previous opcode was LOAD
    constraint load_store_seq_c {
    (opcode_post_rand == 4'd1) -> (opcode == 4'd2);
    }

    covergroup cg;

        option.per_instance = 1;

        cp_opcode: coverpoint opcode {
            option.auto_bin_max = 5;
        }
        cp_opcode_bins: coverpoint opcode {
            bins ALU_operations       = {'d4,'d5,'d6};
            bins Load_Store           = {'d1,'d2};
            bins Miscellaneous        = {'d0,'d3,'d7,'d8};
            ignore_bins reserved_op   = {'d9,'d10,'d11,'d12};
            illegal_bins flage_op_ill = {'d15};
        }
        cp_data_range: coverpoint data {
            bins Low           = {[0:63]};
            bins mid           = {[64:127]};
            bins high          = {[128:255]};
        }
        cp_transitions: coverpoint opcode {
            bins Load_2_Store   = (1 => 2);
            bins Store_thr_ALU  = (2 => 4 => 5);
            option.weight = 0;
        }
        cp_data_when_alu: coverpoint data iff(opcode inside {4,5,6}) {
            bins Low           = {[0:63]};
            bins mid           = {[64:127]};
            bins high          = {[128:255]};
        }
        cp_data_when_load_store: coverpoint data iff(opcode inside {1,2}) {
            bins Low           = {[0:63]};
            bins mid           = {[64:127]};
            bins high          = {[128:255]};
        }
        opcode_data_cross: cross cp_data_range,cp_opcode_bins {
            option.cross_auto_bin_max  = 0;
            bins alu_ops_low_range     = binsof(cp_opcode_bins.ALU_operations) && binsof(cp_data_range.Low);
            bins alu_ops_not_low_range = binsof(cp_opcode_bins.ALU_operations) && !binsof(cp_data_range.Low);
        }
    endgroup : cg

    function new();
        cg = new();
    endfunction

endclass : coverage_class