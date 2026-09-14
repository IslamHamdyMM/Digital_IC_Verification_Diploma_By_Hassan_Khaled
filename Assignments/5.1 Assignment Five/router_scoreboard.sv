//------------------------------------------------------------------------
// router_scoreboard.sv
// Self-checking scoreboard. Per the assignment it needs no TLM
// connections: it independently samples the same virtual interface,
// computes the expected routing result from the reference model
// (mirroring router.v's documented behaviour: even inputs -> out0 with
// in0 priority over in2, odd inputs -> out1 with in1 priority over in3)
// and compares it against what the DUT actually produced that cycle.
//------------------------------------------------------------------------
class router_scoreboard extends uvm_component;
  `uvm_component_utils(router_scoreboard)

  virtual router_if vif;
  router_config     cfg;

  int unsigned num_checked = 0;
  int unsigned num_errors  = 0;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "[router_scoreboard] build_phase @ UVM_LOW",    UVM_LOW)
    `uvm_info(get_type_name(), "[router_scoreboard] build_phase @ UVM_MEDIUM", UVM_MEDIUM)
    `uvm_info(get_type_name(), "[router_scoreboard] build_phase @ UVM_HIGH",   UVM_HIGH)
    `uvm_info(get_type_name(), "[router_scoreboard] build_phase @ UVM_FULL",   UVM_FULL)

    if (!uvm_config_db#(router_config)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal(get_type_name(), "router_config not found in config_db")
    end
    vif = cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    bit [7:0] exp_data_out0, exp_data_out1;
    bit       exp_valid_out0, exp_valid_out1;

    if (!cfg.scoreboard_enable) return;

    wait (vif.rst_n === 1'b1);
    forever begin
      @(posedge vif.clk);
      #1; // sample after the combinational outputs have settled

      // Reference model
      exp_data_out0  = vif.valid_in0 ? vif.data_in0 : vif.data_in2;
      exp_valid_out0 = vif.valid_in0 | vif.valid_in2;
      exp_data_out1  = vif.valid_in1 ? vif.data_in1 : vif.data_in3;
      exp_valid_out1 = vif.valid_in1 | vif.valid_in3;

      num_checked++;

      if (exp_valid_out0 !== vif.valid_out0 ||
          (exp_valid_out0 && exp_data_out0 !== vif.data_out0)) begin
        num_errors++;
        `uvm_error(get_type_name(),
          $sformatf("OUT0 MISMATCH: exp data=%0d valid=%0b, got data=%0d valid=%0b",
                     exp_data_out0, exp_valid_out0, vif.data_out0, vif.valid_out0))
      end

      if (exp_valid_out1 !== vif.valid_out1 ||
          (exp_valid_out1 && exp_data_out1 !== vif.data_out1)) begin
        num_errors++;
        `uvm_error(get_type_name(),
          $sformatf("OUT1 MISMATCH: exp data=%0d valid=%0b, got data=%0d valid=%0b",
                     exp_data_out1, exp_valid_out1, vif.data_out1, vif.valid_out1))
      end
    end
  endtask

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(),
      $sformatf("Scoreboard summary: %0d cycles checked, %0d errors", num_checked, num_errors),
      UVM_LOW)
  endfunction

endclass : router_scoreboard
