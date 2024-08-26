// Sub module - Instruction Memory for MIPS Processor
module cpu_control_unit #() (
    input rst_n, //! Reset input - Active low

    input [2:0] cpu_opcode, //! CPU opcode input

    output reg [1:0] dest_reg,   //! Multiplexer destination register
    output reg [1:0] mem_to_reg, //! Memory to register logic
    output reg [1:0] alu_opcode, //! Arithmetic logic unit opcode

    output reg cpu_jump,    //! CPU Jump indicator
    output reg cpu_branch,  //! CPU Branch indicator
    output reg cpu_mem_rd,  //! CPU Read from Memory indicator
    output reg cpu_mem_wr,  //! CPU Write to Memory indicator
    output reg cpu_alu_src, //! CPU Source from ALU indicator
    output reg cpu_reg_wr,  //! CPU Write to Register indicator
    output reg sign_or_zero //! Signed or Zero indicator
);
    always_comb begin: cpu_ctrl_operation
        if (~rst_n) begin
            dest_reg     = 2'b00;
            mem_to_reg   = 2'b00;
            alu_opcode   = 2'b00;
            cpu_jump     = 1'b0;
            cpu_branch   = 1'b0;
            cpu_mem_rd   = 1'b0;
            cpu_mem_wr   = 1'b0;
            cpu_alu_src  = 1'b0;
            cpu_reg_wr   = 1'b0;
            sign_or_zero = 1'b1;
        end else begin
            case (cpu_opcode)
                3'b000: begin // add operation
                    dest_reg     = 2'b01;
                    mem_to_reg   = 2'b00;
                    alu_opcode   = 2'b00;
                    cpu_jump     = 1'b0;
                    cpu_branch   = 1'b0;
                    cpu_mem_rd   = 1'b0;
                    cpu_mem_wr   = 1'b0;
                    cpu_alu_src  = 1'b0;
                    cpu_reg_wr   = 1'b1;
                    sign_or_zero = 1'b1;
                end
                3'b001: begin // sli operation
                    dest_reg     = 2'b00;
                    mem_to_reg   = 2'b00;
                    alu_opcode   = 2'b10;
                    cpu_jump     = 1'b0;
                    cpu_branch   = 1'b0;
                    cpu_mem_rd   = 1'b0;
                    cpu_mem_wr   = 1'b0;
                    cpu_alu_src  = 1'b1;
                    cpu_reg_wr   = 1'b1;
                    sign_or_zero = 1'b0;
                end
                3'b010: begin // j operation
                    dest_reg     = 2'b00;
                    mem_to_reg   = 2'b00;
                    alu_opcode   = 2'b00;
                    cpu_jump     = 1'b1;
                    cpu_branch   = 1'b0;
                    cpu_mem_rd   = 1'b0;
                    cpu_mem_wr   = 1'b0;
                    cpu_alu_src  = 1'b0;
                    cpu_reg_wr   = 1'b0;
                    sign_or_zero = 1'b1;
                end
                3'b011: begin // jal operation
                    dest_reg     = 2'b10;
                    mem_to_reg   = 2'b10;
                    alu_opcode   = 2'b11;
                    cpu_jump     = 1'b0;
                    cpu_branch   = 1'b0;
                    cpu_mem_rd   = 1'b1;
                    cpu_mem_wr   = 1'b0;
                    cpu_alu_src  = 1'b1;
                    cpu_reg_wr   = 1'b1;
                    sign_or_zero = 1'b1;
                end
                3'b100: begin // lw operation
                    dest_reg     = 2'b00;
                    mem_to_reg   = 2'b01;
                    alu_opcode   = 2'b11;
                    cpu_jump     = 1'b0;
                    cpu_branch   = 1'b0;
                    cpu_mem_rd   = 1'b1;
                    cpu_mem_wr   = 1'b0;
                    cpu_alu_src  = 1'b1;
                    cpu_reg_wr   = 1'b1;
                    sign_or_zero = 1'b1;
                end
                3'b101: begin // sw operation
                    dest_reg     = 2'b00;
                    mem_to_reg   = 2'b00;
                    alu_opcode   = 2'b11;
                    cpu_jump     = 1'b0;
                    cpu_branch   = 1'b0;
                    cpu_mem_rd   = 1'b0;
                    cpu_mem_wr   = 1'b1;
                    cpu_alu_src  = 1'b1;
                    cpu_reg_wr   = 1'b0;
                    sign_or_zero = 1'b1;
                end
                3'b110: begin // beq operation
                    dest_reg     = 2'b00;
                    mem_to_reg   = 2'b00;
                    alu_opcode   = 2'b01;
                    cpu_jump     = 1'b0;
                    cpu_branch   = 1'b1;
                    cpu_mem_rd   = 1'b0;
                    cpu_mem_wr   = 1'b0;
                    cpu_alu_src  = 1'b0;
                    cpu_reg_wr   = 1'b0;
                    sign_or_zero = 1'b1;
                end
                3'b111: begin // addi operation
                    dest_reg     = 2'b00;
                    mem_to_reg   = 2'b00;
                    alu_opcode   = 2'b11;
                    cpu_jump     = 1'b0;
                    cpu_branch   = 1'b0;
                    cpu_mem_rd   = 1'b0;
                    cpu_mem_wr   = 1'b0;
                    cpu_alu_src  = 1'b1;
                    cpu_reg_wr   = 1'b1;
                    sign_or_zero = 1'b1;
                end
                default: begin
                    dest_reg     = 2'b01;
                    mem_to_reg   = 2'b00;
                    alu_opcode   = 2'b00;
                    cpu_jump     = 1'b0;
                    cpu_branch   = 1'b0;
                    cpu_mem_rd   = 1'b0;
                    cpu_mem_wr   = 1'b0;
                    cpu_alu_src  = 1'b0;
                    cpu_reg_wr   = 1'b1;
                    sign_or_zero = 1'b1;
                end
            endcase
        end
    end

endmodule
