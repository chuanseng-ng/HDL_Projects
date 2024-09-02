module cpu_ctrl_unit #() (
    input [3:0] opcode,

    output reg [1:0] alu_op,

    output reg jump,
    output reg beq,
    output reg bne,
    output reg mem_rd,
    output reg mem_wr,
    output reg alu_src,
    output reg reg_dest,
    output reg mem_to_reg,
    output reg reg_wr
);

    always_comb begin
        case(opcode)
            4'b0000:  // LW
            begin
                reg_dest = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_wr = 1'b1;
                mem_rd = 1'b1;
                mem_wr = 1'b0;
                beq = 1'b0;
                bne = 1'b0;
                alu_op = 2'b10;
                jump = 1'b0;
            end
            4'b0001:  // SW
            begin
                reg_dest = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                reg_wr = 1'b0;
                mem_rd = 1'b0;
                mem_wr = 1'b1;
                beq = 1'b0;
                bne = 1'b0;
                alu_op = 2'b10;
                jump = 1'b0;
            end
            4'b0010:  // data_processing
            begin
                reg_dest = 1'b1;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_wr = 1'b1;
                mem_rd = 1'b0;
                mem_wr = 1'b0;
                beq = 1'b0;
                bne = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
            end
            4'b0011:  // data_processing
            begin
                reg_dest = 1'b1;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_wr = 1'b1;
                mem_rd = 1'b0;
                mem_wr = 1'b0;
                beq = 1'b0;
                bne = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
            end
            4'b0100:  // data_processing
            begin
                reg_dest = 1'b1;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_wr = 1'b1;
                mem_rd = 1'b0;
                mem_wr = 1'b0;
                beq = 1'b0;
                bne = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
            end
            4'b0101:  // data_processing
            begin
                reg_dest = 1'b1;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_wr = 1'b1;
                mem_rd = 1'b0;
                mem_wr = 1'b0;
                beq = 1'b0;
                bne = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
            end
            4'b0110:  // data_processing
            begin
                reg_dest = 1'b1;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_wr = 1'b1;
                mem_rd = 1'b0;
                mem_wr = 1'b0;
                beq = 1'b0;
                bne = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
            end
            4'b0111:  // data_processing
            begin
                reg_dest = 1'b1;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_wr = 1'b1;
                mem_rd = 1'b0;
                mem_wr = 1'b0;
                beq = 1'b0;
                bne = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
            end
            4'b1000:  // data_processing
            begin
                reg_dest = 1'b1;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_wr = 1'b1;
                mem_rd = 1'b0;
                mem_wr = 1'b0;
                beq = 1'b0;
                bne = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
            end
            4'b1001:  // data_processing
            begin
                reg_dest = 1'b1;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_wr = 1'b1;
                mem_rd = 1'b0;
                mem_wr = 1'b0;
                beq = 1'b0;
                bne = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
            end
            4'b1011:  // BEQ
            begin
                reg_dest = 1'b0;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_wr = 1'b0;
                mem_rd = 1'b0;
                mem_wr = 1'b0;
                beq = 1'b1;
                bne = 1'b0;
                alu_op = 2'b01;
                jump = 1'b0;
            end
            4'b1100:  // BNE
            begin
                reg_dest = 1'b0;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_wr = 1'b0;
                mem_rd = 1'b0;
                mem_wr = 1'b0;
                beq = 1'b0;
                bne = 1'b1;
                alu_op = 2'b01;
                jump = 1'b0;
            end
            4'b1101:  // J
            begin
                reg_dest = 1'b0;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_wr = 1'b0;
                mem_rd = 1'b0;
                mem_wr = 1'b0;
                beq = 1'b0;
                bne = 1'b0;
                alu_op = 2'b00;
                jump = 1'b1;
            end
            default: begin
                reg_dest = 1'b1;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_wr = 1'b1;
                mem_rd = 1'b0;
                mem_wr = 1'b0;
                beq = 1'b0;
                bne = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
            end
        endcase
    end

endmodule
