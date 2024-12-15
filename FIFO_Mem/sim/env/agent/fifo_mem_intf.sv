`ifndef FIFO_MEM_INTF__SV
`define FIFO_MEM_INTF__SV

  interface fifo_mem_intf #(
    parameter int DATA_WIDTH = 16
  ) (
    input clk,
    input areset_b
    );

    // Signals
    logic trans_read;
    logic trans_write;
    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;
    logic full_ind;
    logic empty_ind;
    logic overflow_ind;
    logic underflow_ind;
    logic threshold_ind;

  endinterface

`endif

//End of fifo_mem_intf
