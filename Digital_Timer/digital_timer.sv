// Main module
module digital_timer #() (
    input sys_clk,
    input rst_b,

    input timer_clear,
    input timer_pause,
    input timer_reset,

    output reg [5:0] [6:0] digital_clock_out
);

    reg digital_sec_2nd_ind;
    reg digital_min_2nd_ind;
    reg digital_hr_2nd_ind;

    reg digital_min_1st_ind;
    reg digital_hr_1st_ind;

    reg timer_clk;

    reg [3:0] timer_clk_count;

    reg [5:0] [6:0] digital_clock_in;

    reg [1:0] hour_digit_overflow;
    reg [1:0] min_digit_overflow;
    reg [1:0] sec_digit_overflow;

    wire int_reset_b = ~timer_reset && rst_b;

    // System clock tick count
    timer_clk_counter #() u_timer_clk_counter (
        .sys_clk         (sys_clk),
        .int_reset_b     (int_reset_b),
        .timer_pause     (timer_pause),
        .timer_clear     (timer_clear),
        .timer_clk_count (timer_clk_count)
    );

    // Divide system clock by 10 to produce timer clock
    timer_clk_gen #() u_timer_clk_gen (
        .sys_clk         (sys_clk),
        .int_reset_b     (int_reset_b),
        .timer_clk_count (timer_clk_count),
        .timer_clk       (timer_clk)
    );

    always @(posedge sys_clk or negedge int_reset_b) begin
        if (~int_reset_b) begin
            digital_clock_in <= {(6){7'b0000001}}; // Reset to 0
        end else begin
            digital_clock_in <= digital_clock_out;
        end
    end

    generate
        genvar iter;
        for (iter = 0; iter < 6; iter++) begin: gen_digital_display_iter
            case(iter)
                0: digit_iter #(
                        .HR_DIGIT     (0),
                        .MIN_DIGIT    (0),
                        .SEC_DIGIT    (1),
                        .FIRST_DIGIT  (1),
                        .SECOND_DIGIT (0)
                ) u_sec_first_digit_iter (
                        .timer_clk         (timer_clk),
                        .int_reset_b       (int_reset_b),
                        .clock_digit_in    (digital_clock_in[iter]),
                        .clock_digit_out   (digital_clock_out[iter]),
                        .prev_overflow_ind (1'b1),
                        .overflow_ind      (sec_digit_overflow[0])
                    );
                1: digit_iter #(
                        .HR_DIGIT     (0),
                        .MIN_DIGIT    (0),
                        .SEC_DIGIT    (1),
                        .FIRST_DIGIT  (0),
                        .SECOND_DIGIT (1)
                ) u_sec_second_digit_iter (
                        .timer_clk         (timer_clk),
                        .int_reset_b       (int_reset_b),
                        .clock_digit_in    (digital_clock_in[iter]),
                        .clock_digit_out   (digital_clock_out[iter]),
                        .prev_overflow_ind (sec_digit_overflow[0]),
                        .overflow_ind      (sec_digit_overflow[1])
                    );
                2: digit_iter #(
                        .HR_DIGIT     (0),
                        .MIN_DIGIT    (1),
                        .SEC_DIGIT    (0),
                        .FIRST_DIGIT  (1),
                        .SECOND_DIGIT (0)
                ) u_min_first_digit_iter (
                        .timer_clk         (timer_clk),
                        .int_reset_b       (int_reset_b),
                        .clock_digit_in    (digital_clock_in[iter]),
                        .clock_digit_out   (digital_clock_out[iter]),
                        .prev_overflow_ind (sec_digit_overflow[1]),
                        .overflow_ind      (min_digit_overflow[0])
                    );
                3: digit_iter #(
                        .HR_DIGIT     (0),
                        .MIN_DIGIT    (1),
                        .SEC_DIGIT    (0),
                        .FIRST_DIGIT  (0),
                        .SECOND_DIGIT (1)
                ) u_min_second_digit_iter (
                        .timer_clk         (timer_clk),
                        .int_reset_b       (int_reset_b),
                        .clock_digit_in    (digital_clock_in[iter]),
                        .clock_digit_out   (digital_clock_out[iter]),
                        .prev_overflow_ind (min_digit_overflow[0]),
                        .overflow_ind      (min_digit_overflow[1])
                    );
                4: digit_iter #(
                        .HR_DIGIT     (1),
                        .MIN_DIGIT    (0),
                        .SEC_DIGIT    (0),
                        .FIRST_DIGIT  (1),
                        .SECOND_DIGIT (0)
                ) u_hr_first_digit_iter (
                        .timer_clk         (timer_clk),
                        .int_reset_b       (int_reset_b),
                        .clock_digit_in    (digital_clock_in[iter]),
                        .clock_digit_out   (digital_clock_out[iter]),
                        .prev_overflow_ind (min_digit_overflow[1]),
                        .overflow_ind      (hour_digit_overflow[0])
                    );
                5: digit_iter #(
                        .HR_DIGIT     (1),
                        .MIN_DIGIT    (0),
                        .SEC_DIGIT    (0),
                        .FIRST_DIGIT  (0),
                        .SECOND_DIGIT (1)
                ) u_hr_second_digit_iter (
                        .timer_clk         (timer_clk),
                        .int_reset_b       (int_reset_b),
                        .clock_digit_in    (digital_clock_in[iter]),
                        .clock_digit_out   (digital_clock_out[iter]),
                        .prev_overflow_ind (hour_digit_overflow[0]),
                        .overflow_ind      (hour_digit_overflow[1])
                    );
            endcase
        end
    endgenerate

endmodule
