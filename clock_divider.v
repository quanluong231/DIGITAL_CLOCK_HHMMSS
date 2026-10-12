`timescale 1ns/1ps

module clock_divider #(
    parameter integer CLK_FREQ = 50_000_000
)(
    input  wire clk,
    input  wire reset,
    output reg  tick_1s
);
    reg [31:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count   <= 32'd0;
            tick_1s <= 1'b0;
        end else begin
            if (count == CLK_FREQ - 1) begin
                count   <= 32'd0;
                tick_1s <= 1'b1;
            end else begin
                count   <= count + 1'b1;
                tick_1s <= 1'b0;
            end
        end
    end
endmodule
