module traffic_light_control #(
    parameter int SIMPLE_DESIGN = 0
) (
    input clk,
    input rstb
);

    reg input_a, input_b;
    reg output_x, output_y, output_z;

    traffic_light_fsm #() u_fsm (
        .clk      (clk),
        .rstb     (rstb),
        .input_a  (input_a),
        .input_b  (input_b),
        .output_x (output_x),
        .output_y (output_y),
        .output_z (output_z)
    );

endmodule
