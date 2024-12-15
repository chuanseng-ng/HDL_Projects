`ifndef FIFO_MEM_SB__SV
`define FIFO_MEM_SB__SV

  class fifo_mem_sb extends uvm_scoreboard;
    protected bit [31:0] read_data_queue[$];
    protected bit [31:0] write_data_queue[$];

    // Factory Registration
    `uvm_component_utils(fifo_mem_sb)

    // Analysis Fifo
    uvm_tlm_analysis_fifo #(fifo_mem_seq_item) sb_fifo;

    // Data Item
    fifo_mem_seq_item seq_item;

    virtual function void write_trans(bit write_en, bit areset_b, bit [31:0] data);
      if (~areset_b) begin
        write_data_queue.delete();
        `uvm_info(get_full_name(), ("[SCOREBOARD] Reset triggered - Write data queue will be resetted!"), UVM_MEDIUM)
      end else if (write_en) begin
        write_data_queue.push_back(data);
        `uvm_info(get_full_name(), $sformatf("[SCOREBOARD] Data written to scoreboard: 0x%0h", data), UVM_MEDIUM)
      end
    endfunction

    virtual function void read_trans_compare(bit read_en, bit write_en, bit areset_b, bit [31:0] data);
      if (~areset_b) begin
        `uvm_info(get_full_name(), ("[SCOREBOARD] Reset triggered - Read will be skipped!"), UVM_MEDIUM)
      end else if (read_en) begin
        if (write_data_queue.size() == 0) begin
          `uvm_error(get_full_name(), "[SCOREBOARD] No data in write queue to compare against")
        end else if (write_en && (write_data_queue.size() - 1 == 0)) begin
          `uvm_info(get_full_name(), "[SCOREBOARD] Read will be skipped - Not support concurrent read-write when FIFO is empty", UVM_LOW)
        end else begin
          bit [31:0] expected_data = write_data_queue.pop_front();
          `uvm_info(get_full_name(), $sformatf("[SCOREBOARD] Data to compare against: 0x%0h", data), UVM_LOW)

          if (expected_data == data) begin
            `uvm_info(get_full_name(), $sformatf("[SCOREBOARD] Data check match: 0x%0h", data), UVM_LOW)
          end else begin
            `uvm_error(get_full_name(), $sformatf("[SCOREBOARD] Data check mismatch! Expected: 0x%0h, Got: 0x%0h", expected_data, data))
          end
        end
      end
    endfunction

    // Tasks and Functions
    extern function new(string name = "fifo_mem_sb", uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
  endclass

  function fifo_mem_sb::new(string name = "fifo_mem_sb", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void fifo_mem_sb::build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_fifo = new("sb_fifo", this);
  endfunction

  task fifo_mem_sb::run_phase(uvm_phase phase);
    forever begin
      sb_fifo.get(seq_item);
      @(posedge seq_item.clk);
      `uvm_info(get_full_name(), "[FIFO_MEM] Received new item in SB", UVM_LOW)
      `uvm_info(get_full_name(), $sformatf("\n[FIFO_MEM] Packet Data:\n\trans_write: %0d,\n\ttrans_read: %0d,\n\tdata_in: %0d,\n\tdata_out: %0d",
      seq_item.trans_write, seq_item.trans_read, seq_item.data_in, seq_item.data_out), UVM_LOW)
    end
  endtask

`endif

//End of fifo_mem_sb
