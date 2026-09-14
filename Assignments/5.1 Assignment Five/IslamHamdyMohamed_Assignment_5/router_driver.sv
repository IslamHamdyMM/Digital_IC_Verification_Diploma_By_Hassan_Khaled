//------------------------------------------------------------------------
// router_driver.sv
// Drives router_seq_item transactions onto the DUT interface.
//
// Protocol timing: router.v is purely combinational (data_out reacts in
// the same delta cycle as data_in/valid_in change), so the driver
// synchronizes stimulus changes to the testbench clock edge: it applies
// new inputs shortly after posedge clk and holds them until the next
// posedge, giving the monitor a full, stable clock period in which to
// sample the combinational response.
//------------------------------------------------------------------------
class router_driver extends uvm_driver #(router_seq_item);
  `uvm_component_utils(router_driver)

  virtual router_if vif;
  router_config     cfg;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "[router_driver] build_phase @ UVM_LOW",    UVM_LOW)
    `uvm_info(get_type_name(), "[router_driver] build_phase @ UVM_MEDIUM", UVM_MEDIUM)
    `uvm_info(get_type_name(), "[router_driver] build_phase @ UVM_HIGH",   UVM_HIGH)
    `uvm_info(get_type_name(), "[router_driver] build_phase @ UVM_FULL",   UVM_FULL)

    if (!uvm_config_db#(router_config)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal(get_type_name(), "router_config not found in config_db")
    end
    vif = cfg.vif;
    if (vif == null) begin
      `uvm_fatal(get_type_name(), "Virtual interface handle inside router_config is null")
    end
  endfunction

  task run_phase(uvm_phase phase);
    // Hold interface in idle until reset deasserts
    drive_idle();
    wait (vif.rst_n === 1'b1);
    @(posedge vif.clk);

    forever begin
      router_seq_item req;
      seq_item_port.get_next_item(req);
      drive_transaction(req);
      seq_item_port.item_done();
    end
  endtask

  task drive_idle();
    vif.data_in0  <= 8'h00; vif.data_in1  <= 8'h00;
    vif.data_in2  <= 8'h00; vif.data_in3  <= 8'h00;
    vif.valid_in0 <= 1'b0;  vif.valid_in1 <= 1'b0;
    vif.valid_in2 <= 1'b0;  vif.valid_in3 <= 1'b0;
  endtask

  task drive_transaction(router_seq_item req);
    @(posedge vif.clk);
    vif.data_in0  <= req.data_in[0];
    vif.data_in1  <= req.data_in[1];
    vif.data_in2  <= req.data_in[2];
    vif.data_in3  <= req.data_in[3];
    vif.valid_in0 <= req.valid_in[0];
    vif.valid_in1 <= req.valid_in[1];
    vif.valid_in2 <= req.valid_in[2];
    vif.valid_in3 <= req.valid_in[3];
    `uvm_info(get_type_name(),
      $sformatf("Driving transaction: %s", req.convert2string()), UVM_HIGH)
  endtask

endclass : router_driver
