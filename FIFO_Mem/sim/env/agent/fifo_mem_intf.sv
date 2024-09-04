`ifndef FIFO_MEM_INTF__SV
`define FIFO_MEM_INTF__SV

  interface fifo_mem_intf(input clk);

    // Signals
    logic we;
    logic [3:0] addr;
    logic [7:0] wdata;
    logic [7:0] rdata;

  endinterface

`endif

//End of fifo_mem_intf
