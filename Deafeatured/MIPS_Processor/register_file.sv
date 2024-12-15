// Sub module - Register File for MIPS Processor
module register_file #(
    parameter int DATA_WIDTH = 16,
    parameter int REG_NUM    = 8
) (
    input clk_in,
    input reg_wr_en,

    input [2:0]            reg_wr_dest,
    input [2:0]            reg_rd_addr_1,
    input [2:0]            reg_rd_addr_2,
    input [DATA_WIDTH-1:0] reg_wr_data,

    output [DATA_WIDTH-1:0] reg_rd_data_1,
    output [DATA_WIDTH-1:0] reg_rd_data_2
);
    integer i;

    reg [DATA_WIDTH-1:0] reg_array [REG_NUM-1:0];

    initial begin
        for (i = 0; i < REG_NUM; i++) begin
            reg_array[i] <= {(DATA_WIDTH){1'b0}};
        end
    end

    always @(posedge clk_in) begin
        if (reg_wr_en) begin
            reg_array[reg_wr_dest] <= reg_wr_data;
        end
    end

    assign reg_rd_data_1 = reg_array[reg_rd_addr_1];
    assign reg_rd_data_2 = reg_array[reg_rd_addr_2];
endmodule
