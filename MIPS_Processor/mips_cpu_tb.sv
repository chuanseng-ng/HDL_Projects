`timescale 1ns/1ps
`include "include/mips_define.sv"

module mips_cpu_tb #(
    parameter int PC_WIDTH = 16
) ();
    reg clk;
    reg rst_n;

    wire [PC_WIDTH-1:0] pc_out;
    wire [PC_WIDTH-1:0] alu_result;

    mips_processor #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH),
        .PC_WIDTH   (PC_WIDTH),
        .INSTR_NUM  (INSTR_NUM),
        .ALU_SIZE   (SHIFT_BIT),
        .SHIFT_BIT  (SHIFT_BIT),
        .MEM_SIZE   (MEM_SIZE)
    ) u_mips_cpu (
        .clk        (clk),
        .rst_n      (rst_n),
        .pc_out     (pc_out),
        .alu_result (alu_result)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        rst_n = 1;
        // Wait 100ns for global reset to finish
        #100;
        rst_n = 0;
        // Add stimulus here - if any
    end

endmodule
