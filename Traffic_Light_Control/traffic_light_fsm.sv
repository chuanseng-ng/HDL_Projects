module traffic_light_fsm #(
    parameter int TIMER_LIMIT = 10
) (
    input timer_clk,
    input rstb,

    output reg output_x, //! Red color
    output reg output_y, //! Yellow color
    output reg output_z  //! Green color
);

    // reg input_a, input_b;
    reg [1:0] next_input_state;
    reg [1:0] input_state;

    always_comb begin: fsm_logic
        case(input_state)
            2'b00: next_input_state = 2'b01;
            2'b01: next_input_state = 2'b10;
            2'b10: next_input_state = 2'b11;
            2'b11: next_input_state = 2'b00;
            default: next_input_state = 2'b00;
        endcase
    end

    always @(posedge timer_clk or negedge rstb) begin: input_control
        if (~rstb) begin
            input_state <= 2'b0;
        end else begin
            input_state <= next_input_state;
        end
    end

    always @(posedge timer_clk or negedge rstb) begin: light_fsm
        if (~rstb) begin
            output_x <= 1'b0;
            output_y <= 1'b0;
            output_z <= 1'b0;
        end else begin
            case(input_state)
                2'b00: begin
                    output_x <= 1'b1;
                    output_y <= 1'b0;
                    output_z <= 1'b0;
                end
                2'b01: begin
                    output_x <= 1'b1;
                    output_y <= 1'b1;
                    output_z <= 1'b0;
                end
                2'b10: begin
                    output_x <= 1'b0;
                    output_y <= 1'b0;
                    output_z <= 1'b1;
                end
                2'b11: begin
                    output_x <= 1'b0;
                    output_y <= 1'b1;
                    output_z <= 1'b0;
                end
                default: begin
                    output_x <= 1'b1;
                    output_y <= 1'b0;
                    output_z <= 1'b0;
                end
            endcase
        end
    end

endmodule
