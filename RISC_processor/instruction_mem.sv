module instruction_mem #(
    parameter int PC_WIDTH      = 16,
    parameter int MEM_DATA_SIZE = 16,
    parameter int MEM_SIZE      = 15
) (
    input [PC_WIDTH-1:0] pc_in,

    output [PC_WIDTH-1:0] instruction
);

    reg [MEM_DATA_SIZE-1:0] mem_array [MEM_SIZE-1:0];

    wire [3:0] rom_addr = pc_in[4:1];

    initial begin
        $readmemb("test/test.prog", mem_array, 0, PC_WIDTH-2);
    end

    assign instruction = mem_array[rom_addr];

endmodule
