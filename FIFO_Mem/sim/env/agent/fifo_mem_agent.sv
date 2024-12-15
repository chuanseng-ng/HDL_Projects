`ifndef FIFO_MEM_AGENT__SV
`define FIFO_MEM_AGENT__SV

  class fifo_mem_agent extends uvm_agent;

    // Factory Registration
    `uvm_component_utils(fifo_mem_agent)

    // Agent config
    fifo_mem_agent_cfg agnt_cfg;

    // UVCs
    fifo_mem_driver     drvh;
    fifo_mem_monitor    monh;
    fifo_mem_sequencer  seqrh;

    // Tasks and Functions
    extern function new(string name = "fifo_mem_agent", uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    // extern virtual task run_phase(uvm_phase);
  endclass

  function fifo_mem_agent::new(string name = "fifo_mem_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void fifo_mem_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "[FIFO_MEM] Starting Build Phase", UVM_LOW)

    // agnt_cfg = fifo_mem_agent_cfg::type_id::create("agnt_cfg");
    if(!uvm_config_db#(fifo_mem_agent_cfg)::get(this, "", "agnt_cfg", agnt_cfg)) begin
      `uvm_fatal(get_type_name(), "[FIFO_MEM] Couldn't get agnt_cfg, did you set it?")
    end

    // Build UVC
    monh = fifo_mem_monitor::type_id::create("monh", this);
    if(agnt_cfg.is_active == UVM_ACTIVE) begin
      drvh = fifo_mem_driver::type_id::create("drvh", this);
      seqrh = fifo_mem_sequencer::type_id::create("seqrh", this);
    end
    `uvm_info(get_full_name(), "[FIFO_MEM] Ending Build Phase", UVM_LOW)
  endfunction

  function void fifo_mem_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "[FIFO_MEM] Starting Connect Phase", UVM_LOW)
    if(agnt_cfg.is_active == UVM_ACTIVE) begin
      drvh.seq_item_port.connect(seqrh.seq_item_export);
    end
    `uvm_info(get_full_name(), "[FIFO_MEM] Ending Connect Phase", UVM_LOW)
  endfunction

`endif

//End of fifo_mem_agent
