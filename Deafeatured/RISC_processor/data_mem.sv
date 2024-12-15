`timescale 1ns/1ps

`define SIM_TIME 160

module data_mem #(
    parameter int DATA_WIDTH    = 16,
    parameter int ADDR_WIDTH    = 16,
    parameter int MEM_DATA_SIZE = 16,
    parameter int MEM_SIZE      = 8
) (
    input clk,
    input mem_wr_en,
    input mem_rd_en,

    input [ADDR_WIDTH-1:0] mem_access_addr,
    input [DATA_WIDTH-1:0] mem_wr_data,

    output [DATA_WIDTH-1:0] mem_rd_data
);

    reg [MEM_DATA_SIZE-1:0] data_memory [MEM_SIZE-1:0];

    wire [2:0] ram_addr = mem_access_addr[2:0];

    static int file;

    initial begin
        //$readmemb("./test/test.data", data_memory);
        $readmemb("test/test.data", data_memory);

        file = $fopen("output/data_mem.o");
        $fmonitor(file, "time = %d\n", $time,
            "\tdata_memory[0] = %b\n", data_memory[0],
            "\tdata_memory[1] = %b\n", data_memory[1],
            "\tdata_memory[2] = %b\n", data_memory[2],
            "\tdata_memory[3] = %b\n", data_memory[3],
            "\tdata_memory[4] = %b\n", data_memory[4],
            "\tdata_memory[5] = %b\n", data_memory[5],
            "\tdata_memory[6] = %b\n", data_memory[6],
            "\tdata_memory[7] = %b\n", data_memory[7]);

        #`SIM_TIME;
        $fclose(file);
    end

    always @(posedge clk) begin
        if (mem_wr_en) begin
            data_memory[ram_addr] <= mem_wr_data;
        end
    end

    assign mem_rd_data = (mem_rd_en) ? data_memory[ram_addr] : {(DATA_WIDTH){1'b0}};

endmodule
