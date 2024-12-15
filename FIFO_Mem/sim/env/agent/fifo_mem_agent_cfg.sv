`ifndef FIFO_MEM_AGENT_CFG__SV
`define FIFO_MEM_AGENT_CFG__SV

  class fifo_mem_agent_cfg extends uvm_object;

    // Factory Registration
    `uvm_object_utils(fifo_mem_agent_cfg)

    // UVM Agent Controls

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    // Tasks and Functions

    extern function new(string name = "fifo_mem_agent_cfg");

  endclass

  function fifo_mem_agent_cfg::new(string name = "fifo_mem_agent_cfg");
    super.new(name);
  endfunction

`endif

//End of fifo_mem_agent_cfg
