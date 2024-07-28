//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company : AGH University of Krakow
// Create Date : 28.07.2024
// Designers Name : Dawid Mironiuk & Michał Malara
// Module Name : vga_if
// Project Name : SZACHY - Projekt zaliczeniowy
// Target Devices : BASYS3
// 
// Description : 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

interface vga_if();

    logic [10:0] vcount;
    logic        vsync;
    logic        vblnk;
    logic [10:0] hcount;
    logic        hsync;
    logic        hblnk;
    logic [11:0] rgb;

    modport in  
    (
        input vsync, vcount, vblnk, hcount, hsync, hblnk, rgb
    );
    
    modport out 
    (
        output vsync, vcount, vblnk, hcount, hsync, hblnk, rgb
    );

endinterface


