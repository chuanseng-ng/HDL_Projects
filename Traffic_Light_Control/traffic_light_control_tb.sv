
`timescale 10ns/10ns

`define DELAY 10

module traffic_light_control_tb #() ();

    localparam int ENDTIME     = 20000;
    localparam int TIMER_LIMIT = 5;

    reg clk, rstb;

    traffic_light_control #(
        .TIMER_LIMIT (TIMER_LIMIT)
    ) u_dut (
        .clk     (clk),
        .rstb    (rstb)
    );

    initial begin: initial_block
        $display("Traffic Light Controller TB");

        $dumpfile("traffic_light_control.vcd");
        $dumpvars();

        clk     <= 1'b0;
        rstb    <= 1'b0;
    end

    initial begin
        main;
    end

    task static main;
        fork
            clock_gen;
            reset_gen;
            operation_process;
            endsimulation;
        join
    endtask

    task static clock_gen;
        begin
            forever #`DELAY clk = ~clk;
        end
    endtask

    task static reset_gen;
        begin
            #(`DELAY*2)
            rstb = 1'b1;
            # 20
            rstb = 1'b0;
            # 25
            rstb = 1'b1;
        end
    endtask

    task static operation_process;
        begin
        end
    endtask

    task static endsimulation;
        begin
            #ENDTIME
            $display("---------------- THE SIMULATION HAS FINISHED -----------------");
            $finish;
        end
    endtask

endmodule
