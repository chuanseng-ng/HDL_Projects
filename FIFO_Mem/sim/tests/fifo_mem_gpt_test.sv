class fifo_mem_gpt_test extends uvm_test;
    fifo_mem_agent agent;
    fifo_mem_seq fseq;

    function new(string name = "fifo_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = fifo_mem_agent::new("agent", this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        // Start sequence
        fifo_mem_seq fseq = fifo_mem_seq::new("fseq", this);
        agent.freq.start(fseq);
    endtask
endclass
