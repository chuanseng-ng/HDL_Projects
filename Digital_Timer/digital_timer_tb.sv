`timescale 10ps/10ps

`define DELAY 10

module digital_timer_tb#()();

    parameter int ENDTIME    = 200000;
    parameter int TIMER_LIMIT = 4;

    reg clk;
    reg rst_b;

    reg timer_clear;
    reg timer_pause;
    reg timer_reset;

    reg [5:0] [6:0] digital_clock;

    digital_timer #(
        .TIMER_LIMIT (TIMER_LIMIT)
    ) u_dut (
        .sys_clk           (clk),
        .rst_b             (rst_b),
        .timer_clear       (timer_clear),
        .timer_pause       (timer_pause),
        .timer_reset       (timer_reset),
        .digital_clock_out (digital_clock)
    );

    initial begin
        $display("Digital Timer TB");

        $dumpfile("digital_timer.vcd");
        $dumpvars();

        clk         = 1'b0;
        rst_b       = 1'b0;
        timer_clear = 1'b0;
        timer_pause = 1'b0;
        timer_reset = 1'b0;
    end

    initial begin
        main;
    end

    task static main;
        fork
            clock_gen;
            reset_gen;
            operation_process;
            endsimulation;
        join
    endtask

    task static clock_gen;
        begin
            forever #`DELAY clk = ~clk;
        end
    endtask

    task static reset_gen;
        begin
            #(`DELAY*2)
            rst_b = 1'b1;
            # 20
            rst_b = 1'b0;
            # 25
            rst_b = 1'b1;
        end
    endtask

    task static operation_process;
        begin
            // Set timer_pause and release to test timer pause function
            #(`DELAY*25)
            timer_pause = 1'b1;
            #(`DELAY*10)
            timer_pause = 1'b0;

            // Set timer_clear and release to test timer clear function
            #(`DELAY*38)
            timer_clear = 1'b1;
            #(`DELAY*5)
            timer_clear = 1'b0;

            // Set timer_reset and release to test timer reset function
            #(`DELAY*50)
            timer_reset = 1'b1;
            #(`DELAY*6)
            timer_reset = 1'b0;

            //forever #`DELAY $display("%d", digital_clock);
        end
    endtask

    task static endsimulation;
        begin
            #ENDTIME
            $display("---------------- THE SIMULATION HAS FINISHED -----------------");
            $finish;
        end
    endtask

endmodule
