`ifndef FIFO_MEM_COV__SV
`define FIFO_MEM_COV__SV

  class fifo_mem_cov extends uvm_subscriber#(fifo_mem_seq_item);

    // Factory Registration
    `uvm_component_utils(fifo_mem_cov)

    extern function new(string name = "fifo_mem_cov", uvm_component parent = null);
    extern virtual function void write(fifo_mem_seq_item t);
  endclass

  function fifo_mem_cov::new(string name = "fifo_mem_cov", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void fifo_mem_cov::write(fifo_mem_seq_item t);
    `uvm_info(get_full_name(), "[FIFO_MEM] Received item in Subscriber", UVM_LOW)
    `uvm_info(get_full_name(), $sformatf("\n[FIFO_MEM] Packet Data:\n\twe: %0d,\n\taddr: %0d,\n\twdata: %0d,\n\trdata: %0d",
      t.we, t.addr, t.wdata, t.rdata), UVM_LOW)
  endfunction

`endif

//End of fifo_mem_cov
