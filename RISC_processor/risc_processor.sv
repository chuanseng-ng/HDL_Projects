module risc_processor #() (
    input clk
);

    wire jump;
    wire bne;
    wire beq;
    wire mem_rd;
    wire mem_wr;
    wire alu_src;
    wire reg_dest;
    wire mem_to_reg;
    wire reg_wr;

    wire [1:0] alu_op;
    wire [3:0] opcode;

    datapath_unit #(
        .PC_WIDTH   (16), // 16 bits
        .ADDR_WIDTH (3),  // 3 bits
        .DATA_WIDTH (16), // 16 bits
        .MEM_SIZE   (15), // 15 bits
        .DATA_SIZE  (8),  // 8 bits
        .ARRAY_SIZE (8)   // 8 bits
    ) u_datapath_unit (
        .clk        (clk),
        .jump       (jump),
        .bne        (bne),
        .beq        (beq),
        .mem_rd     (mem_rd),
        .mem_wr     (mem_wr),
        .alu_src    (alu_src),
        .reg_dest   (reg_dest),
        .mem_to_reg (mem_to_reg),
        .reg_wr     (reg_wr),
        .alu_op     (alu_op),
        .opcode     (opcode)
    );

    cpu_ctrl_unit #() u_cpu_ctrl_unit (
        .opcode     (opcode),
        .reg_dest   (reg_dest),
        .mem_to_reg (mem_to_reg),
        .alu_op     (alu_op),
        .jump       (jump),
        .bne        (bne),
        .beq        (beq),
        .mem_rd     (mem_rd),
        .mem_wr     (mem_wr),
        .alu_src    (alu_src),
        .reg_wr     (reg_wr)
    );

endmodule
