`ifndef FIFO_MEM_SEQ_PKG__SV
`define FIFO_MEM_SEQ_PKG__SV

  package fifo_mem_seq_pkg;

    // Import UVM Macros and Package
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Include all sequence items and sequences
    `include "fifo_mem_seq_item.sv"
    `include "fifo_mem_base_seq.sv"
    `include "fifo_mem_sanity_seq.sv"

  endpackage

`endif

//End of fifo_mem_seq_pkg
