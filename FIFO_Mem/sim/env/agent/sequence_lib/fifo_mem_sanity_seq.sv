`ifndef FIFO_MEM_SANITY_SEQ__SV
`define FIFO_MEM_SANITY_SEQ__SV

  class fifo_mem_sanity_seq extends fifo_mem_base_seq;

    // Factory Registration
    `uvm_object_utils(fifo_mem_sanity_seq)

    // Variables

    // Tasks and Functions

    extern function new(string name = "fifo_mem_sanity_seq");
    extern virtual task body();
  endclass

  function fifo_mem_sanity_seq::new(string name = "fifo_mem_sanity_seq");
    super.new(name);
  endfunction

  task fifo_mem_sanity_seq::body();
    super.body();
    `uvm_info(get_full_name(), "[FIFO_MEM] Starting Sanity Sequence", UVM_LOW)
    repeat(17) begin
      `uvm_do_with(req, {we==1;})
    end
    // wait_for_item_done();
  endtask

`endif

//End of fifo_mem_sanity_seq
