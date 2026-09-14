//------------------------------------------------------------------------
// router_sequencer.sv
//------------------------------------------------------------------------
class router_sequencer extends uvm_sequencer #(router_seq_item);
  `uvm_component_utils(router_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "[router_sequencer] build_phase @ UVM_LOW",    UVM_LOW)
    `uvm_info(get_type_name(), "[router_sequencer] build_phase @ UVM_MEDIUM", UVM_MEDIUM)
    `uvm_info(get_type_name(), "[router_sequencer] build_phase @ UVM_HIGH",   UVM_HIGH)
    `uvm_info(get_type_name(), "[router_sequencer] build_phase @ UVM_FULL",   UVM_FULL)
  endfunction

endclass : router_sequencer
