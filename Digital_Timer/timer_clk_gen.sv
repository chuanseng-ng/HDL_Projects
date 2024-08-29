// Clock divider by 10
module timer_clk_gen #(
    parameter int TIMER_LIMIT = 10
) (
    input sys_clk,
    input int_reset_b,

    input timer_clear,
    input timer_pause,

    input [3:0] timer_clk_count,

    output reg timer_clk
);

    always @(posedge sys_clk or negedge int_reset_b) begin: timer_clk_gen
        if (~int_reset_b) begin
            timer_clk <= 1'b0;
        end else begin
            if (timer_clear) begin
                timer_clk <= 1'b0;
            end else if (timer_pause) begin
                timer_clk <= timer_clk;
            end else if (timer_clk_count == TIMER_LIMIT-1) begin
                timer_clk <= ~timer_clk;
            end else begin
                timer_clk <= timer_clk;
            end
        end
    end

endmodule
