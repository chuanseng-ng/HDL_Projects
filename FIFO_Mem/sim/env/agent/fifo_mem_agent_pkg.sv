`ifndef FIFO_MEM_AGENT_PKG__SV
`define FIFO_MEM_AGENT_PKG__SV

  package fifo_mem_agent_pkg;

    // Import UVM
    import uvm_pkg::*;
    import fifo_mem_regs_pkg::*;
    import fifo_mem_seq_pkg::*;
    `include "uvm_macros.svh"

    // Include Agent UVCs
    // `include "fifo_mem_intf.sv"
    `include "fifo_mem_agent_cfg.sv"
    `include "fifo_mem_driver.sv"
    // Move fifo_mem_sb.sv from fifo_mem_env.sv
    // fifo_mem_monitor.sv will call fifo_mem_sb
    `include "../fifo_mem_sb.sv"
    `include "fifo_mem_monitor.sv"
    `include "fifo_mem_sequencer.sv"
    `include "fifo_mem_agent.sv"
  endpackage

`endif

//End of fifo_mem_agent_pkg
