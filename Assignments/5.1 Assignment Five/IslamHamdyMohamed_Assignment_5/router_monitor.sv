//------------------------------------------------------------------------
// router_monitor.sv
// Samples the router interface every clock cycle (once inputs have
// settled and the combinational outputs have propagated) and broadcasts
// the observed transaction on its analysis port. Works whether the
// agent is UVM_ACTIVE or UVM_PASSIVE.
//------------------------------------------------------------------------
class router_monitor extends uvm_monitor;
  `uvm_component_utils(router_monitor)

  virtual router_if vif;
  router_config     cfg;

  uvm_analysis_port #(router_seq_item) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "[router_monitor] build_phase @ UVM_LOW",    UVM_LOW)
    `uvm_info(get_type_name(), "[router_monitor] build_phase @ UVM_MEDIUM", UVM_MEDIUM)
    `uvm_info(get_type_name(), "[router_monitor] build_phase @ UVM_HIGH",   UVM_HIGH)
    `uvm_info(get_type_name(), "[router_monitor] build_phase @ UVM_FULL",   UVM_FULL)

    if (!uvm_config_db#(router_config)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal(get_type_name(), "router_config not found in config_db")
    end
    vif = cfg.vif;
    if (vif == null) begin
      `uvm_fatal(get_type_name(), "Virtual interface handle inside router_config is null")
    end
  endfunction

  task run_phase(uvm_phase phase);
    wait (vif.rst_n === 1'b1);
    forever begin
      router_seq_item txn;
      @(posedge vif.clk);
      #1; // let the combinational outputs settle before sampling

      txn = router_seq_item::type_id::create("txn");
      txn.data_in[0]  = vif.data_in0;  txn.data_in[1]  = vif.data_in1;
      txn.data_in[2]  = vif.data_in2;  txn.data_in[3]  = vif.data_in3;
      txn.valid_in[0] = vif.valid_in0; txn.valid_in[1] = vif.valid_in1;
      txn.valid_in[2] = vif.valid_in2; txn.valid_in[3] = vif.valid_in3;
      txn.data_out[0]  = vif.data_out0;  txn.data_out[1]  = vif.data_out1;
      txn.valid_out[0] = vif.valid_out0; txn.valid_out[1] = vif.valid_out1;

      `uvm_info(get_type_name(),
        $sformatf("Observed transaction: %s", txn.convert2string()), UVM_HIGH)

      ap.write(txn);
    end
  endtask

endclass : router_monitor
