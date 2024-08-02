//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company : AGH University of Krakow
// Create Date : 23.07.2024
// Designers Name : Dawid Mironiuk & Michał Malara
// Module Name : figure_position
// Project Name : SZACHY - Projekt zaliczeniowy
// Target Devices : BASYS3
// 
// Description : Moduł odpowiedzialny za połoenie figur na szachownicy.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

module figure_position 
(
    input  logic  clk,
    input  logic [5:0] figure_xy,
    output logic [3:0] figure_code
);

import vga_pkg::*;

// MATRYCA ROZMIESZCZENIA FIGUR NA SZACHOWNICY ///////////////////////////////////////////////////////////////////////////////////////

reg [0:7][3:0] board_8 = {4'hA, 4'h9, 4'h8, 4'hB, 4'hC, 4'h8, 4'h9, 4'hA};  
reg [0:7][3:0] board_7 = {4'h7, 4'h7, 4'h7, 4'h7, 4'h7, 4'h7, 4'h7, 4'h7};  
reg [0:7][3:0] board_6 = {4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0};  
reg [0:7][3:0] board_5 = {4'h0, 4'h0, 4'hD, 4'hD, 4'h0, 4'h0, 4'h0, 4'h0};  
reg [0:7][3:0] board_4 = {4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0};  
reg [0:7][3:0] board_3 = {4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0};  
reg [0:7][3:0] board_2 = {4'h1, 4'h1, 4'h1, 4'h1, 4'h1, 4'h1, 4'h1, 4'h1};  
reg [0:7][3:0] board_1 = {4'h4, 4'h3, 4'h2, 4'h5, 4'h6, 4'h2, 4'h3, 4'h4};  


reg [0:7][3:0] board_line_sel;

always_comb begin
    case (figure_xy[5:3])
        0: board_line_sel = board_8;
        1: board_line_sel = board_7;
        2: board_line_sel = board_6;
        3: board_line_sel = board_5;
        4: board_line_sel = board_4;
        5: board_line_sel = board_3;
        6: board_line_sel = board_2;
        7: board_line_sel = board_1;
    endcase
end

always_ff @(posedge clk) begin
    figure_code <= board_line_sel[figure_xy[2:0]][3:0];
end

endmodule
