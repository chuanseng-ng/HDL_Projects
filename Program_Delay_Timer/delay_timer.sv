//! @title Programmable Digital Delay Timer

module delay_timer #(
    parameter int WEIGHT_BIT_WIDTH = 8 //! Defines weighted_bits width
) (
    input clk,        //! Clock source
    input rst_n,      //! Reset source - Active low
    input trigger_in, //! Delay trigger input
    input mode_a,     //! Controls delay_mode bit 0
    input mode_b,     //! Controls delay_mode bit 1

    input [WEIGHT_BIT_WIDTH-1:0] weighted_bits, //! Programs delay based on equation (Refer to spec)

    output reg delay_out_n //! Outputs amount of delay provided
);

    reg [WEIGHT_BIT_WIDTH-1:0] pulse_width; //! Pulse width counter
    reg [WEIGHT_BIT_WIDTH-1:0] delay;       //! Delay counter
    reg [WEIGHT_BIT_WIDTH-1:0] timer;       //! Timer counter

    reg [1:0] delay_mode; //! Delay mode - 00 = One-shot, 01 - Delayed Operate, 10 - Delayed Release, 11 - Dual Delay

    reg trigger_d1;  //! Delay trigger input - Delayed by 1 clock cycle
    reg trigger_d2;  //! Delay trigger input - Delayed by 2 clock cycle
    reg timer_start; //! Start timer indicator
    reg output_en_n; //! Output enable indicator - Active low

    reg reset_timer_d0; //! Reset timer - Delayed by 0 clock cycle
    reg reset_timer_d1; //! Reset timer - Delayed by 1 clock cycle
    reg reset_timer_d2; //! Reset timer - Delayed by 2 clock cycle
    reg reset_d1;       //! Reset input - Delayed by 1 clock cycle
    reg reset_d2;       //! Reset input - Delayed by 2 clock cycle

    wire trigger_rise;   //! Trigger input rise indicator
    wire trigger_fall;   //! Trigger input fall indicator
    wire reset_timer_d3; //! Reset timer - Delayed by 3 clock cycle
    wire reset_d0;       //! Reset input - Delayed by 0 clock cycle
    wire timer_clr_lvl0; //! Timer clear - Level 0
    wire timer_clr_lvl2; //! Timer clear - Level 2
    wire timer_clr_lvl3; //! Timer clear - Level 3

    //! Shift in data and delay for 1 clock cycle
    always @(posedge clk or negedge rst_n) begin: delay_cycle
        if (~rst_n) begin
            trigger_d1     <= 0;
            trigger_d2     <= 0;
            reset_timer_d1 <= 0;
            reset_timer_d2 <= 0;
            reset_d1       <= 0;
            reset_d2       <= 0;
        end else begin
            trigger_d1     <= trigger_in;
            trigger_d2     <= trigger_d1;
            reset_timer_d1 <= reset_timer_d0;
            reset_timer_d2 <= reset_timer_d1;
            reset_d1       <= rst_n;
            reset_d2       <= reset_d1;
        end
    end

    // Identify 0 -> 1 transition on trigger signal
    assign trigger_rise = trigger_d1 & (~trigger_d2);
    assign trigger_fall = trigger_d2 & (~trigger_d1);

    assign reset_timer_d3 = reset_timer_d1 && (~reset_timer_d2);
    assign reset_d0       = reset_d2 & (~reset_d1);

    //! Sample mode & weighted bits
    always @(trigger_rise, trigger_fall, mode_a, mode_b, weighted_bits) begin: trigger_effect
        if (trigger_fall || trigger_rise) begin
            pulse_width = weighted_bits;
            delay       = (2*weighted_bits + 1)/2;
            delay_mode  = {mode_a, mode_b};
        end
    end

    //! Delay modes
    always @(delay_mode, rst_n, trigger_rise, trigger_fall, timer, trigger_in, pulse_width, delay, reset_d0) begin: delay_behav
        case(delay_mode)
            2'b00: //! One-shot mode
                begin
                    if (~rst_n) begin
                        output_en_n        <= 0;
                        timer_start    <= 0;
                        reset_timer_d0 <= 1;
                    end else if (trigger_rise) begin
                        output_en_n        <= 1;
                        timer_start    <= 1;
                        reset_timer_d0 <= 1;
                    end else if (timer >= pulse_width) begin
                        output_en_n        <= 0;
                        timer_start    <= 0;
                        reset_timer_d0 <= 1;
                    end
                end
            2'b01: //! Delayed operation mode
                begin
                    if (~rst_n) begin
                        output_en_n        <= 0;
                        timer_start    <= 0;
                        reset_timer_d0 <= 1;
                    end else if (reset_d0 && trigger_in) begin
                        timer_start    <= 1;
                        reset_timer_d0 <= 0;
                    end else if (trigger_rise) begin
                        timer_start    <= 1;
                        reset_timer_d0 <= 0;
                    end else if (trigger_fall || ~trigger_in) begin
                        output_en_n        <= 0;
                        timer_start    <= 0;
                        reset_timer_d0 <= 1;
                    end else if (timer >= delay) begin
                        output_en_n        <= 1;
                        timer_start    <= 0;
                        reset_timer_d0 <= 1;
                    end
                end
            2'b10: //! Delayed release mode
                begin
                    if (~rst_n) begin
                        output_en_n        <= 0;
                        timer_start    <= 0;
                        reset_timer_d0 <= 1;
                    end else if (trigger_rise || trigger_in) begin
                        output_en_n        <= 1;
                    end else if (trigger_fall) begin
                        timer_start    <= 1;
                        reset_timer_d0 <= 0;
                    end else if (timer >= delay) begin
                        output_en_n        <= 0;
                        timer_start    <= 0;
                        reset_timer_d0 <= 1;
                    end
                end
            2'b11: //! Delayed dual mode
                begin
                    if (~rst_n) begin
                        output_en_n        <= 0;
                        timer_start    <= 0;
                        reset_timer_d0 <= 1;
                    end else if (reset_d0 && trigger_in) begin
                        timer_start    <= 1;
                        reset_timer_d0 <= 0;
                    end else if (trigger_fall || trigger_rise) begin
                        timer_start    <= 1;
                        reset_timer_d0 <= 0;
                    end else if (timer >= delay) begin
                        output_en_n        <= trigger_in;
                        timer_start    <= 0;
                        reset_timer_d0 <= 1;
                    end
                end
            default: //! Default case
                begin
                    output_en_n        <= 0;
                    timer_start    <= 0;
                    reset_timer_d0 <= 1;
                end
        endcase
    end

    //! Timer
    always @(posedge clk or posedge timer_clr_lvl0) begin: timer_behav
        if (timer_clr_lvl0) begin
            timer <= 0;
        end else if (timer_start) begin
            timer <= timer + 1;
        end
    end

    assign timer_clr_lvl0 = reset_timer_d3 || trigger_rise || timer_clr_d3;
    assign timer_clr_lvl2 = trigger_rise || trigger_fall;
    assign timer_clr_lvl3 = timer_clr_d2 && (delay_mode == 2'b11);

    //! Delay output
    always @(posedge clk or negedge rst_n) begin: delayed_output
        if (~rst_n) begin
            delay_out_n <= 0;
        end else begin
            if (output_en_n) begin
                delay_out_n <= 0;
            end else begin
                delay_out_n <= 1;
            end
        end
    end

endmodule
