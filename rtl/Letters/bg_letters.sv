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
    output logic [10:0] char_addr,
    input logic [10:0] hcount,
    input logic [10:0] vcount 
    //vga_if.in vga_in   // Wejście interfejsu vga_if
);

import vga_pkg::*;

logic [3:0] char_line_buf; //warning
logic [10:0] char_code_buf; 

always_comb begin
    char_line_buf = vcount - 120;
    if(hcount%64 >= 28 & hcount%64 <= 35) begin
        char_code_buf = "A" + hcount [10:6] - 4;
    end
    else if (vcount%64 >= 24 & vcount%64 <= 40) begin
        char_code_buf = "8" - vcount [10:6] + 2;
    end    
    else begin
        char_code_buf = 0;
    end    
end

always_comb begin
    if((hcount >= 256 & hcount <= 768) & ((vcount >= 104 & vcount <= 120) | (vcount >= 648 & vcount <= 664))) begin
        char_addr = {char_code_buf[6:0] , char_line_buf[3:0]};
    end
    else if ((vcount >= 128 & vcount <= 640) & ((hcount >= 236 & hcount <= 244) | (hcount >= 780 & hcount <= 788)))  begin
        char_addr = {char_code_buf[6:0] , char_line_buf[3:0]};
    end
    else begin
        char_addr = 0;
    end
end

endmodule
