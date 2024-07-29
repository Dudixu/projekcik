//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company : AGH University of Krakow
// Create Date : 23.07.2024
// Designers Name : Dawid Mironiuk & Michał Malara
// Module Name : bg_Letters
// Project Name : SZACHY - Projekt zaliczeniowy
// Target Devices : BASYS3
// 
// Description : Moduł odpowiedzialny za połoenie figur na szachownicy.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

module bg_letters 
(
    input  logic clk,
    input  logic rst,
    output logic [10:0] char_addr,
    vga_if.in vga_in   // Wejście interfejsu vga_if
);

import vga_pkg::*;

logic [10:0] char_line_buf;
logic [10:0] char_code_buf; 

always_comb begin
    char_line_buf = vga_in.vcount - 120;
    if(vga_in.hcount%64 >= 28 & vga_in.hcount%64 <= 35) begin
        char_code_buf = "A" + vga_in.hcount [10:6] - 4;
    end
    else if (vga_in.vcount%64 >= 24 & vga_in.vcount%64 <= 40) begin
        char_code_buf = "8" - vga_in.vcount [10:6] + 2;
    end    
    else begin
        char_code_buf = 0;
    end    
end

always_comb begin
    if((vga_in.hcount >= 256 & vga_in.hcount <= 768) & ((vga_in.vcount >= 104 & vga_in.vcount <= 120) | (vga_in.vcount >= 648 & vga_in.vcount <= 664))) begin
        char_addr = {char_code_buf[6:0] , char_line_buf[3:0]};
    end
    else if ((vga_in.vcount >= 128 & vga_in.vcount <= 640) & ((vga_in.hcount >= 236 & vga_in.hcount <= 244) | (vga_in.hcount >= 780 & vga_in.hcount <= 788)))  begin
        char_addr = {char_code_buf[6:0] , char_line_buf[3:0]};
    end
    else begin
        char_addr = 0;
    end
end

endmodule
