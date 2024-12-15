`ifndef FIFO_MEM_BASE_SEQ__SV
`define FIFO_MEM_BASE_SEQ__SV

  class fifo_mem_base_seq extends uvm_sequence#(fifo_mem_seq_item);

    // Factory Registration
    `uvm_object_utils(fifo_mem_base_seq)

    // Variables

    // Tasks and Functions
    extern function new(string name = "fifo_mem_base_seq");
    extern virtual task body();

  endclass

  function fifo_mem_base_seq::new(string name = "fifo_mem_base_seq");
    super.new(name);
  endfunction

  task fifo_mem_base_seq::body();

  endtask

`endif

//End of fifo_mem_base_seq
