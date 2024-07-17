`timescale 1 ns / 1 ps

module char_rom_16x16 (
    input  logic  clk,
    input  logic [7:0] char_xy,
    output logic [6:0] char_code
);

import vga_pkg::*;
reg [0:15][7:0] char_str1 =  "Linia poczatkowa";
reg [0:15][7:0] char_str2 =  "i              w";
reg [0:15][7:0] char_str3 =  "n              o";
reg [0:15][7:0] char_str4 =  "i              k";
reg [0:15][7:0] char_str5 =  "a              t";
reg [0:15][7:0] char_str6 =  "               a";
reg [0:15][7:0] char_str7 =  "p              z";
reg [0:15][7:0] char_str8 =  "o   ________   c";
reg [0:15][7:0] char_str9 =  "c              o";
reg [0:15][7:0] char_str10 = "z              p";
reg [0:15][7:0] char_str11 = "a               ";
reg [0:15][7:0] char_str12 = "t              a";
reg [0:15][7:0] char_str13 = "k              i";
reg [0:15][7:0] char_str14 = "o              n";
reg [0:15][7:0] char_str15 = "w              i";
reg [0:15][7:0] char_str16 = "awoktazcop ainiL";



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
        8: char_line_sel = char_str9;
        9: char_line_sel = char_str10;
        10: char_line_sel = char_str11;
        11: char_line_sel = char_str12;
        12: char_line_sel = char_str13;
        13: char_line_sel = char_str14;
        14: char_line_sel = char_str15;
        15: char_line_sel = char_str16;
    endcase
end
always_ff @(posedge clk) begin

    char_code <= char_line_sel[char_xy[3:0]][6:0];
end

endmodule