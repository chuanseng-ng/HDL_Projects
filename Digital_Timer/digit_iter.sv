module digit_iter #(
    parameter int HR_DIGIT     = 0,
    parameter int MIN_DIGIT    = 0,
    parameter int SEC_DIGIT    = 0,
    parameter int FIRST_DIGIT  = 0,
    parameter int SECOND_DIGIT = 0
) (
    input timer_clk,
    input int_reset_b,

    input hr_digit_cap_in,            //! Input to indicate Hour 2nd digit == 2, used by Hour 1st digit

    input [4:0] prev_overflow_ind,

    input [6:0] clock_digit_in,

    output reg hr_digit_cap_out,      //! Output to indicate Hour 2nd digit == 2, used by Hour 1st digit

    output reg [6:0] clock_digit_out,

    output reg overflow_ind
);

    parameter int HR_FIRST_DIGIT   = HR_DIGIT && FIRST_DIGIT;
    parameter int HR_SECOND_DIGIT  = HR_DIGIT && SECOND_DIGIT;
    parameter int MIN_FIRST_DIGIT  = MIN_DIGIT && FIRST_DIGIT;
    parameter int MIN_SECOND_DIGIT = MIN_DIGIT && SECOND_DIGIT;
    parameter int SEC_FIRST_DIGIT  = SEC_DIGIT && FIRST_DIGIT;
    parameter int SEC_SECOND_DIGIT = SEC_DIGIT && SECOND_DIGIT;

    wire prev_overflow_ind_merge      = & prev_overflow_ind;

    always @(posedge timer_clk or negedge int_reset_b) begin: overflow_ind_block
        if (~int_reset_b) begin
            overflow_ind <= 0;
        end else begin
            if (SEC_DIGIT || MIN_DIGIT) begin: sec_min_digit_block
                if (FIRST_DIGIT && clock_digit_in == 7'b0010100) begin
                    overflow_ind <= 1;
                end else if (SECOND_DIGIT && clock_digit_in == 7'b0110100) begin
                    overflow_ind <= 1;
                end else begin
                    overflow_ind <= 0;
                end
            end else if (HR_DIGIT) begin: hr_digit_block
                if (FIRST_DIGIT && clock_digit_in == 7'b0010100) begin
                    overflow_ind <= 1;
                end else if (SECOND_DIGIT && clock_digit_in == 7'b0010010) begin
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
            if (prev_overflow_ind_merge) begin
                if (SEC_FIRST_DIGIT || MIN_FIRST_DIGIT) begin
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
                end else if (SEC_SECOND_DIGIT || MIN_SECOND_DIGIT) begin
                    case(clock_digit_in)
                        7'b0000001: clock_digit_out <= 7'b1001111; // 0 -> 1
                        7'b1001111: clock_digit_out <= 7'b0010010; // 1 -> 2
                        7'b0010010: clock_digit_out <= 7'b0000110; // 2 -> 3
                        7'b0000110: clock_digit_out <= 7'b1011100; // 3 -> 4
                        7'b1011100: clock_digit_out <= 7'b0110100; // 4 -> 5
                        7'b0110100: clock_digit_out <= 7'b0000001; // 5 -> 0
                        default: clock_digit_out <= 7'b0000001; // 0
                    endcase
                end else if (HR_FIRST_DIGIT) begin
                    if (hr_digit_cap_out) begin
                        case(clock_digit_in)
                            7'b0000001: clock_digit_out <= 7'b1001111; // 0 -> 1
                            7'b1001111: clock_digit_out <= 7'b0010010; // 1 -> 2
                            7'b0010010: clock_digit_out <= 7'b0000110; // 2 -> 3
                            7'b0000110: clock_digit_out <= 7'b0000001; // 3 -> 0
                            default: clock_digit_out <= 7'b0000001; // 0
                        endcase
                    end else begin
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
                end else if (HR_SECOND_DIGIT) begin
                    case(clock_digit_in)
                        7'b0000001: clock_digit_out <= 7'b1001111; // 0 -> 1
                        7'b1001111: clock_digit_out <= 7'b0010010; // 1 -> 2
                        7'b0010010: clock_digit_out <= 7'b0000001; // 2 -> 0
                        default: clock_digit_out <= 7'b0000001; // 0
                    endcase
                end
            end
        end
    end

    always @(posedge timer_clk or negedge int_reset_b) begin
        if (~int_reset_b) begin
            hr_digit_cap_out <= 1'b0;
        end else begin
            if (HR_SECOND_DIGIT && clock_digit_out == 7'b0010010) begin
                hr_digit_cap_out <= 1'b1;
            end else begin
                hr_digit_cap_out <= 1'b0;
            end
        end
    end

endmodule
