//------------------------------------------------------------------------
// router_coverage.sv
// Standalone coverage collector. Per the assignment it needs no TLM
// connections: it grabs the same virtual interface handle from the
// config object and samples its own covergroups directly off the bus
// every clock cycle.
//------------------------------------------------------------------------
class router_coverage extends uvm_component;
  `uvm_component_utils(router_coverage)

  virtual router_if vif;
  router_config     cfg;

  bit [7:0] data_in0_s, data_in1_s, data_in2_s, data_in3_s;
  bit       valid_in0_s, valid_in1_s, valid_in2_s, valid_in3_s;
  bit       valid_out0_s, valid_out1_s;

  // Covers whether each input channel was seen valid/invalid, and
  // whether each output channel fired, plus the arbitration cases
  // (both contending inputs valid at once) on each output.
  covergroup cg_router;
    option.per_instance = 1;

    cp_valid_in0 : coverpoint valid_in0_s;
    cp_valid_in1 : coverpoint valid_in1_s;
    cp_valid_in2 : coverpoint valid_in2_s;
    cp_valid_in3 : coverpoint valid_in3_s;

    cp_valid_out0 : coverpoint valid_out0_s;
    cp_valid_out1 : coverpoint valid_out1_s;

    // Arbitration: out0 is fed by in0 (priority) and in2; out1 by in1
    // (priority) and in3. Cross to make sure both contention cases and
    // both idle cases have been exercised on each output.
    cx_out0_arb : cross cp_valid_in0, cp_valid_in2;
    cx_out1_arb : cross cp_valid_in1, cp_valid_in3;
  endgroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    cg_router = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "[router_coverage] build_phase @ UVM_LOW",    UVM_LOW)
    `uvm_info(get_type_name(), "[router_coverage] build_phase @ UVM_MEDIUM", UVM_MEDIUM)
    `uvm_info(get_type_name(), "[router_coverage] build_phase @ UVM_HIGH",   UVM_HIGH)
    `uvm_info(get_type_name(), "[router_coverage] build_phase @ UVM_FULL",   UVM_FULL)

    if (!uvm_config_db#(router_config)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal(get_type_name(), "router_config not found in config_db")
    end
    vif = cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    if (!cfg.coverage_enable) return;

    wait (vif.rst_n === 1'b1);
    forever begin
      @(posedge vif.clk);
      #1;
      valid_in0_s  = vif.valid_in0;  valid_in1_s  = vif.valid_in1;
      valid_in2_s  = vif.valid_in2;  valid_in3_s  = vif.valid_in3;
      valid_out0_s = vif.valid_out0; valid_out1_s = vif.valid_out1;
      cg_router.sample();
      `uvm_info(get_type_name(),
        $sformatf("Sampled coverage, current cg_router=%0.2f%%", cg_router.get_coverage()),
        UVM_FULL)
    end
  endtask

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(),
      $sformatf("Final functional coverage = %0.2f%%", cg_router.get_coverage()), UVM_LOW)
  endfunction

endclass : router_coverage
