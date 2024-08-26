/*
    Sub module - ALU Unit for MIPS Processor

    Operations:
    -- Add                 - alu_out = A + B
    -- Subtract            - alu_out = A - B
    -- Multiply            - alu_out = A * B
    -- Divide              - alu_out = A / B
    -- Logical Left Shift  - alu_out = A logical shifted left by 1
    -- Logical Right Shift - alu_out = A logical shifted right by 1
    -- Rotate Left         - alu_out = A rotated left by 1
    -- Rotate Right        - alu_out = A rotated right by 1
    -- Logical AND         - alu_out = A AND B
    -- Logical OR          - alu_out = A OR B
    -- Logical XOR         - alu_out = A XOR B
    -- Logical NOR         - alu_out = A NOr B
    -- Logical NAND        - alu_out = A NAND B
    -- Logical XNOR        - alu_out = A XNOR B
    -- Greater Compare     - alu_out = 1 if A > B else 0
    -- Equal Compare       - alu_out = 1 if A == B else 0
*/
module alu_unit #(
    parameter int ALU_SIZE  = 16, //! Arithmetic logic unit bit width
    parameter int SHIFT_BIT = 1   //! Number of bits to shift
) (
    input [ALU_SIZE-1:0] alu_in_a, //! ALU input A
    input [ALU_SIZE-1:0] alu_in_b, //! ALU input B
    input [3:0]          alu_sel,  //! ALU operation selector

    output [ALU_SIZE-1:0] alu_out, //! ALU output

    output carry_out //! ALU carry bit output
);
    reg [ALU_SIZE-1:0] alu_result; //! ALU operation result

    wire [ALU_SIZE:0]   carry_out_temp; //! ALU carry bit temp holder

    always_comb begin: alu_operation
        case (alu_sel)
            4'b0000: alu_result = alu_in_a + alu_in_b;                            // Addition
            4'b0001: alu_result = alu_in_a - alu_in_b;                            // Subtraction
            4'b0010: alu_result = $unsigned(alu_in_a) * $unsigned(alu_in_b);      // Multiplication
            4'b0011: alu_result = $unsigned(alu_in_a) / $unsigned(alu_in_b);      // Division
            4'b0100: alu_result = alu_in_a << SHIFT_BIT;                          // Logical shift left
            4'b0101: alu_result = alu_in_a >> SHIFT_BIT;                          // Logical shift right
            4'b0110: alu_result = {alu_in_a[ALU_SIZE-2:0], alu_in_a[ALU_SIZE-1]}; // Rotate left
            4'b0111: alu_result = {alu_in_a[0], alu_in_a[ALU_SIZE-1:1]};          // Rotate right
            4'b1000: alu_result = alu_in_a & alu_in_b;                            // Logical AND
            4'b1001: alu_result = alu_in_a | alu_in_b;                            // Logical OR
            4'b1010: alu_result = alu_in_a ^ alu_in_b;                            // Logical XOR
            4'b1011: alu_result = ~(alu_in_a | alu_in_b);                         // Logical NOR
            4'b1100: alu_result = ~(alu_in_a & alu_in_b);                         // Logical NAND
            4'b1101: alu_result = ~(alu_in_a ^ alu_in_b);                         // Logical XNOR
            4'b1110: alu_result = (alu_in_a > alu_in_b) ? 'd1 : 'd0;              // Greater comparison
            4'b1111: alu_result = (alu_in_a == alu_in_b) ? 'd1 : 'd0;             // Equal comparison
            default: alu_result = alu_in_a + alu_in_b;                            // Default
        endcase
    end

    assign alu_out        = alu_result;
    assign carry_out_temp = {1'b0, alu_in_a} + {1'b0, alu_in_b};
    assign carry_out      = carry_out_temp[ALU_SIZE];
endmodule
