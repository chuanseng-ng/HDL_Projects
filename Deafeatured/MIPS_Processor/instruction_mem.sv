// Sub module - Instruction Memory for MIPS Processor
module instruction_mem #(
    parameter int PC_WIDTH   = 16,
    parameter int DATA_WIDTH = 16,
    parameter int INSTR_NUM  = 15
) (
    input [PC_WIDTH-1:0] cpu_pc,

    output [PC_WIDTH-1:0] cpu_instruction
);
    reg [DATA_WIDTH-1:0] instr_mem [INSTR_NUM-1:0];

    wire [(PC_WIDTH/4)-1:0] rom_addr = cpu_pc[(PC_WIDTH/4):1];

    initial begin
        $readmemb("test/test.prog", instr_mem, 0, INSTR_NUM-1);
    end

    assign cpu_instruction = instr_mem[rom_addr];

endmodule
