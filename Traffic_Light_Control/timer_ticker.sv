module timer_ticker #(
    parameter int TIMER_LIMIT = 10
) (
    input clk,
    input rstb,

    output reg timer_clk
);

    reg [3:0] timer_tick;

    always @(posedge clk or negedge rstb) begin: timer_tick_iter
        if (~rstb) begin
            timer_tick <= 4'b0;
        end else begin
            if (timer_tick == TIMER_LIMIT) begin
                timer_tick <= 4'b0;
            end else begin
                timer_tick <= timer_tick + 1'b1;
            end
        end
    end

    always @(posedge clk or negedge rstb) begin: timer_clk_gen
        if (~rstb) begin
            timer_clk <= 1'b0;
        end else begin
            if (timer_tick == TIMER_LIMIT) begin
                timer_clk <= ~timer_clk;
            end else begin
                timer_clk <= timer_clk;
            end
        end
    end

endmodule
