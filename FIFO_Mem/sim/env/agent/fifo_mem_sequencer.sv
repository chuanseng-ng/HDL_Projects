`ifndef FIFO_MEM_SEQUENCER__SV
`define FIFO_MEM_SEQUENCER__SV

  class fifo_mem_sequencer extends uvm_sequencer#(fifo_mem_seq_item);

    // Factory Registration
    `uvm_component_utils(fifo_mem_sequencer)

    // Tasks and Functions
    extern function new(string name = "fifo_mem_sequencer", uvm_component parent = null);
  endclass

  function fifo_mem_sequencer::new(string name = "fifo_mem_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

`endif

//End of fifo_mem_sequencer
