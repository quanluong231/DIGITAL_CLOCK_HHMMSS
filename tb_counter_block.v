`timescale 1ns/1ps

module tb_counter_block;
    reg clk;
    reg reset;
    reg enable;
    reg tick_1s;

    wire [3:0] hour_tens;
    wire [3:0] hour_ones;
    wire [3:0] min_tens;
    wire [3:0] min_ones;
    wire [3:0] sec_tens;
    wire [3:0] sec_ones;

    counter_block dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .tick_1s(tick_1s),
        .hour_tens(hour_tens),
        .hour_ones(hour_ones),
        .min_tens(min_tens),
        .min_ones(min_ones),
        .sec_tens(sec_tens),
        .sec_ones(sec_ones)
    );

    always #5 clk = ~clk;

    task pulse_second;
        begin
            tick_1s = 1'b1;
            @(posedge clk);
            #1;
            tick_1s = 1'b0;
            @(posedge clk);
            #1;
        end
    endtask

    task run_seconds;
        input integer n;
        integer i;
        begin
            for (i = 0; i < n; i = i + 1)
                pulse_second;
        end
    endtask

    task check_time;
        input [3:0] ht;
        input [3:0] ho;
        input [3:0] mt;
        input [3:0] mo;
        input [3:0] st;
        input [3:0] so;
        begin
            if ({hour_tens,hour_ones,min_tens,min_ones,sec_tens,sec_ones} !==
                {ht,ho,mt,mo,st,so}) begin
                $display("FAIL: got %0d%0d:%0d%0d:%0d%0d expected %0d%0d:%0d%0d:%0d%0d",
                    hour_tens,hour_ones,min_tens,min_ones,sec_tens,sec_ones,
                    ht,ho,mt,mo,st,so);
                $finish;
            end else begin
                $display("PASS: %0d%0d:%0d%0d:%0d%0d",
                    hour_tens,hour_ones,min_tens,min_ones,sec_tens,sec_ones);
            end
        end
    endtask

    initial begin
        $dumpfile("sim/dump.vcd");
        $dumpvars(0, tb_counter_block);

        clk     = 1'b0;
        reset   = 1'b1;
        enable  = 1'b1;
        tick_1s = 1'b0;

        #12;
        reset = 1'b0;
        check_time(0,0,0,0,0,0);

        run_seconds(60);
        check_time(0,0,0,1,0,0);       // 00:01:00

        run_seconds(3540);
        check_time(0,1,0,0,0,0);       // 01:00:00

        run_seconds(82800);
        check_time(0,0,0,0,0,0);       // 24 h rollover

        enable = 1'b0;
        pulse_second;
        check_time(0,0,0,0,0,0);       // paused

        $display("ALL TESTS PASSED");
        $finish;
    end
endmodule
