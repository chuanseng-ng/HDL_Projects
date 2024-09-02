module traffic_light_fsm #(
    parameter int TIMER_LIMT = 10
) (
    input clk,
    input rstb,

    input input_a,
    input input_b,

    output reg output_x, //! Red color
    output reg output_y, //! Yellow color
    output reg output_z  //! Green color
);

    reg [3:0] timer_tick;

    reg timer_clk;

    always @(posedge clk or negedge rstb) begin: timer_tick_iter
        if (~rstb) begin
            timer_tick <= 4'b0;
        end else begin
            timer_tick <= timer_tick + 1'b1;
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

    always @(posedge timer_clk or negedge rstb) begin: light_fsm
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
