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


//! @title FIFO Memory

module fifo_mem #(
    parameter int DATA_WIDTH      = 32,        //! Transaction data width
    parameter int OSTD_NUM        = 4,         //! Number of outstanding transactions
    parameter int THRESHOLD_VALUE = OSTD_NUM/2 //! Minimum numbr of expected values in FIFO
) (
    input clk_in,      //! Clock source
    input areset_b,    //! Reset source - Active low
    input trans_read,  //! Transaction read request
    input trans_write, //! Transaction write request

    input [DATA_WIDTH-1:0] data_in, //! Transaction data input

    output [DATA_WIDTH-1:0] data_out, //! Transaction data output

    output full_ind,      //! FIFO full indicator
    output empty_ind,     //! FIFO empty indicator
    output overflow_ind,  //! FIFO overflow indicator
    output underflow_ind, //! FIFO underflow indicator
    output threshold_ind  //! FIFO threshold indicator
);
    parameter int PTR_SIZE = (OSTD_NUM > 1) ? $clog2(OSTD_NUM) : 1; //! Set pointer size to be 2^N = OSTD_NUM - Unused parameter

    reg [OSTD_NUM-1:0] read_ptr;  //! Read pointer
    reg [OSTD_NUM-1:0] write_ptr; //! Write pointer

    wire fifo_renable; //! FIFO write enable
    wire fifo_wenable; //! FIFO read enable

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
