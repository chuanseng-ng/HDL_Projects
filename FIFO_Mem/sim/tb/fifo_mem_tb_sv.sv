/*
    Testbench for FIFO Memory module
*/

`timescale 10ps/10ps

`define DELAY 10

module fifo_mem_tb_sv #()();

    parameter int ENDTIME    = 2000;
    parameter int DATA_WIDTH = 16;
    parameter int OSTD_NUM   = 18;
    parameter int MAX_INT    = OSTD_NUM;
    parameter int ADDR_WIDTH = 8;
    parameter int MEM_SIZE   = 64;
    parameter int MAX_ADDR   = 32;

    reg clk;
    reg rst_n;
    reg trans_write, trans_read;

    reg [DATA_WIDTH-1:0] data_in;

    wire [DATA_WIDTH-1:0] data_out;

    wire fifo_empty, fifo_full, fifo_threshold, fifo_overflow, fifo_underflow;

    integer i;

    fifo_mem #(
        .DATA_WIDTH      (DATA_WIDTH),
        .OSTD_NUM        (OSTD_NUM),
        .THRESHOLD_VALUE (OSTD_NUM/2)
    ) u_tb (
        .clk_in        (clk),
        .areset_b      (rst_n),
        .trans_read    (trans_read),
        .trans_write   (trans_write),
        .data_in       (data_in),
        .data_out      (data_out),
        .full_ind      (fifo_full),
        .empty_ind     (fifo_empty),
        .overflow_ind  (fifo_overflow),
        .underflow_ind (fifo_underflow),
        .threshold_ind (fifo_threshold)
    );

    initial begin
        clk         = 1'b0;
        rst_n       = 1'b0;
        trans_write = 1'b0;
        trans_read  = 1'b0;
        data_in     = {(DATA_WIDTH){1'b0}};
    end

    initial begin
        $dumpfile("fifo_mem.vcd");
        $dumpvars();
        main;
    end

    task static main;
        fork
            clock_gen;
            reset_gen;
            operation_process;
            debug_fifo;
            endsimulation;
        join
    endtask

    task static clock_gen;
        begin
            forever #`DELAY clk = !clk;
        end
    endtask

    task static reset_gen;
        begin
            #(`DELAY*2)
            rst_n = 1'b1;
            # 18
            rst_n = 1'b0;
            # 20
            rst_n = 1'b1;
        end
    endtask

    task static operation_process;
        begin
            for (i = 0; i < MAX_INT - 1; i++) begin: write_part
                #(`DELAY*5)
                trans_write = 1'b1;
                data_in     = data_in + 1'b1;
                #(`DELAY*2)
                trans_write = 1'b0;
            end
            #(`DELAY)
            for (i = 0; i < MAX_INT - 1; i++) begin: read_part
                #(`DELAY*2)
                trans_read = 1'b1;
                #(`DELAY*2)
                trans_read = 1'b0;
            end
        end
    endtask

    task static debug_fifo;
        begin
            $display("----------------------------------------------");
            $display("------------------   -----------------------");
            $display("----------- SIMULATION RESULT ----------------");
            $display("--------------       -------------------");
            $display("----------------     ---------------------");
            $display("----------------------------------------------");
            $monitor("TIME = %d, wr = %b, rd = %b, data_in = %h", $time, trans_write, trans_read, data_in);
        end
    endtask

    reg [ADDR_WIDTH-1:0] waddr, raddr;
    reg [ADDR_WIDTH-1:0] tb_mem [MEM_SIZE-1:0];

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            waddr <= {(ADDR_WIDTH){1'b0}};
        end else begin
            if (trans_write) begin
                tb_mem[waddr] <= data_in;
                waddr         <= waddr + 1;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        $display("TIME = %d, data_out = %d, mem = %d, raddr = %d", $time, data_out, tb_mem[raddr], raddr);
        if (~rst_n) begin
            raddr <= {(ADDR_WIDTH){1'b0}};
        end else begin
            if (trans_read && (~fifo_empty)) begin
                raddr <= raddr + 1;

                // Simulation result check
                if (tb_mem[raddr] == data_out) begin
                    $display("=== PASS ===== PASS ==== PASS ==== PASS ===");
                    if (raddr == MAX_INT-1) begin
                        $finish;
                    end
                end else begin
                    $display ("=== FAIL ==== FAIL ==== FAIL ==== FAIL ===");
                    $display("-------------- THE SIMUALTION FINISHED ------------");
                    $finish;
                end
            end
        end
    end

    task static endsimulation;
        begin
            #ENDTIME
            $display("-------------- THE SIMUALTION FINISHED ------------");
            $finish;
        end
    endtask

endmodule
