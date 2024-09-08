// Sub-module -- Memory Array Storage
module memory_array #(
    parameter int DATA_WIDTH      = 32,                                   //! Transaction data width
    parameter int OSTD_NUM        = 8,                                    //! Number of outstanding transactions
    parameter int THRESHOLD_VALUE = OSTD_NUM/2,                           //! Minimum number of expected values in FIFO
    parameter int PTR_SIZE        = (OSTD_NUM > 1) ? $clog2(OSTD_NUM) : 1 //! Set pointer size to be 2^N = OSTD_NUM - Unused parameter
) (
    input clk_in,       //! Clock source
    input areset_b,     //! Reset source - Active low
    input fifo_renable, //! FIFO read enable
    input fifo_wenable, //! FIFO write enable

    input [DATA_WIDTH-1:0] data_in,   //! Transaction data input (Write)
    input [OSTD_NUM-1:0]   read_ptr,  //! Read pointer
    input [OSTD_NUM-1:0]   write_ptr, //! Write pointer

    output [DATA_WIDTH-1:0] data_out //! Transaction data output (Read)
);
    reg [DATA_WIDTH-1:0] [OSTD_NUM-1:0] data_reg; //! Memory array

    always @(posedge clk_in or negedge areset_b) begin: mem_array_storage
        if (~areset_b) begin
            for (int i = 0; i < OSTD_NUM-1; i++) begin
                data_reg[i] <= {(DATA_WIDTH){1'b0}};
            end
        end else begin
            if (fifo_wenable) begin
                data_reg[write_ptr] <= data_in;
            end
        end
    end

    generate
        genvar i;
        for(i = 0; i < OSTD_NUM; i = i + 1) begin: gen_register_dump
            wire [DATA_WIDTH-1:0] temp_data_reg;
            assign temp_data_reg = data_reg[i];
        end
    endgenerate

    assign data_out = (fifo_renable) ? data_reg[read_ptr] : 'd0;

endmodule
