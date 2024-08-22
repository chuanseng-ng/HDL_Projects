`timescale 1ns/1ps

`define SIM_TIME 160

module risc_cpu_tb #() ();

    reg clk;

    risc_processor #() u_risc_cpu (
        .clk (clk)
    );

    initial begin
        clk <= 0;
        #`SIM_TIME;
        $finish;
    end

    always begin
        #5 clk = ~clk;
    end

endmodule
