`ifndef FIFO_MEM_ENV__SV
`define FIFO_MEM_ENV__SV

  class fifo_mem_env extends uvm_env;

    // Factory Registration
    `uvm_component_utils(fifo_mem_env)

    // Environment Variables
    bit is_scoreboard_enable = 1;
    bit is_coverage_enable = 1;

    // Declare UVC
    fifo_mem_agent_cfg agnt_cfg;
    fifo_mem_agent agnth;
    fifo_mem_sb sbh;
    fifo_mem_cov covh;

    extern function new (string name = "fifo_mem_env", uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
  endclass

  function fifo_mem_env::new(string name = "fifo_mem_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void fifo_mem_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "[FIFO_MEM] Starting Build Phase", UVM_LOW)
    agnt_cfg = fifo_mem_agent_cfg::type_id::create("agnt_cfg");
    uvm_config_db #(fifo_mem_agent_cfg)::set(this, "*", "agnt_cfg", agnt_cfg);
    agnth = fifo_mem_agent::type_id::create("agnth", this);
    if(is_scoreboard_enable) begin
      sbh = fifo_mem_sb::type_id::create("sbh", this);
    end
    if(is_coverage_enable) begin
      covh = fifo_mem_cov::type_id::create("covh", this);
    end
    `uvm_info(get_full_name(), "[FIFO_MEM] Ending Build Phase", UVM_LOW)
  endfunction

  function void fifo_mem_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "[FIFO_MEM] Starting Connect Phase", UVM_LOW)
    if(is_scoreboard_enable) begin
      agnth.monh.mon_port.connect(sbh.sb_fifo.analysis_export);
    end
    if(is_coverage_enable) begin
      agnth.monh.mon_port.connect(covh.analysis_export);
    end
    `uvm_info(get_full_name(), "[FIFO_MEM] Ending Connect Phase", UVM_LOW)
  endfunction

`endif

//End of fifo_mem_env
