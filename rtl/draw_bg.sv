//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company : AGH University of Krakow
// Create Date : 23.07.2024
// Designers Name : Piotr Kaczmarczyk
// MODIFIED BY : Dawid Mironiuk & Michał Malara
// Module Name : draw_bg
// Project Name : SZACHY - Projekt zaliczeniowy
// Target Devices : BASYS3
// 
// Description : Moduł odpowiedzialny za rysownie tła ekranu.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`timescale 1 ns / 1 ps
 
module draw_bg 
(
    input  logic clk,
    input  logic rst,
    input  logic [7:0] frame_pixels,
    vga_if.in vga_in,    
    vga_if.out vga_out   
);

import vga_pkg::*;

// LOCAL VARIABLES AND SIGNALES ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

logic [11:0] rgb_nxt;
localparam LIGHT_COLOR = 12'h5_8_5;
localparam DARK_COLOR = 12'hF_F_C;
vga_if int2();

 // INTERNAL LOGIC ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

delay #(
    .WIDTH(38),
    .CLK_DEL(1)
) u_delay(
    .clk(clk),
    .rst(rst),
    .din({vga_in.vcount, vga_in.vsync, vga_in.vblnk, vga_in.hcount, vga_in.hsync, vga_in.hblnk, vga_in.rgb}),
    .dout({int2.vcount, int2.vsync, int2.vblnk, int2.hcount, int2.hsync, int2.hblnk, int2.rgb})
);


always_ff @(posedge clk) begin : bg_ff_blk
    if (rst) begin
        vga_out.vcount <= '0;
        vga_out.vsync  <= '0;
        vga_out.vblnk  <= '0;
        vga_out.hcount <= '0;
        vga_out.hsync  <= '0;
        vga_out.hblnk  <= '0;
        vga_out.rgb    <= '0;
    end else begin
        vga_out.vcount <= int2.vcount;
        vga_out.vsync  <= int2.vsync;
        vga_out.vblnk  <= int2.vblnk;
        vga_out.hcount <= int2.hcount;
        vga_out.hsync  <= int2.hsync;
        vga_out.hblnk  <= int2.hblnk;
        vga_out.rgb    <= rgb_nxt;
    end
end

always_comb begin : bg_comb_blk
    
    // BLANKING REGION ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    if (int2.vblnk || int2.hblnk) begin             // Blanking region:
        rgb_nxt = 12'h0_0_0;                        // - make it it black.
    end 
    
    // ACTIVE REGION ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    else begin             

        // OBRAMOWANIE EKRANU ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if (int2.vcount == 0)                       // TOP EDGE - YELLOW //
            rgb_nxt = 12'hf_f_0;                    
        else if (int2.vcount == VER_PIXELS - 1)     // BOTTOM EDGE - RED //
            rgb_nxt = 12'hf_0_0;                    
        else if (int2.hcount == 0)                  // LEFT EDGE - GREEN //
            rgb_nxt = 12'h0_f_0;                    
        else if (int2.hcount == HOR_PIXELS - 1)     // RIGHT EDGE - BLUE //
            rgb_nxt = 12'h0_0_f;                    
       
        // LINIJKA POMOCNICZA /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         
          //else if(int2.hcount%8 == 4 & int2.vcount >= 118)
                //rgb_nxt = 12'h0_0_0;

        // RAMKA SZACHOWNICY /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       
       else if ((int2.hcount >= 224 & int2.hcount < 256) & int2.vcount >= 96 & int2.vcount < 672)
            if(frame_pixels[7 - (int2.hcount - 5)%8] == 1'b1)
                rgb_nxt = 12'hf_f_f;
             else
                rgb_nxt = 12'h3_2_1;

        else if ((int2.hcount >= 768 & int2.hcount < 800) & int2.vcount >= 96 & int2.vcount < 672)
            if(frame_pixels[7 - (int2.hcount - 5)%8] == 1'b1)
                rgb_nxt = 12'hf_f_f;
            else
                rgb_nxt = 12'h3_2_1;

        else if ((int2.hcount >= 256 & int2.hcount < 768) & int2.vcount >= 96 & int2.vcount < 128)
            if(frame_pixels[7 - (int2.hcount - 4)%8] == 1'b1)
                rgb_nxt = 12'hf_f_f;
            else
                rgb_nxt = 12'h3_2_1;

        else if ((int2.hcount >= 256 & int2.hcount < 768) & int2.vcount >= 640 & int2.vcount < 672)
            if(frame_pixels[7 - (int2.hcount - 4)%8] == 1'b1)
                rgb_nxt = 12'hf_f_f;
            else
                rgb_nxt = 12'h3_2_1;

        // POLA SZACHOWNICY /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        else if ((int2.hcount >= 256 & int2.hcount < 768 & int2.vcount >= 128 & int2.vcount < 640))
            if((int2.hcount - 256)%128 <= 63 & (int2.vcount)%128 <= 63 | (int2.hcount - 256)%128 >= 64 & (int2.vcount)%128 >= 64)
                rgb_nxt = DARK_COLOR;
            else
                rgb_nxt = LIGHT_COLOR;
        
        else                                     // KOLOR TŁA //
            rgb_nxt = 12'h8_8_8;                
    end
end

endmodule

