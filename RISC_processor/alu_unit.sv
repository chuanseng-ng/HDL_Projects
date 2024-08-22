module alu_unit #(
    parameter int PC_WIDTH = 16
) (
    input [PC_WIDTH-1:0] alu_in_a,
    input [PC_WIDTH-1:0] alu_in_b,

    input [2:0] alu_ctrl,

    output reg [PC_WIDTH-1:0] alu_result,

    output zero
);

    always_comb begin
        case(alu_ctrl)
            3'b000: alu_result = alu_in_a + alu_in_b; // add
            3'b001: alu_result = alu_in_a - alu_in_b; // sub
            3'b010: alu_result = ~alu_in_a;           // inv
            3'b011: alu_result = alu_in_a << alu_in_b;
            3'b100: alu_result = alu_in_a >> alu_in_b;
            3'b101: alu_result = alu_in_a & alu_in_b; // and
            3'b110: alu_result = alu_in_a | alu_in_b; // or
            3'b111: begin
                if (alu_in_a < alu_in_b) begin
                    alu_result = 16'd1;
                end else begin
                    alu_result = 16'd0;
                end
            end
            default: alu_result = alu_in_a + alu_in_b; // add
        endcase
    end

    assign zero = (alu_result == 16'd0) ? 1'b1 : 1'b0;

endmodule
