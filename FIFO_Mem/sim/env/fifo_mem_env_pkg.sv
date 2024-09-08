`ifndef FIFO_MEM_ENV_PKG__SV
`define FIFO_MEM_ENV_PKG__SV

  package fifo_mem_env_pkg;

    // Import UVM
    import uvm_pkg::*;
    import fifo_mem_seq_pkg::*;
    import fifo_mem_regs_pkg::*;
    import fifo_mem_agent_pkg::*;
    `include "uvm_macros.svh"

    // Import UVM
    // Move fifo_mem_sb.sv to fifo_mem_env.sv
    // fifo_mem_monitor.sv will call fifo_mem_sb
    //`include "fifo_mem_sb.sv"
    `include "fifo_mem_cov.sv"
    `include "fifo_mem_env.sv"
  endpackage

`endif

//End of fifo_mem_env_pkg
