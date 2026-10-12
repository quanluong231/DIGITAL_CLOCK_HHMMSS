`timescale 1ns/1ps

module counter_block (
    input  wire clk,
    input  wire reset,
    input  wire enable,
    input  wire tick_1s,

    output reg [3:0] hour_tens,
    output reg [3:0] hour_ones,
    output reg [3:0] min_tens,
    output reg [3:0] min_ones,
    output reg [3:0] sec_tens,
    output reg [3:0] sec_ones
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hour_tens <= 4'd0;
            hour_ones <= 4'd0;
            min_tens  <= 4'd0;
            min_ones  <= 4'd0;
            sec_tens  <= 4'd0;
            sec_ones  <= 4'd0;
        end else if (enable && tick_1s) begin
            // Seconds: 00 -> 59
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;

                if (sec_tens == 4'd5) begin
                    sec_tens <= 4'd0;

                    // Minutes: 00 -> 59
                    if (min_ones == 4'd9) begin
                        min_ones <= 4'd0;

                        if (min_tens == 4'd5) begin
                            min_tens <= 4'd0;

                            // Hours: 00 -> 23
                            if ((hour_tens == 4'd2) && (hour_ones == 4'd3)) begin
                                // 23:59:59 -> 00:00:00
                                hour_tens <= 4'd0;
                                hour_ones <= 4'd0;
                            end else if (hour_ones == 4'd9) begin
                                hour_ones <= 4'd0;
                                hour_tens <= hour_tens + 1'b1;
                            end else begin
                                hour_ones <= hour_ones + 1'b1;
                            end
                        end else begin
                            min_tens <= min_tens + 1'b1;
                        end
                    end else begin
                        min_ones <= min_ones + 1'b1;
                    end
                end else begin
                    sec_tens <= sec_tens + 1'b1;
                end
            end else begin
                sec_ones <= sec_ones + 1'b1;
            end
        end
    end
endmodule
