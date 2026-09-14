//------------------------------------------------------------------------
// router_env.sv
// Top-level environment instantiating the agent, coverage collector and
// scoreboard. Passes the router_config down to the agent via config_db
// (the agent then derives its own is_active from that object).
//------------------------------------------------------------------------
class router_env extends uvm_env;
  `uvm_component_utils(router_env)

  router_agent      agent;
  router_coverage    coverage;
  router_scoreboard scoreboard;
  router_config     cfg;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "[router_env] build_phase @ UVM_LOW",    UVM_LOW)
    `uvm_info(get_type_name(), "[router_env] build_phase @ UVM_MEDIUM", UVM_MEDIUM)
    `uvm_info(get_type_name(), "[router_env] build_phase @ UVM_HIGH",   UVM_HIGH)
    `uvm_info(get_type_name(), "[router_env] build_phase @ UVM_FULL",   UVM_FULL)

    if (!uvm_config_db#(router_config)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal(get_type_name(), "router_config not found in config_db")
    end

    agent      = router_agent::type_id::create("agent", this);
    coverage   = router_coverage::type_id::create("coverage", this);
    scoreboard = router_scoreboard::type_id::create("scoreboard", this);
  endfunction

  // No connect_phase needed: coverage and scoreboard sample the
  // interface independently (see their own build_phase), satisfying the
  // assignment's "No connections needed" requirement. No manual re-publish
  // of cfg into child contexts is needed either: it was set with a "*"
  // wildcard scope from the test, so every component in the hierarchy
  // (agent, driver, monitor, sequencer, coverage, scoreboard) can fetch
  // it directly via uvm_config_db#(router_config)::get(this, "", "cfg", cfg).

endclass : router_env
