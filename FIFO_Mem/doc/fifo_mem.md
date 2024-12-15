
# Entity: fifo_mem 
- **File**: fifo_mem.sv
- **Title:**  FIFO Memory

## Diagram
![Diagram](fifo_mem.svg "Diagram")
## Description


## Generics

| Generic name    | Type | Value      | Description                              |
| --------------- | ---- | ---------- | ---------------------------------------- |
| DATA_WIDTH      | int  | 32         | Transaction data width                   |
| OSTD_NUM        | int  | 4          | Number of outstanding transactions       |
| THRESHOLD_VALUE | int  | OSTD_NUM/2 | Minimum numbr of expected values in FIFO |

## Ports

| Port name     | Direction | Type             | Description               |
| ------------- | --------- | ---------------- | ------------------------- |
| clk_in        | input     |        -         | Clock source              |
| areset_b      | input     |        -         | Reset source - Active low |
| trans_read    | input     |        -         | Transaction read request  |
| trans_write   | input     |        -         | Transaction write request |
| data_in       | input     | [DATA_WIDTH-1:0] | Transaction data input    |
| data_out      | output    | [DATA_WIDTH-1:0] | Transaction data output   |
| full_ind      | output    |        -         | FIFO full indicator       |
| empty_ind     | output    |        -         | FIFO empty indicator      |
| overflow_ind  | output    |        -         | FIFO overflow indicator   |
| underflow_ind | output    |        -         | FIFO underflow indicator  |
| threshold_ind | output    |        -         | FIFO threshold indicator  |

## Signals

| Name         | Type               | Description       |
| ------------ | ------------------ | ----------------- |
| read_ptr     | reg [OSTD_NUM-1:0] | Read pointer      |
| write_ptr    | reg [OSTD_NUM-1:0] | Write pointer     |
| fifo_renable | wire               | FIFO write enable |
| fifo_wenable | wire               | FIFO read enable  |

## Constants

| Name     | Type | Value                                 | Description                                              |
| -------- | ---- | ------------------------------------- | -------------------------------------------------------- |
| PTR_SIZE |      | (OSTD_NUM > 1) ? $clog2(OSTD_NUM) : 1 | Set pointer size to be 2^N = OSTD_NUM - Unused parameter |

## Instantiations

- u_write_pointer: rd_wr_ptr
- u_read_pointer: rd_wr_ptr
- u_mem_array: memory_array
- u_monitor_signal: monitor_signal
