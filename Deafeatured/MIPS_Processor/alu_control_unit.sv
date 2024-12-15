// Sub module - ALU Control Unit for MIPS Processor
module alu_control_unit #() (
    input [1:0] alu_opcode,
    input [3:0] alu_funct,

    output reg [2:0] alu_ctrl
);
    wire [5:0] alu_ctrl_in;

    assign alu_ctrl_in = {alu_opcode, alu_funct};

    always @(alu_ctrl_in) begin
        casex (alu_ctrl_in)
            6'b11xxxx: alu_ctrl = 3'b000;
            6'b10xxxx: alu_ctrl = 3'b100;
            6'b01xxxx: alu_ctrl = 3'b001;
            6'b000000: alu_ctrl = 3'b000;
            6'b000001: alu_ctrl = 3'b001;
            6'b000010: alu_ctrl = 3'b010;
            6'b000011: alu_ctrl = 3'b011;
            6'b000100: alu_ctrl = 3'b100;
            default: alu_ctrl = 3'b000;
        endcase
    end

endmodule
