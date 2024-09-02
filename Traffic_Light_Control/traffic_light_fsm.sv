module traffic_light_fsm #() (
    input clk,
    input rstb,

    input input_a,
    input input_b,

    output reg output_x, //! Red color
    output reg output_y, //! Yellow color
    output reg output_z  //! Green color
);

    always @(posedge clk or negedge rstb) begin: light_fsm
        if (~rstb) begin
            output_x <= 1'b0;
            output_y <= 1'b0;
            output_z <= 1'b0;
        end else begin
            case({input_a,input_b})
                00: begin
                    output_x <= 1;
                    output_y <= 0;
                    output_z <= 0;
                end
                01: begin
                    output_x <= 1;
                    output_y <= 1;
                    output_z <= 0;
                end
                10: begin
                    output_x <= 0;
                    output_y <= 0;
                    output_z <= 1;
                end
                11: begin
                    output_x <= 0;
                    output_y <= 1;
                    output_z <= 0;
                end
                default: begin
                    output_x <= 1;
                    output_y <= 0;
                    output_z <= 0;
                end
            endcase
        end
    end

endmodule
