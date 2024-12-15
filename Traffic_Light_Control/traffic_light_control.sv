module traffic_light_control #(
    parameter int SIMPLE_DESIGN = 0,
    parameter int TIMER_LIMIT   = 10
) (
    input clk,
    input rstb
);

    reg timer_clk;
    reg output_x, output_y, output_z;

    traffic_light_fsm #(
        .TIMER_LIMIT (TIMER_LIMIT)
    ) u_fsm (
        .timer_clk (timer_clk),
        .rstb      (rstb),
        .output_x  (output_x),
        .output_y  (output_y),
        .output_z  (output_z)
    );

    timer_ticker #(
        .TIMER_LIMIT (TIMER_LIMIT)
    ) u_timer_ticker (
        .clk       (clk),
        .rstb      (rstb),
        .timer_clk (timer_clk)
    );

endmodule
