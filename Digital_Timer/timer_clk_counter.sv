// Count system clock tick from 0-9
module timer_clk_counter #(
    parameter int TIMER_LIMIT = 10
) (
    input sys_clk,
    input int_reset_b,

    input timer_pause,
    input timer_clear,

    output reg [3:0] timer_clk_count
);

    always @(posedge sys_clk or negedge int_reset_b) begin: timer_clk_count_iter
        if (~int_reset_b) begin
            timer_clk_count <= 4'b0;
        end else begin
            if (timer_pause) begin
                timer_clk_count <= timer_clk_count;
            end else if (timer_clear) begin
                timer_clk_count <= 4'b0;
            end else if (timer_clk_count == TIMER_LIMIT-1) begin
                timer_clk_count <= 4'd0;
            end else begin
                timer_clk_count <= timer_clk_count + 1'b1;
            end
        end
    end

endmodule
