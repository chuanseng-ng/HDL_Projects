
`timescale 10ns/10ns

`define DELAY 10
`define ENDTIME 20000

module traffic_light_control_tb #() ();

    reg clk, rstb;
    reg input_a, input_b;
    reg output_x, output_y, output_z;

    traffic_light_control #() u_dut (
        .clk      (clk),
        .rstb     (rstb),
        .input_a  (input_a),
        .input_b  (input_b),
        .output_x (output_x),
        .output_y (output_y),
        .output_z (output_z)
    );

    initial begin: initial_block
        $display("Traffic Light Controller TB");

        $dumpfile("traffic_light_control.vcd");
        $dumpvars();

        clk     <= 1'b0;
        rstb    <= 1'b0;
        input_a <= 1'b0;
        input_b <= 1'b0;
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
            rst_b = 1'b1;
            # 20
            rst_b = 1'b0;
            # 25
            rst_b = 1'b1;
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
