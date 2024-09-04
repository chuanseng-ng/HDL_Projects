`ifndef FIFO_MEM_SANITY_TEST__SV
`define FIFO_MEM_SANITY_TEST__SV

  class fifo_mem_sanity_test extends fifo_mem_base_test;

    // Factory Registration
    `uvm_component_utils(fifo_mem_sanity_test)

    // Sequence to start
    fifo_mem_sanity_seq seqh;

    extern function new(string name = "fifo_mem_sanity_test", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual function void report_phase(uvm_phase phase);
  endclass

  function fifo_mem_sanity_test::new(string name = "fifo_mem_sanity_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void fifo_mem_sanity_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  function void fifo_mem_sanity_test::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task fifo_mem_sanity_test::run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info(get_full_name(), "[fifo_mem] Starting sanity Test", UVM_NONE)
    seqh = fifo_mem_sanity_seq::type_id::create("seqh");
    seqh.start(envh.agnth.seqrh);
    phase.drop_objection(this);
  endtask

  function void fifo_mem_sanity_test::report_phase(uvm_phase phase);
    super.report_phase(phase);
  endfunction

`endif

//End of fifo_mem_sanity_test
