`timescale 1ns/1ps

`define SIM_TIME 1600

module risc_cpu_tb #() ();

    reg clk;

    risc_processor #() u_risc_cpu (
        .clk (clk)
    );

    initial begin
        $display("RISC CPU TB");

        $dumpfile("risc_cpu.vcd");
        $dumpvars();

        clk <= 0;
        #`SIM_TIME;
        $finish;
    end

    always begin
        #5 clk = ~clk;
    end

endmodule
