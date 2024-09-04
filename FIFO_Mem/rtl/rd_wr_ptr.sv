// Sub-module -- Read/Write Pointer Update
module rd_wr_ptr #(
    parameter int OSTD_NUM = 8,
    parameter int PTR_SIZE = 3
) (
    input clk_in,
    input areset_b,
    input full_empty_ind,
    input trans_enable,

    output fifo_enable,

    output reg [OSTD_NUM-1:0] rd_wr_ptr
);
    assign fifo_enable = (~full_empty_ind) && trans_enable;

    always @(posedge clk_in or negedge areset_b) begin
        if (~areset_b) begin
            rd_wr_ptr <= {(OSTD_NUM){1'b0}};
        end else begin
            if (fifo_enable) begin
                rd_wr_ptr <= rd_wr_ptr + 1;
            end else begin
                rd_wr_ptr <= rd_wr_ptr;
            end
        end
    end
endmodule
