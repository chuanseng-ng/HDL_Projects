// Sub module - Data Memory for MIPS Processor
module data_memory #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 16,
    parameter int MEM_SIZE   = 256
) (
    input clk_in,
    input mem_wr_en,
    input mem_rd_en,

    input [ADDR_WIDTH-1:0] mem_access_addr,
    input [DATA_WIDTH-1:0] mem_data_in,

    output [DATA_WIDTH-1:0] mem_data_out
);
    integer i;

    reg [DATA_WIDTH-1:0] data_ram [MEM_SIZE-1:0];

    wire [(ADDR_WIDTH/2)-1:0] ram_addr = mem_access_addr[(ADDR_WIDTH/2):1];

    initial begin
        for (i = 0; i < MEM_SIZE; i++) begin
            data_ram[i] <= {(DATA_WIDTH){1'b0}};
        end
    end

    always @(posedge clk_in) begin
        if (mem_wr_en) begin
            data_ram[ram_addr] <= mem_data_in;
        end
    end

    assign mem_data_out = (mem_rd_en == 1'b1) ? data_ram[ram_addr] : {(DATA_WIDTH){1'b0}};
endmodule
