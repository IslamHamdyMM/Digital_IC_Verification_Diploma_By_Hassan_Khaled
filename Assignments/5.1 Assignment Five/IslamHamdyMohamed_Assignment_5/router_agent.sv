//------------------------------------------------------------------------
// router_agent.sv
// Single agent containing driver + monitor + sequencer. Active/passive
// behaviour is taken from router_config.is_active (never hardcoded).
//------------------------------------------------------------------------
class router_agent extends uvm_agent;
  `uvm_component_utils(router_agent)

  router_driver    driver;
  router_monitor   monitor;
  router_sequencer sequencer;
  router_config    cfg;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "[router_agent] build_phase @ UVM_LOW",    UVM_LOW)
    `uvm_info(get_type_name(), "[router_agent] build_phase @ UVM_MEDIUM", UVM_MEDIUM)
    `uvm_info(get_type_name(), "[router_agent] build_phase @ UVM_HIGH",   UVM_HIGH)
    `uvm_info(get_type_name(), "[router_agent] build_phase @ UVM_FULL",   UVM_FULL)

    if (!uvm_config_db#(router_config)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal(get_type_name(), "router_config not found in config_db")
    end

    // is_active is driven purely from the config object, per assignment
    // requirement - never hardcoded here.
    this.is_active = cfg.is_active;

    monitor = router_monitor::type_id::create("monitor", this);

    if (is_active == UVM_ACTIVE) begin
      driver    = router_driver::type_id::create("driver", this);
      sequencer = router_sequencer::type_id::create("sequencer", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass : router_agent
