//! @title Monitor Signal

module monitor_signal #(
    parameter int OSTD_NUM = 8,                                    //! Number of outstanding transactions
    parameter int PTR_SIZE = (OSTD_NUM > 1) ? $clog2(OSTD_NUM) : 1 //! Set pointer size to be 2^N = OSTD_NUM - Unused parameter
) (
    input clk_in,   //! Clock source
    input areset_b, //! Reset source - Active low

    input trans_read,   //! Transaction-side read enable
    input trans_write,  //! Transaction-side write enable
    input fifo_renable, //! FIFO read enable
    input fifo_wenable, //! FIFO write enable

    input [PTR_SIZE-1:0] read_ptr,  //! Read pointer
    input [PTR_SIZE-1:0] write_ptr, //! Write pointer

    output reg full_ind,      //! FIFO full indicator
    output reg empty_ind,     //! FIFO empty indicator
    output reg overflow_ind,  //! FIFO overflow indicator
    output reg underflow_ind, //! FIFO underflow indicator
    output reg threshold_ind  //! FIFO threshold value indicator
);
    wire ptr_msb_compare; //! Read & Write pointer MSB value comparison
    wire overflow_set;    //! Overflow detector
    wire underflow_set;   //! Underflow detector
    wire ptr_equal;       //! Read & Write pointer values equal indicator

    wire [PTR_SIZE-1:0] ptr_result; // Read & Write pointer values difference result

    assign ptr_msb_compare = write_ptr[PTR_SIZE-1] ^ read_ptr[PTR_SIZE-1];
    assign ptr_equal       = (write_ptr[PTR_SIZE-2:0] - read_ptr[PTR_SIZE-2:0]) ? 0 : 1;
    assign ptr_result      = write_ptr[PTR_SIZE-2:0] - read_ptr[PTR_SIZE-2:0];
    assign overflow_set    = full_ind && trans_write;
    assign underflow_set   = empty_ind && trans_read;

    //! Update indicators based on the set conditions
    always_comb begin: indicator_update
        full_ind      = ptr_msb_compare && ptr_equal;
        empty_ind     = (~ptr_msb_compare) && ptr_equal;
        threshold_ind = (ptr_result[PTR_SIZE-1] || ptr_result[PTR_SIZE-2]) ? 1 : 0;
    end

    //! Update underflow_ind if FIFO is empty and nothing is being written in
    always @(posedge clk_in or negedge areset_b) begin: underflow_indicator
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

    //! Update overflow_ind if FIFO is full and data is still being written in
    always @(posedge clk_in or negedge areset_b) begin: overflow_indicator
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
