`timescale 1ns/1ps
`include "include/mips_define.sv"

`define DELAY 100

module mips_cpu_tb #() ();

    parameter int ENDTIME    = 2000;
    parameter int ADDR_WIDTH = 16;
    parameter int DATA_WIDTH = 16;
    parameter int INSTR_NUM  = 15;
    parameter int SHIFT_BIT  = 1;
    parameter int MEM_SIZE   = 256;
    parameter int PC_WIDTH   = 16;

    reg clk;
    reg rst_n;

    wire [PC_WIDTH-1:0] pc_out;
    wire [PC_WIDTH-1:0] alu_result;

    mips_processor #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH),
        .PC_WIDTH   (PC_WIDTH),
        .INSTR_NUM  (INSTR_NUM),
        .SHIFT_BIT  (SHIFT_BIT),
        .MEM_SIZE   (MEM_SIZE)
    ) u_mips_cpu (
        .clk        (clk),
        .rst_n      (rst_n),
        .pc_out     (pc_out),
        .alu_result (alu_result)
    );

    initial begin
        clk   = 0;
        rst_n = 0;
    end

    initial begin
        $display("16bits asynchronous MIPS Processor");

        $dumpfile("16bit_MIPS.vcd");
        $dumpvars();
        main;
    end

    task automatic main;
        fork
            clock_gen;
            reset_gen;
            endsimulation;
        join
    endtask

    task static clock_gen;
        begin
            forever #`DELAY clk = !clk;
        end
    endtask


    task static reset_gen;
        begin
            rst_n = 0;
            // Wait 100ns for global reset to finish
            #`DELAY;
            rst_n = 1;
        end
    endtask

    always @(posedge clk or negedge rst_n) begin
        $display("TIME = %d, pc_out = %d, alu_result = %d", $time, pc_out, alu_result);
    end

    task static endsimulation;
        begin
            #ENDTIME
            $display("-------------- THE SIMUALTION FINISHED ------------");
            $finish;
        end
    endtask

endmodule
