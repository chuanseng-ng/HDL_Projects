module digit_iter #(
    parameter int HR_DIGIT     = 0,
    parameter int MIN_DIGIT    = 0,
    parameter int SEC_DIGIT    = 0,
    parameter int FIRST_DIGIT  = 0,
    parameter int SECOND_DIGIT = 0
) (
    input timer_clk,
    input int_reset_b,

    input [3:0] timer_clk_count,

    input prev_overflow_ind,

    input [6:0] clock_digit_in,

    output reg [6:0] clock_digit_out,

    output reg overflow_ind
);

    always @(posedge timer_clk or negedge int_reset_b) begin
        if (~int_reset_b) begin
            overflow_ind <= 0;
        end else begin
            if (SEC_DIGIT || MIN_DIGIT) begin
                if (FIRST_DIGIT && timer_clk_count == 'd9) begin
                    overflow_ind <= 1;
                end else if (SECOND_DIGIT && timer_clk_count == 'd5) begin
                    overflow_ind <= 1;
                end else begin
                    overflow_ind <= 0;
                end
            end else if (HR_DIGIT) begin
                if (FIRST_DIGIT && timer_clk_count == 'd9) begin
                    overflow_ind <= 1;
                end else if (SECOND_DIGIT && timer_clk_count == 'd2) begin
                    overflow_ind <= 1;
                end else begin
                    overflow_ind <= 0;
                end
            end else begin
                overflow_ind <= 0;
            end
        end
    end

    always @(posedge timer_clk or negedge int_reset_b) begin
        if (~int_reset_b) begin
            clock_digit_out <= 7'b0000001; // 0
        end else begin
            if (timer_clk_count == 'd9 && prev_overflow_ind) begin
                case(clock_digit_in)
                    7'b0000001: clock_digit_out <= 7'b1001111; // 0 -> 1
                    7'b1001111: clock_digit_out <= 7'b0010010; // 1 -> 2
                    7'b0010010: clock_digit_out <= 7'b0000110; // 2 -> 3
                    7'b0000110: clock_digit_out <= 7'b1011100; // 3 -> 4
                    7'b1011100: clock_digit_out <= 7'b0110100; // 4 -> 5
                    7'b0110100: clock_digit_out <= 7'b0110000; // 5 -> 6
                    7'b0110000: clock_digit_out <= 7'b0001111; // 6 -> 7
                    7'b0001111: clock_digit_out <= 7'b0010000; // 7 -> 8
                    7'b0010000: clock_digit_out <= 7'b0010100; // 8 -> 9
                    7'b0010100: clock_digit_out <= 7'b0000001; // 9 -> 0
                    default: clock_digit_out <= 7'b0000001; // 0
                endcase
            end
        end
    end

endmodule
