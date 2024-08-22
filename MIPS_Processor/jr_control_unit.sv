// Sub module - JR Control Unit for MIPS Processor
module jr_control_unit #() (
    input [1:0] alu_opcode,
    input [3:0] alu_funct,

    output jr_ctrl
);
    assign jr_ctrl = ({alu_opcode, alu_funct} == 6'b001000) ? 1'b1 : 1'b0;

endmodule
