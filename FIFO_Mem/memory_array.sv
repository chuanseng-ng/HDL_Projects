// Sub-module -- Memory Array Storage
module memory_array #(
    parameter int DATA_WIDTH      = 32,
    parameter int OSTD_NUM        = 8,
    parameter int THRESHOLD_VALUE = OSTD_NUM/2,
    parameter int PTR_SIZE        = (OSTD_NUM > 1) ? $clog2(OSTD_NUM) : 1
) (
    input clk_in,
    input areset_b,
    input fifo_wenable,
    input fifo_renable,

    input [DATA_WIDTH-1:0] data_in,
    input [OSTD_NUM-1:0]   write_ptr,
    input [OSTD_NUM-1:0]   read_ptr,

    output [DATA_WIDTH-1:0] data_out
);
    reg [DATA_WIDTH-1:0] data_reg [OSTD_NUM-1:0];

    always @(posedge clk_in or negedge areset_b) begin
        if (~areset_b) begin
            for (int i = 0; i < OSTD_NUM-1; i++) begin
                data_reg[i] <= {(DATA_WIDTH){1'b0}};
            end
        end else begin
            if (fifo_wenable) begin
                data_reg[write_ptr] <= data_in;
            end
        end
    end

    assign data_out = (fifo_renable) ? data_reg[read_ptr] : 'd0;
endmodule
