class fifo_mem_mon extends uvm_monitor;
    virtual fifo_if vif;
    uvm_analysis_port #(fifo_transaction) ap;

    function new(string name = "fifo_monitor", uvm_compnonent parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    task run_phase(uvm_phase phase);
        fifo_transaction tr;
        forever begin
            // Sample signals from FIFO
            tr = fifo_transaction::new();

            tr.data        = vif.data_out;
            tr.trans_read  = vif.trans_read;
            tr.trans_write = vif.trans_write;
            ap.write(tr);

            @(posedge vif.clk_in); // Wait for clock edge
        end
    endtask

endclass
