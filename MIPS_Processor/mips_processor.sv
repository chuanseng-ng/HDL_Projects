/*
    16-bit Single-Cycle MIPS Processor
    -- RISC processor

    Instruction Format:
    --    Name    |                   Fields                     |            Comments
    -- Field Size | 3 bits | 3 bits | 3 bits | 3 bits |  4 bits  | All MIPS-L instructions 16 bits
    --  R-format  |   op   |   rs   |   rt   |   rd   |   funct  | Arithmetic instruction format
    --  I-format  |   op   |   rs   |   rt   | Address/immediate | Transfer, branch, immediate format
    --  J-format  |   op   |            target address           | Jump instruction format

    Instruction Set Architecture:
    -- Name | Format |                    Example                 | Comments
    --      |        | 3 bits | 3 bits | 3 bits | 3 bits | 4 bits |
    -- add  |    R   |    0   |    2   |    3   |    1   |    0   | add $1, $2, $3
    -- sub  |    R   |    0   |    2   |    3   |    1   |    1   | sub $1, $2, $3
    -- and  |    R   |    0   |    2   |    3   |    1   |    2   | and $1, $2, $3
    --  or  |    R   |    0   |    2   |    3   |    1   |    3   | or $1, $2, $3
    -- slt  |    R   |    0   |    2   |    3   |    1   |    4   | slt $1, $2, $3
    --  jr  |    R   |    0   |    7   |    0   |    0   |    8   | jr $7
    --  lw  |    I   |    4   |    2   |    1   |        7        | lw $1, 7, ($2)
    --  sw  |    I   |    5   |    2   |    1   |        7        | sw $1, 7, ($2)
    -- beq  |    I   |    6   |    1   |    2   |        7        | beq $1, $2, 7
    -- addi |    I   |    7   |    2   |    1   |        7        | addi $1, $2, 7
    --  j   |    J   |    2   |                 500               | j 1000
    -- jal  |    J   |    3   |                 500               | jal 1000
    -- slti |    I   |    1   |    2   |    1   |        7        | slti $1, $2, 7

    Description:
    -- Add      - R[rd] = R[rs] + R[rt]
    -- Subtract - R[rd] = R[rs] - R[rt]
    -- And      - R[rd] = R[rs] & R[rt]
    -- Or       - R[rd] = R[rs] | R[rt]
    -- SLT      - R[rd] = 1 if R[rs] < R[rt] else 0
    -- Jr       - PC = R[rs]
    -- Lw       - R[rt] = M[R[rs] + SignExtImm]
    -- Sw       - M[R[rs] + SignExtImm] = R[rt]
    -- Beq      - if (R[rs] == R[rt]) PC = PC + 1 + BranchAddr
    -- Addi     - R[rt] = R[rs] + SignExtImm
    -- J        - PC = JumpAddr
    -- Jal      - R[7] = PC + 2; PC = JumpAddr
    -- SLTI     - R[rt] = 1 if R[rs] < imm else 0
                  SignExtImm = {9{immediate[6]}}, imm
                  JumpAddr = {(PC + 1)[15:13], address}
                  BranchAddr = {7{immediate[6]}, immediate, 1'b0}

    Control Unit Design:
    - Control Signal -
    -- Instruction | Req Dst | ALU Src | Memto Reg | Reg Write | MemRead | MemWrite | Branch | ALUOp | Jump
    --    R-type   |    1    |    0    |      0    |     1     |    0    |     0    |    0   |   00  |   0
    --      LW     |    0    |    1    |      1    |     1     |    1    |     0    |    0   |   11  |   0
    --      SW     |    0    |    1    |      0    |     0     |    0    |     1    |    0   |   11  |   0
    --     addi    |    0    |    1    |      0    |     1     |    0    |     0    |    0   |   11  |   0
    --      beq    |    0    |    0    |      0    |     0     |    0    |     0    |    1   |   01  |   0
    --       j     |    0    |    0    |      0    |     0     |    0    |     0    |    0   |   00  |   1
    --      jal    |    2    |    0    |      2    |     1     |    0    |     0    |    0   |   00  |   1
    --     slti    |    0    |    1    |      0    |     1     |    0    |     0    |    0   |   10  |   0

    - ALU Control -
    -- ALUop | Function | ALUcnt | ALU Operation | Instruction
    --   11  |   xxxx   |   000  |      ADD      | addi, lw, sw
    --   01  |   xxxx   |   001  |      SUB      |     BEQ
    --   00  |    00    |   000  |      ADD      | R-type: ADD
    --   00  |    01    |   001  |      SUB      | R-type: sub
    --   00  |    02    |   010  |      AND      | R-type: AND
    --   00  |    03    |   011  |       OR      | R-type: OR
    --   00  |    04    |   100  |      slt      | R-type: slt
    --   10  |   xxxx   |   100  |      slt      | I-type: slti
*/

module mips_processor #(
    parameter int ADDR_WIDTH = 16,
    parameter int DATA_WIDTH = 16,
    parameter int PC_WIDTH   = 16,
    parameter int INSTR_NUM  = 15,
    parameter int ALU_SIZE   = ADDR_WIDTH,
    parameter int SHIFT_BIT  = 1,
    parameter int MEM_SIZE   = 256
) (
    input clk,
    input rst_n,

    output [PC_WIDTH-1:0]   pc_out,
    output [DATA_WIDTH-1:0] alu_result
);
    reg [PC_WIDTH-1:0] pc_current;

    wire signed [PC_WIDTH-1:0] pc_next, pc2;
    wire signed [PC_WIDTH-1:0] im_shift_1, pc_j, pc_beq, pc_4beq, pc_4beqj, pc_jr;

    wire [PC_WIDTH-1:0]   cpu_instr;
    wire [1:0]            dest_reg, mem_to_reg, alu_opcode;
    wire [DATA_WIDTH-1:0] reg_wr_data, reg_rd_data_1, reg_rd_data_2;
    wire [2:0]            reg_wr_dest, reg_rd_addr_1, reg_rd_addr_2;
    wire [PC_WIDTH-1:0]   sign_ext_im, zero_ext_im, imm_ext;
    wire [DATA_WIDTH-1:0] read_data2;
    wire [2:0]            alu_ctrl;
    wire [DATA_WIDTH-1:0] alu_out;
    wire [14:0]           jump_shift_1;
    wire [DATA_WIDTH-1:0] mem_rd_data;
    wire [DATA_WIDTH-1:0] no_sign_ext;

    wire cpu_jump, cpu_branch, cpu_mem_rd, cpu_mem_wr, cpu_alu_src, cpu_reg_wr;
    wire jr_ctrl;
    wire zero_flag;
    wire beq_ctrl;
    wire sign_or_zero;

    // PC (Program Counter)
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            pc_current <= {(PC_WIDTH){1'b0}};
        end else begin
            pc_current <= pc_next;
        end
    end

    // PC+2
    assign pc2 = pc_current + 'd2;

    // Instruction Memory
    instruction_mem #(
        .PC_WIDTH   (PC_WIDTH),
        .DATA_WIDTH (DATA_WIDTH),
        .INSTR_NUM  (INSTR_NUM)
    ) u_instruction_mem (
        .cpu_pc          (pc_current),
        .cpu_instruction (cpu_instr)
    );

    // Jump Shift Left 1
    assign jump_shift_1 = {cpu_instr[PC_WIDTH-2:0], 1'b0};

    // Control Unit
    cpu_control_unit #() u_cpu_control_unit (
        .rst_n        (rst_n),
        .cpu_opcode   (cpu_instr[PC_WIDTH-1:PC_WIDTH-3]),
        .dest_reg     (dest_reg),
        .mem_to_reg   (mem_to_reg),
        .alu_opcode   (alu_opcode),
        .cpu_jump     (cpu_jump),
        .cpu_branch   (cpu_branch),
        .cpu_mem_rd   (cpu_mem_rd),
        .cpu_mem_wr   (cpu_mem_wr),
        .cpu_alu_src  (cpu_alu_src),
        .cpu_reg_wr   (cpu_reg_wr),
        .sign_or_zero (sign_or_zero)
    );

    // Multiplexer dest_reg
    assign reg_wr_dest = (dest_reg == 2'b10) ? 3'b111 :
                        ((dest_reg == 2'b01) ? cpu_instr[PC_WIDTH-10:PC_WIDTH-12] :
                        cpu_instr[PC_WIDTH-7:PC_WIDTH-9]);

    // Register File
    assign reg_rd_addr_1 = cpu_instr[PC_WIDTH-4:PC_WIDTH-6];
    assign reg_rd_addr_2 = cpu_instr[PC_WIDTH-7:PC_WIDTH-9];

    register_file #(
        .DATA_WIDTH (DATA_WIDTH),
        .REG_NUM    (8)
    ) u_register_file (
        .clk_in        (clk),
        .reg_wr_en     (cpu_reg_wr),
        .reg_wr_dest   (reg_wr_dest),
        .reg_rd_addr_1 (reg_rd_addr_1),
        .reg_rd_addr_2 (reg_rd_addr_2),
        .reg_wr_data   (reg_wr_data),
        .reg_rd_data_1 (reg_rd_data_1),
        .reg_rd_data_2 (reg_rd_data_2)
    );

    // Sign Extend
    assign sign_ext_im = {{9{cpu_instr[PC_WIDTH-9]}}, cpu_instr[PC_WIDTH-9:0]};
    assign zero_ext_im = {{9{1'b0}}, cpu_instr[PC_WIDTH-9:0]};
    assign imm_ext     = (sign_or_zero == 1'b1) ? sign_ext_im : zero_ext_im;

    // JR Control Unit
    jr_control_unit #() u_jr_ctrl_unit (
        .alu_opcode (alu_opcode),
        .alu_funct  (cpu_instr[PC_WIDTH-13:0]),
        .jr_ctrl    (jr_ctrl)
    );

    // ALU Control Unit
    alu_control_unit #() u_alu_ctrl_unit (
        .alu_opcode (alu_opcode),
        .alu_funct  (cpu_instr[PC_WIDTH-13:0]),
        .alu_ctrl   (alu_ctrl)
    );

    //Multiplexer alu_src
    assign read_data2 =(cpu_alu_src == 1'b1) ? imm_ext : reg_rd_data_2;

    // ALU
    alu_unit #(
        .ALU_SIZE  (ALU_SIZE),
        .SHIFT_BIT (SHIFT_BIT)
    ) u_alu_unit (
        .alu_in_a  (reg_rd_data_1),
        .alu_in_b  (read_data2),
        .alu_sel   ({1'b0,alu_ctrl}),
        .alu_out   (alu_out),
        .carry_out (zero_flag)
    );

    // Immediate shift 1
    assign im_shift_1 = {imm_ext[PC_WIDTH-2:0],1'b0};

    //
    assign no_sign_ext = ~{im_shift_1} + 1'b1;

    // PC beq add
    assign pc_beq = (im_shift_1[PC_WIDTH-1] == 1'b1) ? (pc2 - no_sign_ext) : (pc2 + im_shift_1);

    // beq control
    assign beq_ctrl = cpu_branch & zero_flag;

    // PC beq
    assign pc_4beq = (beq_ctrl == 1'b1) ? pc_beq : pc2;

    // PC j
    assign pc_j = {pc2[PC_WIDTH-1], jump_shift_1};

    // PC 4beqj
    assign pc_4beqj = (cpu_jump == 1'b1) ? pc_j : pc_4beq;

    // PC jr
    assign pc_jr = reg_rd_data_1;

    // PC next
    assign pc_next = (jr_ctrl == 1'b1) ? pc_jr : pc_4beqj;

    // Data Memory
    data_memory #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH),
        .MEM_SIZE   (MEM_SIZE)
    ) u_data_mem (
        .clk_in          (clk),
        .mem_wr_en       (cpu_mem_wr),
        .mem_rd_en       (cpu_mem_rd),
        .mem_access_addr (alu_out),
        .mem_data_in     (reg_rd_data_2),
        .mem_data_out    (mem_rd_data)
    );

    // Write-back
    assign reg_wr_data = (mem_to_reg == 2'b10) ? pc2 :
                        ((mem_to_reg == 2'b01) ? mem_rd_data : alu_out);

    // Output
    assign pc_out     = pc_current;
    assign alu_result = alu_out;

endmodule
