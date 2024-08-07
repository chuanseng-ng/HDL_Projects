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
    .DATA_WIDTH      (32),
    .OSTD_NUM        (4),
    .THRESHOLD_VALUE (OSTD_NUM/2)
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
    parameter PTR_SIZE = (OSTD_NUM > 1) ? $clog2(OSTD_NUM) : 1;

    reg [PTR_SIZE-1:0] write_ptr, read_ptr;
    
    wire fifo_wenable, fifo_renable;

    read_write_pointer #(
        .PTR_SIZE        (PTR_SIZE)
    ) u_write_pointer (
        .clk_in         (clk_in),
        .areset_b       (areset_b),
        .trans_enable   (trans_write),
        .fifo_enable    (fifo_wenable),
        .rd_wr_ptr      (write_ptr),
        .full_empty_ind (full_ind)
    );

    read_write_pointer #(
        .PTR_SIZE        (PTR_SIZE)
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

endmodule

// Sub-module -- Memory Array Storage
module memory_array #(
    .DATA_WIDTH      (32),
    .OSTD_NUM        (4),
    .THRESHOLD_VALUE (OSTD_NUM/2),
    .PTR_SIZE        ((OSTD_NUM > 1) ? $clog2(OSTD_NUM) : 1)
) (
    input clk_in,
    input areset_b,
    input fifo_wenable,
    input fifo_renable,

    input [DATA_WIDTH-1:0] data_in,
    input [PTR_SIZE-1:0]   write_ptr,
    input [PTR_SIZE-1:0]   read_ptr,

    output [DATA_WIDTH-1:0] data_out
);
    reg [DATA_WIDTH-1:0] [OSTD_NUM-1:0] data_reg;

    always @(posedge clk_in or negedge areset_b) begin
        if (~areset_b) begin
            data_reg <= {(DATA_WIDTH*OSTD_NUM){1'b0}};
        end else begin
            if (fifo_wenable) begin
                data_reg[write_ptr] <= data_in;
            end
        end
    end

    assign data_out = (fifo_renable) ? data_reg[read_ptr] : 'd0;
endmodule

// Sub-module -- Read/Write Pointer Update
module read_write_pointer #(
    .PTR_SIZE (2)
) (
    input clk_in,
    input areset_b,
    input full_empty_ind,
    input trans_enable,
    
    output fifo_enable,

    output [PTR_SIZE-1:0 ] rd_wr_ptr,
);
    assign fifo_enable = (~full_empty_ind) && trans_enable;

    always @(posedge clk_in or negedge areset_b) begin
        if (~areset_b) begin
            rd_wr_ptr <= {(PTR_SIZE){1'b0}};
        end else begin
            if (fifo_enable) begin
                rd_wr_ptr <= rd_wr_ptr + 1'b1;
            end else begin
                rd_wr_ptr <= rd_wr_ptr;
            end
        end
    end
endmodule

// Sub-module -- Monitoring Signal
module monitor_signal #(
    .PTR_SIZE (2)
) (
    input clk_in,
    input areset_b,

    input trans_read,
    input trans_write,
    input fifo_renable,
    input fifo_wenable,

    input [PTR_SIZE-1:0] read_ptr,
    input [PTR_SIZE-1:0] write_ptr,

    output full_ind,
    output empty_ind,
    output overflow_ind,
    output underflow_ind,
    output threshold_ind
);
    wire ptr_msb_compare;
    wire overflow_set, underflow_set;
    wire ptr_equal;

    wire [PTR_SIZE-1:0] ptr_result;
    
    assign ptr_msb_compare = write_ptr[PTR_SIZE-1] ^ read_ptr[PTR_SIZE-1];
    assign ptr_equal       = (write_ptr[PTR_SIZE-2:0] - read_ptr[PTR_SIZE-2:0]) ? 0 : 1;
    assign ptr_result      = write_ptr[PTR_SIZE-2:0] - read_ptr[PTR_SIZE-2:0];
    assign overflow_set    = full_ind && trans_write;
    assign underflow_set   = empty_ind && trans_read;

    always_comb begin
        full_ind      = ptr_msb_compare && ptr_equal;
        empty_ind     = (~ptr_msb_compare) && ptr_equal;
        threshold_ind = (ptr_result[OSTD_NUM-1]||ptr_result[OSTD_NUM-2]) ? 1 : 0;
    end

    always @(posedge clk_in or negedge areset_b) begin
        if (~areset_b) begin
            underflow_ind <= 1'b0;
        end else begin
            if ((underflow_set==1) && (fifo_wenable==0)) begin
                underflow_ind <= 1'b1;
            end else if (fifo_wenable) begin
                underflow_ind <= 1'b0;
            end else begin
                underflow_ind <= underflow_ind;
            end
        end
    end

    always @(posedge clk_in or negedge areset_b) begin
        if (~areset_b) begin
            overflow_ind <= 1'b0;
        end else begin
            if ((overflow_set==1) && (fifo_renable==0)) begin
                overflow_ind <= 1'b1;
            end else if (fifo_renable) begin
                overflow_ind <= 1'b0;
            end else begin
                overflow_ind <= overflow_ind;
            end
        end
    end
endmodule