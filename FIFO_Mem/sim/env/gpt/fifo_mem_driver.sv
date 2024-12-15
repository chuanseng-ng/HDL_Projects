class fifo_mem_driver extends uvm_driver #(fifo_transaction);
    virtual fifo_if vif; // FIFO interface

    function new(string name = "fifo_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        fifo_transaction tr;
        forever begin
            seq_item_port.get_next_item(tr);
            // Drive signals to FIFO
            vif.data_in     <= tr.data;
            vif.trans_read  <= tr.trans_read;
            vif.trans_write <= tr.trans.write;

            @(posedge vif.clk_in); // Wait for clock edge
            seq_item_port.item_done();
        end
    endtask

endclass
