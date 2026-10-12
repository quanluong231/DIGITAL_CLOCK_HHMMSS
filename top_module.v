`timescale 1ns/1ps

module top_module #(
    parameter integer CLK_FREQ    = 50_000_000,
    parameter integer REFRESH_DIV = 50_000
)(
    input  wire clk,
    input  wire reset,
    input  wire enable,

    output wire [6:0] seg,
    output wire [5:0] an,

    // BCD outputs are exposed for simulation/debugging.
    output wire [3:0] hour_tens,
    output wire [3:0] hour_ones,
    output wire [3:0] min_tens,
    output wire [3:0] min_ones,
    output wire [3:0] sec_tens,
    output wire [3:0] sec_ones
);

    wire tick_1s;

    clock_divider #(
        .CLK_FREQ(CLK_FREQ)
    ) u_clock_divider (
        .clk(clk),
        .reset(reset),
        .tick_1s(tick_1s)
    );

    counter_block u_counter_block (
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

    display_block #(
        .REFRESH_DIV(REFRESH_DIV)
    ) u_display_block (
        .clk(clk),
        .reset(reset),
        .hour_tens(hour_tens),
        .hour_ones(hour_ones),
        .min_tens(min_tens),
        .min_ones(min_ones),
        .sec_tens(sec_tens),
        .sec_ones(sec_ones),
        .seg(seg),
        .an(an)
    );

endmodule
