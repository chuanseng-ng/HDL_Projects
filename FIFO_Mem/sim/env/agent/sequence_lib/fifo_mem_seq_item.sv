`ifndef FIFO_MEM_SEQ_ITEM__SV
`define FIFO_MEM_SEQ_ITEM__SV

  class fifo_mem_seq_item extends uvm_sequence_item;
    int unsigned wr_cycle_count;
    int unsigned rd_cycle_count;

    // Factory Registration
    `uvm_object_utils(fifo_mem_seq_item)

    // Randomization Variables
    //rand logic we;
    //randc logic [3:0] addr;
    //rand logic [7:0] wdata;
    //logic [7:0] rdata;
    logic clk;
    logic areset_b;
    rand logic trans_read;
    rand logic trans_write;
    rand logic [31:0] data_in;

    logic [31:0] data_out;
    logic full_ind;
    logic empty_ind;
    logic overflow_ind;
    logic underflow_ind;
    logic threshold_ind;

    constraint data_range_c {data_in inside{[0:31]};}
    constraint trans_wr_c {
      trans_write dist { 1 := 50, 0 := 50};
    }
    constraint trans_rd_c {
      trans_read dist {1 := 40, 0 := 60};
    }

    extern function new(string name = "fifo_mem_seq_item");

  endclass

  function fifo_mem_seq_item::new(string name = "fifo_mem_seq_item");
    super.new(name);
  endfunction

`endif

//End of fifo_mem_seq_item
