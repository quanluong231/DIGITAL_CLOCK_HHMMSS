`timescale 1ns/1ps

// Generic 6-digit, active-low 7-segment display driver.
// Digit order on an[5:0]: HH:MM:SS.
module display_block #(
    parameter integer REFRESH_DIV = 50_000
)(
    input  wire clk,
    input  wire reset,

    input  wire [3:0] hour_tens,
    input  wire [3:0] hour_ones,
    input  wire [3:0] min_tens,
    input  wire [3:0] min_ones,
    input  wire [3:0] sec_tens,
    input  wire [3:0] sec_ones,

    output reg  [6:0] seg,
    output reg  [5:0] an
);

    reg [31:0] refresh_count;
    reg [2:0]  digit_index;
    reg [3:0]  digit_value;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            refresh_count <= 32'd0;
            digit_index   <= 3'd0;
        end else begin
            if (refresh_count == REFRESH_DIV - 1) begin
                refresh_count <= 32'd0;
                if (digit_index == 3'd5)
                    digit_index <= 3'd0;
                else
                    digit_index <= digit_index + 1'b1;
            end else begin
                refresh_count <= refresh_count + 1'b1;
            end
        end
    end

    always @(*) begin
        an          = 6'b111111;
        digit_value = 4'd0;

        case (digit_index)
            3'd0: begin an = 6'b111110; digit_value = sec_ones;  end
            3'd1: begin an = 6'b111101; digit_value = sec_tens;  end
            3'd2: begin an = 6'b111011; digit_value = min_ones;  end
            3'd3: begin an = 6'b110111; digit_value = min_tens;  end
            3'd4: begin an = 6'b101111; digit_value = hour_ones; end
            3'd5: begin an = 6'b011111; digit_value = hour_tens; end
            default: begin an = 6'b111111; digit_value = 4'd0; end
        endcase

        // abcdefg, active-low
        case (digit_value)
            4'd0: seg = 7'b0000001;
            4'd1: seg = 7'b1001111;
            4'd2: seg = 7'b0010010;
            4'd3: seg = 7'b0000110;
            4'd4: seg = 7'b1001100;
            4'd5: seg = 7'b0100100;
            4'd6: seg = 7'b0100000;
            4'd7: seg = 7'b0001111;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0000100;
            default: seg = 7'b1111111;
        endcase
    end
endmodule
