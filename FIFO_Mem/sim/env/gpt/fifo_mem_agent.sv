class fifo_mem_agent extends uvm_agent;
    fifo_mem_driver fdrv;
    fifo_mem_mon fmon;
    fifo_mem_seqr fseqr;
    fifo_mem_scoreb fsb;

    function new(string name = "fifo_agent", uvm_component parent = null);
        super.new(name, parent);
        fdrv = fifo_mem_driver::new("fdrv", this);
        fmon = fifo_mem_mon::new("fmon", this);
        fseq = fifo_mem_seqr::new("fseqr", this);
        fsb  = fifo_mem_scoreb::new("fsb", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Instantiate components
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect components
        fdrv.seq_item_port.connect(fseqr.seq_item_export);
        fmon.ap.connect(fsb.ap);
    endfunction
endclass
