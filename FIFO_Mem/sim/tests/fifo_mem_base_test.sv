`ifndef FIFO_MEM_BASE_TEST__SV
`define FIFO_MEM_BASE_TEST__SV

  class fifo_mem_base_test extends uvm_test;

    // Factory Registration
    `uvm_component_utils(fifo_mem_base_test)

    // Declare UVC
    fifo_mem_env envh;

    extern function new(string name = "fifo_mem_base_test", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual function void report_phase(uvm_phase phase);
  endclass

  function fifo_mem_base_test::new(string name = "fifo_mem_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void fifo_mem_base_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    envh = fifo_mem_env::type_id::create("envh", this);
  endfunction

  function void fifo_mem_base_test::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task fifo_mem_base_test::run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info(get_full_name(), "[fifo_mem] Starting Base Test", UVM_NONE)
    phase.drop_objection(this);
  endtask

  function void fifo_mem_base_test::report_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

`endif

//End of fifo_mem_base_test
