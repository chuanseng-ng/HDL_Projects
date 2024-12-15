`timescale 1ns/1ps

module register_file #(
    parameter int ARRAY_DATA_WIDTH = 16,
    parameter int ARRAY_SIZE       = 8,
    parameter int DATA_WIDTH       = 16
) (
    input clk,
    input reg_wr_en,

    input [2:0] reg_wr_addr,
    input [2:0] reg_rd_addr_1,
    input [2:0] reg_rd_addr_2,

    input [DATA_WIDTH-1:0] reg_wr_data,

    output [DATA_WIDTH-1:0] reg_rd_data_1,
    output [DATA_WIDTH-1:0] reg_rd_data_2
);

    reg [ARRAY_DATA_WIDTH-1:0] reg_array [ARRAY_SIZE-1:0];

    initial begin
        for (int i = 0; i < ARRAY_SIZE; i++) begin: init_reg_array
            reg_array[i] <= {(DATA_WIDTH){1'b0}};
        end
    end

    always @(posedge clk) begin
        if (reg_wr_en) begin
            reg_array[reg_wr_addr] <= reg_wr_data;
        end
    end

    assign reg_rd_data_1 = reg_array[reg_rd_addr_1];
    assign reg_rd_data_2 = reg_array[reg_rd_addr_2];

endmodule
