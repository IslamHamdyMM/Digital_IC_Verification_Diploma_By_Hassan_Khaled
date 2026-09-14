//------------------------------------------------------------------------
// router_config.sv
// Environment-wide configuration object, set from the test via
// uvm_config_db and retrieved by each component in its build_phase.
//------------------------------------------------------------------------
class router_config extends uvm_object;
  `uvm_object_utils(router_config)

  // Agent behaviour
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // DUT topology (fixed by router.v: 4 input ports, 2 output ports).
  // Kept in the config object so the environment / coverage never
  // hardcode the numbers and so the topology is documented in one place.
  int unsigned num_in_ports  = 4;
  int unsigned num_out_ports = 2;

  // Feature enables
  bit coverage_enable = 1;
  bit scoreboard_enable = 1;

  // Virtual interface handle - set once at the top level (tb_top) and
  // fetched by driver / monitor / coverage / scoreboard.
  virtual router_if vif;

  function new(string name = "router_config");
    super.new(name);
  endfunction

endclass : router_config
