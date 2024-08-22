module alu_ctrl_unit #() (
    input [1:0] alu_op,
    input [3:0] opcode,

    output reg [2:0] alu_counter
);

    wire [5:0] alu_ctrl_in;

    assign alu_ctrl_in = {alu_op, opcode};

    always @(alu_ctrl_in) begin
        casex (alu_ctrl_in)
            6'b10xxxx: alu_counter = 3'b000;
            6'b01xxxx: alu_counter = 3'b001;
            6'b000010: alu_counter = 3'b000;
            6'b000011: alu_counter = 3'b001;
            6'b000100: alu_counter = 3'b010;
            6'b000101: alu_counter = 3'b011;
            6'b000110: alu_counter = 3'b100;
            6'b000111: alu_counter = 3'b101;
            6'b001000: alu_counter = 3'b110;
            6'b001001: alu_counter = 3'b111;
            default:   alu_counter = 3'b000;
        endcase
    end

endmodule
