`timescale 1 ns / 1 ps

module figure_position (
    input  logic  clk,
    input  logic [7:0] figure_xy,
    output logic [5:0] figure_code
);

import vga_pkg::*;
/*
reg [0:15][7:0] char_str1 =  "10,9 ,8 ,11,12,8 ,9 ,10";
reg [0:15][7:0] char_str2 =  "7 ,7 ,7 ,7 ,7 ,7 ,7 ,7";
reg [0:15][7:0] char_str3 =  "0 ,0 ,0 ,0 ,0 ,0 ,0 ,0";
reg [0:15][7:0] char_str4 =  "0 ,0 ,0 ,0 ,0 ,0 ,0 ,0";
reg [0:15][7:0] char_str5 =  "0 ,0 ,0 ,0 ,0 ,0 ,0 ,0";
reg [0:15][7:0] char_str6 =  "0 ,0 ,0 ,0 ,0 ,0 ,0 ,0";
reg [0:15][7:0] char_str7 =  "1 ,1 ,1 ,1 ,1 ,1 ,1 ,1";
reg [0:15][7:0] char_str8 =  "4 ,3 ,2 ,5 ,6 ,2 ,3 ,4";



reg [0:15][7:0] char_line_sel;
always_comb begin
    case (char_xy[7:4])
        0: char_line_sel = char_str1;
        1: char_line_sel = char_str2;
        2: char_line_sel = char_str3;
        3: char_line_sel = char_str4;
        4: char_line_sel = char_str5;
        5: char_line_sel = char_str6;
        6: char_line_sel = char_str7;
        7: char_line_sel = char_str8;
    endcase
end*/
always_ff @(posedge clk) begin

    figure_code <= 1;
end

endmodule