`ifndef FIFO_MEM_MONITOR__SV
`define FIFO_MEM_MONITOR__SV

  class fifo_mem_monitor extends uvm_monitor;

    // Factory Registration
    `uvm_component_utils(fifo_mem_monitor)

    // Variables
    fifo_mem_seq_item fifo_mem_seq_item_h;

    // Interface
    virtual fifo_mem_intf vintf;

    // Analysis Port
    uvm_analysis_port #(fifo_mem_seq_item) mon_port;

    // Tasks and Functions
    extern function new(string name = "fifo_mem_monitor", uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    // extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual task mon_task();

  endclass

  function fifo_mem_monitor::new(string name = "fifo_mem_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void fifo_mem_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_mem_intf)::get(this, "", "vintf", vintf)) begin
      `uvm_fatal(get_type_name(), "[FIFO_MEM] Couldn't get vintf, did you set it?")
    end
    mon_port = new("mon_port", this);
  endfunction

  task fifo_mem_monitor::run_phase(uvm_phase phase);
    super.run_phase(phase);
    mon_task();
  endtask

  task fifo_mem_monitor::mon_task();
    fifo_mem_seq_item_h = fifo_mem_seq_item::type_id::create("fifo_mem_seq_item_h");
    forever begin
      @(posedge vintf.clk);
      fifo_mem_seq_item_h.clk         = vintf.clk;
      fifo_mem_seq_item_h.trans_read  = vintf.trans_read;
      fifo_mem_seq_item_h.trans_write = vintf.trans_write;
      fifo_mem_seq_item_h.data_in     = vintf.data_in;
      fifo_mem_seq_item_h.data_out = vintf.data_out;
      mon_port.write(fifo_mem_seq_item_h);
      `uvm_info(get_full_name(), "[FIFO_MEM] Written Sequence Item from Monitor", UVM_LOW)
    end
  endtask

`endif

//End of fifo_mem_monitor
