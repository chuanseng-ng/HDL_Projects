`timescale 1ns/1ps

module alu_unit_tb #(
    parameter int ALU_SIZE = 8
) ();
    integer i;

    reg [ALU_SIZE-1:0] alu_in_a, alu_in_b;
    reg [3:0]          alu_sel;

    wire [ALU_SIZE-1:0] alu_out;

    wire carry_out;

    alu_unit #(
        .ALU_SIZE  (ALU_SIZE),
        .SHIFT_BIT (1)
    ) u_alu_unit (
        .alu_in_a  (alu_in_a),
        .alu_in_b  (alu_in_b),
        .alu_sel   (alu_sel),
        .alu_out   (alu_out),
        .carry_out (carry_out)
    );

    initial begin
        alu_in_a = 8'h0A;
        alu_in_b = 4'h02;
        alu_sel  = 4'h0;

        for (i = 0; i < 16; i++) begin
            alu_sel = alu_sel + 1;
            #10;
        end

    alu_in_a = 8'hF6;
    alu_in_b = 8'h0A;
    end
endmodule
