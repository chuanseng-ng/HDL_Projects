`ifndef FIFO_MEM_TEST_PKG__SV
`define FIFO_MEM_TEST_PKG__SV

  package fifo_mem_test_pkg;

    // Import UVM
    import uvm_pkg::*;
    import fifo_mem_seq_pkg::*;
    import fifo_mem_regs_pkg::*;
    import fifo_mem_agent_pkg::*;
    import fifo_mem_env_pkg::*;
    `include "uvm_macros.svh"

    // Import UVC
    `include "fifo_mem_base_test.sv"
    `include "fifo_mem_sanity_test.sv"

  endpackage

`endif

//End of fifo_mem_test_pkg
