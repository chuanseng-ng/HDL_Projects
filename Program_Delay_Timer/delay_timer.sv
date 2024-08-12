module delay_timer #(
    parameter int WEIGHT_BIT_WIDTH = 8
) (
    input clk,
    input rst_n,
    input trigger_in,
    input mode_a,
    input mode_b,

    input [WEIGHT_BIT_WIDTH-1:0] weighted_bits,

    output reg delay_out_n
);

    reg [WEIGHT_BIT_WIDTH-1:0] pulse_width, delay;
    reg [WEIGHT_BIT_WIDTH-1:0] timer = 0;

    reg trigger_d1  = 0;
    reg trigger_d2  = 0;
    reg timer_start     = 0;
    reg out_low         = 0;

    reg [1:0] delay_mode;

    reg reset_timer_d0 = 0;
    reg reset_timer_d1 = 0;
    reg reset_timer_d2 = 0;
    reg reset_d1       = 0;
    reg reset_d2       = 0;

    wire trigger_rise, trigger_fall;
    wire reset_timer_d3, reset_d0;
    wire timer_clr_d0, timer_clr_2, timer_clr_d3;

    always @(posedge clk or negedge rst_n) begin
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

    // Sample mode & weighted bits
    always @(trigger_rise, trigger_fall, mode_a, mode_b, weighted_bits) begin
        if (trigger_fall || trigger_rise) begin
            pulse_width = weighted_bits;
            delay       = (2*weighted_bits + 1)/2;
            delay_mode  = {mode_a, mode_b};
        end
    end

    // Delay modes
    always @(delay_mode, rst_n, trigger_rise, trigger_fall, timer, trigger_in, pulse_width, delay, reset_d0) begin
        case(delay_mode)
            2'b00: // One-shot mode
                begin
                    if (~rst_n) begin
                        out_low        <= 0;
                        timer_start    <= 0;
                        reset_timer_d0 <= 0;
                    end else if (trigger_rise) begin
                        out_low        <= 1;
                        timer_start    <= 1;
                        reset_timer_d0 <= 1;
                    end else if (timer >= pulse_width) begin
                        out_low        <= 0;
                        timer_start    <= 0;
                        reset_timer_d0 <= 1;
                    end
                end
            2'b01: // Delayed operation mode
                begin
                    if (~rst_n) begin
                        out_low        <= 0;
                        timer_start    <= 0;
                        reset_timer_d0 <= 1;
                    end else if (reset_d0 && trigger_in) begin
                        timer_start    <= 1;
                        reset_timer_d0 <= 0;
                    end else if (trigger_rise) begin
                        timer_start    <= 1;
                        reset_timer_d0 <= 1;
                    end else if (trigger_fall || ~trigger_in) begin
                        out_low        <= 0;
                        timer_start    <= 0;
                        reset_timer_d0 <= 1;
                    end else if (timer >= delay) begin
                        out_low        <= 1;
                        timer_start    <= 0;
                        reset_timer_d0 <= 1;
                    end
                end
            2'b10: // Delayed release mode
                begin
                    if (~rst_n) begin
                        out_low        <= 0;
                        timer_start    <= 0;
                        reset_timer_d0 <= 1;
                    end else if (trigger_rise || trigger_in) begin
                        out_low        <= 1;
                    end else if (trigger_fall) begin
                        timer_start    <= 1;
                        reset_timer_d0 <= 0;
                    end else if (timer >= delay) begin
                        out_low        <= 0;
                        timer_start    <= 0;
                        reset_timer_d0 <= 1;
                    end
                end
            2'b11: // Delayed dual mode
                begin
                    if (~rst_n) begin
                        out_low        <= 0;
                        timer_start    <= 0;
                        reset_timer_d0 <= 1;
                    end else if (reset_d0 && trigger_in) begin
                        timer_start    <= 1;
                        reset_timer_d0 <= 0;
                    end else if (trigger_fall || trigger_rise) begin
                        timer_start    <= 1;
                        reset_timer_d0 <= 0;
                    end else if (timer >= delay) begin
                        out_low        <= trigger_in;
                        timer_start    <= 0;
                        reset_timer_d0 <= 1;
                    end
                end
            default: // Default case
                begin
                    out_low        <= 0;
                    timer_start    <= 0;
                    reset_timer_d0 <= 1;
                end
        endcase
    end

    // Timer
    always @(posedge clk or posedge timer_clr_d0) begin
        if (timer_clr_d0) begin
            timer <= 0;
        end else if (timer_start) begin
            timer <= timer + 1;
        end
    end

    assign timer_clr_d0 = reset_timer_d3 || trigger_rise || timer_clr_d3;
    assign timer_clr_d2 = trigger_rise || trigger_fall;
    assign timer_clr_d3 = timer_clr_d2 && (delay_mode == 2'b11);

    // Delay output
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            delay_out_n <= 0;
        end else begin
            if (out_low) begin
                delay_out_n <= 0;
            end else begin
                delay_out_n <= 1;
            end
        end
    end

endmodule
