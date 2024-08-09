// Sub-module -- Monitoring Signal
module monitor_signal #(
    parameter int OSTD_NUM = 8,
    parameter int PTR_SIZE = (OSTD_NUM > 1) ? $clog2(OSTD_NUM) : 1
) (
    input clk_in,
    input areset_b,

    input trans_read,
    input trans_write,
    input fifo_renable,
    input fifo_wenable,

    input [OSTD_NUM-1:0] read_ptr,
    input [OSTD_NUM-1:0] write_ptr,

    output reg full_ind,
    output reg empty_ind,
    output reg overflow_ind,
    output reg underflow_ind,
    output reg threshold_ind
);
    wire ptr_msb_compare;
    wire overflow_set, underflow_set;
    wire ptr_equal;

    wire [OSTD_NUM-1:0] ptr_result;

    assign ptr_msb_compare = write_ptr[OSTD_NUM-1] ^ read_ptr[OSTD_NUM-1];
    assign ptr_equal       = (write_ptr[OSTD_NUM-2:0] - read_ptr[OSTD_NUM-2:0]) ? 0 : 1;
    assign ptr_result      = write_ptr[OSTD_NUM-2:0] - read_ptr[OSTD_NUM-2:0];
    assign overflow_set    = full_ind && trans_write;
    assign underflow_set   = empty_ind && trans_read;

    always_comb begin
        full_ind      = ptr_msb_compare && ptr_equal;
        empty_ind     = (~ptr_msb_compare) && ptr_equal;
        threshold_ind = (ptr_result[OSTD_NUM-1] || ptr_result[OSTD_NUM-2]) ? 1 : 0;
    end

    always @(posedge clk_in or negedge areset_b) begin
        if (~areset_b) begin
            underflow_ind <= 1'b0;
        end else begin
            if ((underflow_set == 1) && (fifo_wenable == 0)) begin
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
            if ((overflow_set == 1) && (fifo_renable == 0)) begin
                overflow_ind <= 1'b1;
            end else if (fifo_renable) begin
                overflow_ind <= 1'b0;
            end else begin
                overflow_ind <= overflow_ind;
            end
        end
    end
endmodule
