# This repo is to track FIFO memory project
- Spec is listed below
- Status is listed below
- Changelist is listed below

## Spec:
- FIFO memory accepts DATA_WIDTH parameter (Data width can be configured - Default is 32 bits)
- Size of FIFO memory can be configured with OSTD_NUM (Outstanding number can be configured - Default is 4)
    - Width of read/write pointer is taken to be log2(OSTD_NUM) unless OSTD_NUM == 0 then pointer width = 1
- Monitoring signals include the following:
    - Full      - High when FIFO is full
    - Empty     - High when FIFO is empty
    - Overflow  - High when FIFO is full & transaction is still writing to FIFO (Might be redundant)
    - Underflow - High when FIFO is empty & transaction is reading from FIFO (Might be redundant)
    - Threshold - High when number of data in FIFO is lesser than threshold value (Might be redundant)

## Status:
- 20240908 - Add input vs output comparison check
- 20240908 - Fix UVM TB to match design spec & expectation
- 20240904 - Add UVM TB
- 20240807 - Debug TB not incrementing beyond addr = 4 (Fixed FIFO size & read/write pointer unable to increment)
- 20240807 - V1 release
- 20240807 - Init DB

## Changelist:
- 20240908 - Add input vs output comparison check
- 20240908 - Modify UVM TB to match design expectation
- 20240908 - Modify 2D memory_array to dump register values in waveform
- 20240904 - Add UVM TB env files
- 20240810 - Style-checker & Linter fix
- 20240807 - Bug fix for FIFO size
- 20240807 - Compile fix
- 20240807 - V1 release

## To-Do:
- Modify UVM TB to limit write/read to OSTD_NUM defined in run/DUT
- Evaluate pass/fail based on number of read & write

## Reference:
- https://www.fpga4student.com/2017/01/verilog-code-for-fifo-memory.html