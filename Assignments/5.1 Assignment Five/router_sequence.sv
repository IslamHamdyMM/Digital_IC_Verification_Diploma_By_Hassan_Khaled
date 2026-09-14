//------------------------------------------------------------------------
// router_sequence.sv
// Representative sequence: generates a stream of randomized router
// transactions, including a couple of directed corner cases
// (all-idle cycle, and both channels of a given output contending
// at once) layered on top of random traffic.
//------------------------------------------------------------------------
class router_base_sequence extends uvm_sequence #(router_seq_item);
  `uvm_object_utils(router_base_sequence)

  rand int unsigned num_txns = 20;

  function new(string name = "router_base_sequence");
    super.new(name);
  endfunction

  task body();
    router_seq_item item;

    `uvm_info(get_type_name(),
      $sformatf("Starting router_base_sequence with %0d transactions", num_txns), UVM_MEDIUM)

    // Directed corner case #1: everything idle
    item = router_seq_item::type_id::create("idle_item");
    start_item(item);
    if (!item.randomize() with {
          foreach (valid_in[i]) valid_in[i] == 0;
        }) `uvm_error(get_type_name(), "Randomization failed (idle case)")
    finish_item(item);

    // Directed corner case #2: contention on both outputs
    item = router_seq_item::type_id::create("contend_item");
    start_item(item);
    if (!item.randomize() with {
          foreach (valid_in[i]) valid_in[i] == 1;
        }) `uvm_error(get_type_name(), "Randomization failed (contention case)")
    finish_item(item);

    // Random traffic
    repeat (num_txns) begin
      item = router_seq_item::type_id::create("item");
      start_item(item);
      if (!item.randomize())
        `uvm_error(get_type_name(), "Randomization failed")
      finish_item(item);
    end
  endtask

endclass : router_base_sequence
