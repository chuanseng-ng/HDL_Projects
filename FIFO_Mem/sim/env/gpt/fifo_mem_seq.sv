class fifo_mem_seqr extends uvm_sequencer #(fifo_transaction);
    function new(string name = "fifo_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass

class fifo_mem_seq extends uvm_sequence #(fifo_transaction);
    function new(string name = "fifo_sequence", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task body();
        fifo_transction tr;
        repeat(10) begin
            tr = fifo_transaction::new();

            tr.data        = $urandom;
            tr.trans_read  = $urandom % 2;
            tr.trans_write = $urandom % 2;
            start_item(tr);
            finish_item(tr);
        end
    endtask
endclass
