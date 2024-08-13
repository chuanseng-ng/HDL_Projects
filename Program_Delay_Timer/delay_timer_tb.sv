//! @title Programmable Digital Delay Timer Testbench

`timescale 1ns/1ps

module delay_timer_tb #() ();

    parameter int WEIGHT_BIT_WIDTH = 8;      //! Defines weighted_bits width
    parameter int ENDTIME          = 500000; //! Simulation duration - In ns

    reg clk;        //! Clock source
    reg rst_n;      //! Reset source - Active low
    reg trigger_in; //! Delay trigger input
    reg mode_a;     //! Controls delay_mode bit 0
    reg mode_b;     //! Controls delay_mode bit 1

    reg [WEIGHT_BIT_WIDTH-1:0] weighted_bits; //! Programs delay based on equation (Refer to spec)

    wire delay_out_n; //! Amount of delay provided by delay_timer

    delay_timer #(
        .WEIGHT_BIT_WIDTH (WEIGHT_BIT_WIDTH)
    ) u_delay_timer (
        .clk           (clk),
        .rst_n         (rst_n),
        .trigger_in    (trigger_in),
        .mode_a        (mode_a),
        .mode_b        (mode_b),
        .weighted_bits (weighted_bits),
        .delay_out_n   (delay_out_n)
    );

    initial begin
        $display("Programmable Digital Delay Timer TB");

        $dumpfile("delay_timer.vcd");
        $dumpvars();
        main;
    end

    task automatic main;
        fork
            clock_gen;
            trigger_rst_gen;
            endsimulation;
        join
    endtask

    task static trigger_rst_gen;
        begin
            //! Initialize inputs
            rst_n         = 0;

            //! One-shot mode
            #1000;
            weighted_bits = 10;
            mode_a        = 0;
            mode_b        = 0;
            rst_n         = 1;
            trigger_in    = 0;

            #500;
            trigger_in    = 1;

            #15000;
            trigger_in    = 0;

            #15000;
            trigger_in    = 1;

            #2000;
            trigger_in    = 0;

            #2000;
            trigger_in    = 1;

            #2000;
            trigger_in    = 0;

            #20000;
            trigger_in    = 1;

            #30000;
            trigger_in    = 0;

            #2000;
            trigger_in    = 1;

            #2000;
            trigger_in    = 0;

            #4000;
            trigger_in    = 1;

            #10000;
            rst_n         = 0;

            //! Delay Operate mode
            #10000;
            rst_n         = 1;
            mode_b        = 1;
            trigger_in    = 0;

            #500;
            trigger_in    = 1;

            #15000;
            trigger_in    = 0;

            #15000;
            trigger_in    = 1;

            #2000;
            trigger_in    = 0;

            #2000;
            trigger_in    = 1;

            #2000;
            trigger_in    = 0;

            #20000;
            trigger_in    = 1;

            #30000;
            trigger_in    = 0;

            #2000;
            trigger_in    = 1;

            #2000;
            trigger_in    = 0;

            #4000;
            trigger_in    = 1;

            #10000;
            rst_n         = 0;

            //! Delayed Release mode
            #10000;
            rst_n         = 1;
            mode_a        = 1;
            mode_b        = 0;
            trigger_in    = 0;

            #500;
            trigger_in    = 1;

            #15000;
            trigger_in    = 0;

            #15000;
            trigger_in    = 1;

            #2000;
            trigger_in    = 0;

            #2000;
            trigger_in    = 1;

            #2000;
            trigger_in    = 0;

            #20000;
            trigger_in    = 1;

            #30000;
            trigger_in    = 0;

            #2000;
            trigger_in    = 1;

            #2000;
            trigger_in    = 0;

            #4000;
            trigger_in    = 1;

            #10000;
            rst_n         = 0;

            //! Dual Delay mode
            #10000;
            rst_n         = 1;
            mode_a        = 1;
            mode_b        = 1;
            trigger_in    = 0;

            #500;
            trigger_in    = 1;

            #15000;
            trigger_in    = 0;

            #15000;
            trigger_in    = 1;

            #2000;
            trigger_in    = 0;

            #2000;
            trigger_in    = 1;

            #2000;
            trigger_in    = 0;

            #20000;
            trigger_in    = 1;

            #30000;
            trigger_in    = 0;

            #2000;
            trigger_in    = 1;

            #2000;
            trigger_in    = 0;

            #4000;
            trigger_in    = 1;

            #10000;
            rst_n         = 0;

            #10000;
            rst_n         = 1;
        end
    endtask

    task static clock_gen;
        begin
            clk = 0;
            forever #500 clk = ~clk;
        end
    endtask

    task static endsimulation;
        begin
            #ENDTIME;
            $display("-------------- THE SIMUALTION FINISHED ------------");
            $finish;
        end
    endtask

endmodule
