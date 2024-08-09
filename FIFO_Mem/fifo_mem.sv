/*
    Module - FIFO Memory
    Standard Inputs:
        - clk_in
        - areset_b
        - fifo_wenable
        - fifo_renable

    Data Inputs:
        - data_in [DATA_WIDTH-1:0]

    Data Outputs:
        - data_out [DATA_WIDTH-1:0]

    Internal Monitoring Signals:
        - full_ind
        - empty_ind
        - overflow_ind
        - underflow_ind
        - threshold_ind

    Internal Pointer Signals:
        - write_ptr [PTR_SIZE-1:0]
        - read_ptr  [PTR_SIZE-1:0]

    Assumptions:
        - Data read out is in order - Order will not jump/skip to next before current is read
*/


// Main module
module fifo_mem #(
    parameter int DATA_WIDTH      = 32,
    parameter int OSTD_NUM        = 4,
    parameter int THRESHOLD_VALUE = OSTD_NUM/2
) (
    input clk_in,
    input areset_b,
    input trans_write,
    input trans_read,

    input [DATA_WIDTH-1:0] data_in,

    output [DATA_WIDTH-1:0] data_out,

    output full_ind,
    output empty_ind,
    output overflow_ind,
    output underflow_ind,
    output threshold_ind
);
    parameter int PTR_SIZE = (OSTD_NUM > 1) ? $clog2(OSTD_NUM) : 1;

    reg [OSTD_NUM-1:0] write_ptr, read_ptr;

    wire fifo_wenable, fifo_renable;

    rd_wr_ptr #(
        .OSTD_NUM (OSTD_NUM),
        .PTR_SIZE (PTR_SIZE)
    ) u_write_pointer (
        .clk_in         (clk_in),
        .areset_b       (areset_b),
        .trans_enable   (trans_write),
        .fifo_enable    (fifo_wenable),
        .rd_wr_ptr      (write_ptr),
        .full_empty_ind (full_ind)
    );

    rd_wr_ptr #(
        .OSTD_NUM (OSTD_NUM),
        .PTR_SIZE (PTR_SIZE)
    ) u_read_pointer (
        .clk_in         (clk_in),
        .areset_b       (areset_b),
        .trans_enable   (trans_read),
        .fifo_enable    (fifo_renable),
        .rd_wr_ptr      (read_ptr),
        .full_empty_ind (empty_ind)
    );

    memory_array #(
        .DATA_WIDTH      (DATA_WIDTH),
        .OSTD_NUM        (OSTD_NUM),
        .THRESHOLD_VALUE (THRESHOLD_VALUE),
        .PTR_SIZE        (PTR_SIZE)
    ) u_mem_array (
        .clk_in       (clk_in),
        .areset_b     (areset_b),
        .data_in      (data_in),
        .data_out     (data_out),
        .fifo_wenable (fifo_wenable),
        .fifo_renable (fifo_renable),
        .write_ptr    (write_ptr),
        .read_ptr     (read_ptr)
    );

    monitor_signal #(
        .OSTD_NUM (OSTD_NUM),
        .PTR_SIZE (PTR_SIZE)
    ) u_monitor_signal (
        .clk_in        (clk_in),
        .areset_b      (areset_b),
        .trans_read    (trans_read),
        .trans_write   (trans_write),
        .fifo_renable  (fifo_renable),
        .fifo_wenable  (fifo_wenable),
        .read_ptr      (read_ptr),
        .write_ptr     (write_ptr),
        .full_ind      (full_ind),
        .empty_ind     (empty_ind),
        .overflow_ind  (overflow_ind),
        .underflow_ind (underflow_ind),
        .threshold_ind (threshold_ind)
    );

endmodule
