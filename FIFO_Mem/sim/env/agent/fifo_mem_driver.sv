`ifndef FIFO_MEM_DRIVER__SV
`define FIFO_MEM_DRIVER__SV

  class fifo_mem_driver extends uvm_driver #(fifo_mem_seq_item);

    // Factory Registeration
    `uvm_component_utils(fifo_mem_driver)

    // Virtual Interface
    virtual fifo_mem_intf vintf;

    // Tasks and Functions
    extern function new(string name = "fifo_mem_driver", uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    // extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task reset_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual task drive_task(fifo_mem_seq_item seq_item);
  endclass

  function fifo_mem_driver::new(string name = "fifo_mem_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void fifo_mem_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_mem_intf)::get(this, "", "vintf", vintf)) begin
      `uvm_fatal(get_type_name(),"[FIFO_MEM] Couldn't get vintf, did you set it?")
    end
  endfunction

  task fifo_mem_driver::drive_task(fifo_mem_seq_item seq_item);
    `uvm_info(get_full_name(), "[FIFO_MEM] Received Sequence Item in Driver", UVM_LOW)
    @(posedge vintf.clk);
    if (~seq_item.areset_b) begin
      seq_item.reset_cycle_count();
    end else begin
      seq_item.update_wr_cycle_count();
      seq_item.update_rd_cycle_count();
    end
    //if (~seq_item.randomize()) begin
    //  `uvm_error(get_full_name(), "[SEQ] Failed to randomize seq_item logics")
    //end
    // Inputs
    //vintf.areset_b      <= seq_item.areset_b;
    vintf.trans_read    <= seq_item.trans_read;
    vintf.trans_write   <= seq_item.trans_write;
    vintf.data_in       <= seq_item.data_in;
    // Outputs
    vintf.data_out      <= seq_item.data_out;
    vintf.full_ind      <= seq_item.full_ind;
    vintf.empty_ind     <= seq_item.empty_ind;
    vintf.overflow_ind  <= seq_item.overflow_ind;
    vintf.underflow_ind <= seq_item.underflow_ind;
    vintf.threshold_ind <= seq_item.threshold_ind;
  endtask

  task fifo_mem_driver::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    phase.raise_objection(this);
    `uvm_info(get_full_name(), "[FIFO_MEM] Resetting DUT from Driver", UVM_NONE)
    //vintf.clk_in        <= 'b0;
    //vintf.areset_b      <= 'b1;
    vintf.trans_read    <= 'b0;
    vintf.trans_write   <= 'b0;
    vintf.data_in       <= 'd0;
    vintf.data_out      <= 'd0;
    vintf.full_ind      <= 'b0;
    vintf.empty_ind     <= 'b0;
    vintf.overflow_ind  <= 'b0;
    vintf.underflow_ind <= 'b0;
    vintf.threshold_ind <= 'b0;
    @(posedge vintf.clk);
    phase.drop_objection(this);
  endtask

  task fifo_mem_driver::run_phase(uvm_phase phase);
    // super.run_phase(phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive_task(req);
      seq_item_port.item_done();
    end
  endtask

`endif

//End of fifo_mem_driver
