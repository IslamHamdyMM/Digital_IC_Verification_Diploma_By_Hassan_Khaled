//------------------------------------------------------------------------
// router_test.sv
// Base test: builds the router_config (is_active = UVM_ACTIVE by
// default), publishes it through uvm_config_db, instantiates the env,
// and runs router_base_sequence on the agent's sequencer.
//------------------------------------------------------------------------
class router_base_test extends uvm_test;
  `uvm_component_utils(router_base_test)

  router_env    env;
  router_config cfg;

  function new(string name = "router_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "[router_base_test] build_phase @ UVM_LOW",    UVM_LOW)
    `uvm_info(get_type_name(), "[router_base_test] build_phase @ UVM_MEDIUM", UVM_MEDIUM)
    `uvm_info(get_type_name(), "[router_base_test] build_phase @ UVM_HIGH",   UVM_HIGH)
    `uvm_info(get_type_name(), "[router_base_test] build_phase @ UVM_FULL",   UVM_FULL)

    cfg = router_config::type_id::create("cfg");
    cfg.is_active         = UVM_ACTIVE;   // switch to UVM_PASSIVE to demo passive mode
    cfg.num_in_ports      = 4;
    cfg.num_out_ports     = 2;
    cfg.coverage_enable   = 1;
    cfg.scoreboard_enable = 1;

    if (!uvm_config_db#(virtual router_if)::get(this, "", "vif", cfg.vif)) begin
      `uvm_fatal(get_type_name(), "virtual interface not found in config_db (set by tb_top)")
    end

    uvm_config_db#(router_config)::set(this, "*", "cfg", cfg);

    env = router_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    router_base_sequence seq;
    phase.raise_objection(this, "Starting router_base_sequence");

    seq = router_base_sequence::type_id::create("seq");
    if (!seq.randomize() with { num_txns == 30; })
      `uvm_warning(get_type_name(), "Sequence randomize failed, using default num_txns")

    seq.start(env.agent.sequencer);

    // Let the last transaction propagate through the DUT and be sampled
    // by the monitor/coverage/scoreboard before dropping the objection.
    #20;

    phase.drop_objection(this, "router_base_sequence complete");
  endtask

endclass : router_base_test

//------------------------------------------------------------------------
// router_passive_test.sv
// Demonstrates UVM_PASSIVE mode: the agent is config'd passive so only
// the monitor is built (no driver/sequencer). Useful to show that
// is_active truly comes from the config object rather than being
// hardcoded in the agent.
//------------------------------------------------------------------------
class router_passive_test extends router_base_test;
  `uvm_component_utils(router_passive_test)

  function new(string name = "router_passive_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg.is_active = UVM_PASSIVE;
  endfunction

  // Passive mode has no driver/sequencer to drive stimulus, so this test
  // simply lets the DUT idle and observes; it's meant to be exercised
  // together with an external stimulus source or a waveform replay, and
  // exists here to demonstrate the config-driven active/passive switch.
  task run_phase(uvm_phase phase);
    phase.raise_objection(this, "router_passive_test observing");
    #200;
    phase.drop_objection(this, "router_passive_test done");
  endtask

endclass : router_passive_test
