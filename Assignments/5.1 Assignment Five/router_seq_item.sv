//------------------------------------------------------------------------
// router_seq_item.sv
// Transaction modeling one router stimulus cycle: 4 input channels in,
// 2 output channels captured back by the monitor after the DUT reacts.
//------------------------------------------------------------------------
class router_seq_item extends uvm_sequence_item;

  // Stimulus (driven by the driver)
  rand bit [7:0] data_in  [4];
  rand bit       valid_in [4];

  // Response (filled in by the monitor when it samples the DUT outputs;
  // the driver leaves these at their default value)
  bit [7:0] data_out  [2];
  bit       valid_out [2];

  `uvm_object_utils(router_seq_item)

  // Bias: make sure valid_in is asserted most of the time so the router
  // actually has meaningful traffic to route, but still let all-zero
  // (idle) cycles occur occasionally.
  constraint c_valid_dist {
    foreach (valid_in[i]) {
      valid_in[i] dist {1'b1 := 80, 1'b0 := 20};
    }
  }

  function new(string name = "router_seq_item");
    super.new(name);
  endfunction

  function void do_copy(uvm_object rhs);
    router_seq_item rhs_;
    if (!$cast(rhs_, rhs)) begin
      `uvm_fatal("DO_COPY", "Cast of rhs object failed")
    end
    super.do_copy(rhs);
    foreach (data_in[i])  data_in[i]  = rhs_.data_in[i];
    foreach (valid_in[i]) valid_in[i] = rhs_.valid_in[i];
    foreach (data_out[i]) data_out[i] = rhs_.data_out[i];
    foreach (valid_out[i]) valid_out[i] = rhs_.valid_out[i];
  endfunction

  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    router_seq_item rhs_;
    bit match;
    if (!$cast(rhs_, rhs)) return 0;
    match = 1;
    foreach (data_in[i])   match &= (data_in[i]  == rhs_.data_in[i]);
    foreach (valid_in[i])  match &= (valid_in[i] == rhs_.valid_in[i]);
    foreach (data_out[i])  match &= (data_out[i] == rhs_.data_out[i]);
    foreach (valid_out[i]) match &= (valid_out[i] == rhs_.valid_out[i]);
    return match;
  endfunction

  function string convert2string();
    string s;
    s = $sformatf(
      "in0=%0d(v=%0b) in1=%0d(v=%0b) in2=%0d(v=%0b) in3=%0d(v=%0b) || out0=%0d(v=%0b) out1=%0d(v=%0b)",
      data_in[0], valid_in[0], data_in[1], valid_in[1],
      data_in[2], valid_in[2], data_in[3], valid_in[3],
      data_out[0], valid_out[0], data_out[1], valid_out[1]);
    return s;
  endfunction

  function void do_print(uvm_printer printer);
    printer.print_string("txn", convert2string());
  endfunction

endclass : router_seq_item
