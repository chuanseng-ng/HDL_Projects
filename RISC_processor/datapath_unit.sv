module datapath_unit #(
    parameter int PC_WIDTH   = 16,
    parameter int ADDR_WIDTH = 3,
    parameter int DATA_WIDTH = 16,
    parameter int MEM_SIZE   = 15,
    parameter int DATA_SIZE  = 8,
    parameter int ARRAY_SIZE = 8
) (
    input clk,

    input mem_rd,
    input mem_wr,

    input jump,
    input beq,
    input bne,
    input alu_src,
    input reg_dest,
    input mem_to_reg,
    input reg_wr,

    input [1:0] alu_op,

    output [3:0] opcode
);

    reg [PC_WIDTH-1:0] pc_current;

    wire [PC_WIDTH-1:0] pc_next;
    wire [PC_WIDTH-1:0] pc2;
    wire [PC_WIDTH-1:0] instruction;

    wire [ADDR_WIDTH-1:0] reg_wr_addr;
    wire [ADDR_WIDTH-1:0] reg_rd_addr_1;
    wire [ADDR_WIDTH-1:0] reg_rd_addr_2;

    wire [DATA_WIDTH-1:0] reg_wr_data;
    wire [DATA_WIDTH-1:0] reg_rd_data_1;
    wire [DATA_WIDTH-1:0] reg_rd_data_2;
    wire [DATA_WIDTH-1:0] rd_data2;
    wire [DATA_WIDTH-1:0] mem_rd_data;

    wire [DATA_WIDTH-1:0] ext_im;
    wire [DATA_WIDTH-1:0] read_data2;

    wire [2:0] alu_ctrl;

    wire [PC_WIDTH-1:0] alu_out;

    wire zero_flag;

    wire [PC_WIDTH-1:0] pc_j;
    wire [PC_WIDTH-1:0] pc_beq;
    wire [PC_WIDTH-1:0] pc_2beq;
    wire [PC_WIDTH-1:0] pc_2bne;
    wire [PC_WIDTH-1:0] pc_bne;

    wire beq_ctrl;
    wire bne_ctrl;

    wire [12:0] jump_shift;

    initial begin
        pc_current <= {(PC_WIDTH){1'b0}};
    end

    always @(posedge clk) begin
        pc_current <= pc_next;
    end

    assign pc2 = pc_current + 16'd2;

    instruction_mem #(
        .PC_WIDTH      (PC_WIDTH),   // 16 bits
        .MEM_DATA_SIZE (DATA_WIDTH), // 16 bits
        .MEM_SIZE      (MEM_SIZE)    // 15 bits
    ) u_instruction_mem(
        .pc_in       (pc_current),
        .instruction (instruction)
    );

    assign jump_shift = {instruction[11:0], 1'b0};

    assign reg_wr_addr = (reg_dest) ? instruction[5:3] : instruction[8:6];

    assign reg_rd_addr_1 = instruction[11:9];
    assign reg_rd_addr_2 = instruction[8:6];

    register_file #(
        .ARRAY_DATA_WIDTH (DATA_WIDTH), // 16 bits
        .ARRAY_SIZE       (ARRAY_SIZE), // 8 bits
        .DATA_WIDTH       (DATA_WIDTH)  // 16 bits
    ) u_register_file (
        .clk           (clk),
        .reg_wr_en     (reg_wr),
        .reg_wr_addr   (reg_wr_addr),
        .reg_wr_data   (reg_wr_data),
        .reg_rd_addr_1 (reg_rd_addr_1),
        .reg_rd_addr_2 (reg_rd_addr_2),
        .reg_rd_data_1 (reg_rd_data_1),
        .reg_rd_data_2 (reg_rd_data_2)
    );

    assign ext_im = {{10{instruction[5]}}, instruction[5:0]};

    alu_ctrl_unit #() u_alu_ctrl_unit (
        .alu_op      (alu_op),
        .opcode      (instruction[15:12]),
        .alu_counter (alu_ctrl)
    );

    assign read_data2 = (alu_src) ? ext_im : reg_rd_data_2;

    alu_unit #(
        .PC_WIDTH (PC_WIDTH) // 16 bits
    ) u_alu_unit (
        .alu_in_a   (reg_rd_data_1),
        .alu_in_b   (read_data2),
        .alu_ctrl   (alu_ctrl),
        .alu_result (alu_out),
        .zero       (zero_flag)
    );

    assign pc_beq = pc2 + {ext_im[14:0], 1'b0};
    assign pc_bne = pc2 + {ext_im[14:0], 1'b0};

    assign beq_ctrl = beq & zero_flag;
    assign bne_ctrl = bne & (~zero_flag);

    assign pc_2beq = (beq_ctrl) ? pc_beq : pc2;
    assign pc_2bne = (bne_ctrl) ? pc_bne : pc_2beq;

    assign pc_j = {pc2[15:13], jump_shift};

    assign pc_next = (jump) ? pc_j : pc_2bne;

    data_mem #(
        .DATA_WIDTH    (DATA_WIDTH), // 16 bits
        .ADDR_WIDTH    (PC_WIDTH),   // 16 bits
        .MEM_DATA_SIZE (DATA_WIDTH), // 16 bits
        .MEM_SIZE      (DATA_SIZE)   // 8 bits
    ) u_data_mem (
        .clk             (clk),
        .mem_access_addr (alu_out),
        .mem_wr_data     (reg_rd_data_2),
        .mem_wr_en       (mem_wr),
        .mem_rd_en       (mem_rd),
        .mem_rd_data     (mem_rd_data)
    );

    assign reg_wr_data = (mem_to_reg) ? mem_rd_data : alu_out;

    assign opcode = instruction[15:12];

endmodule
