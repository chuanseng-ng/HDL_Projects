## fifo_mem Architecture, Design and Verification Details

### Commands to run sanity test
#### Without Wave Dump
```bash
cd scripts
make run_all
```
#### With Waveform Dump
```bash
cd scripts
make run_all_gui
```
### Directory Structure
```
fifo_mem
.
├── docs
├── README.md
├── rtl
│   └── fifo_mem.sv
├── scripts
│   ├── logw.tcl
│   └── Makefile
├── sim
│   ├── env
│   │   ├── agent
│   │   │   ├── fifo_mem_agent_cfg.sv
│   │   │   ├── fifo_mem_agent_pkg.sv
│   │   │   ├── fifo_mem_agent.sv
│   │   │   ├── fifo_mem_driver.sv
│   │   │   ├── fifo_mem_intf.sv
│   │   │   ├── fifo_mem_monitor.sv
│   │   │   ├── fifo_mem_sequencer.sv
│   │   │   ├── regs
│   │   │   │   └── fifo_mem_regs_pkg.sv
│   │   │   └── sequence_lib
│   │   │       ├── fifo_mem_base_seq.sv
│   │   │       ├── fifo_mem_sanity_seq.sv
│   │   │       ├── fifo_mem_seq_item.sv
│   │   │       └── fifo_mem_seq_pkg.sv
│   │   ├── fifo_mem_cov.sv
│   │   ├── fifo_mem_env_pkg.sv
│   │   ├── fifo_mem_env.sv
│   │   └── fifo_mem_sb.sv
│   ├── tb
│   │   └── fifo_mem_tb.sv
│   └── tests
│       ├── fifo_mem_base_test.sv
│       ├── fifo_mem_sanity_test.sv
│       └── fifo_mem_test_pkg.sv
└── synth
```
**Note** : .gitignore is added to project directory for easy git integration.
