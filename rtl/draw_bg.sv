/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Draw background.
 */


`timescale 1 ns / 1 ps
 
module draw_bg (
    input  logic clk,
    input  logic rst,
    input  logic [7:0] frame_pixels,
    vga_if.in vga_in,    // Wejście interfejsu vga_if
    vga_if.out vga_out   // Wyjście interfejsu vga_if
);
import vga_pkg::*;



/**
 * Local variables and signals
 */

logic [11:0] rgb_nxt;
localparam LIGHT_COLOR = 12'h5_8_5;
localparam DARK_COLOR = 12'hF_F_C;

/**
 * Internal logic
 */

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
        vga_out.vcount <= vga_in.vcount;
        vga_out.vsync  <= vga_in.vsync;
        vga_out.vblnk  <= vga_in.vblnk;
        vga_out.hcount <= vga_in.hcount;
        vga_out.hsync  <= vga_in.hsync;
        vga_out.hblnk  <= vga_in.hblnk;
        vga_out.rgb    <= rgb_nxt;
    end
end

always_comb begin : bg_comb_blk
    if (vga_in.vblnk || vga_in.hblnk) begin             // Blanking region:
        rgb_nxt = 12'h0_0_0;                    // - make it it black.
    end else begin                              // Active region:
        if (vga_in.vcount == 0)                     // - top edge:
            rgb_nxt = 12'hf_f_0;                // - - make a yellow line.
        else if (vga_in.vcount == VER_PIXELS - 1)   // - bottom edge:
            rgb_nxt = 12'hf_0_0;                // - - make a red line.
        else if (vga_in.hcount == 0)                // - left edge:
            rgb_nxt = 12'h0_f_0;                // - - make a green line.
        else if (vga_in.hcount == HOR_PIXELS - 1)   // - right edge:
            rgb_nxt = 12'h0_0_f;                // - - make a blue line
        // Add your code here.
        //else if(vga_in.hcount%64 <= 1 & (vga_in.vcount%64 <= 1))
        //      rgb_nxt = 12'h0_0_0;
         // else if(vga_in.hcount%8 == 0)
           //     rgb_nxt = 12'h0_0_0;
        // Ramka
        else if ((vga_in.hcount >= 224 & vga_in.hcount < 256) & vga_in.vcount >= 96 & vga_in.vcount < 672)
                rgb_nxt = 12'h3_2_1;
        else if ((vga_in.hcount >= 768 & vga_in.hcount < 800) & vga_in.vcount >= 96 & vga_in.vcount < 672)
                rgb_nxt = 12'h3_2_1;
        else if ((vga_in.hcount >= 256 & vga_in.hcount < 768) & vga_in.vcount >= 96 & vga_in.vcount < 128)
            if(frame_pixels[vga_in.hcount%8] == 1)
                rgb_nxt = 12'hf_f_f;
            else
                rgb_nxt = 12'h3_2_1;

        else if ((vga_in.hcount >= 256 & vga_in.hcount < 768) & vga_in.vcount >= 640 & vga_in.vcount < 672)
                rgb_nxt = 12'h3_2_1;
        // Pola
        else if ((vga_in.hcount >= 256 & vga_in.hcount < 768 & vga_in.vcount >= 128 & vga_in.vcount < 640))
            if((vga_in.hcount - 256)%128 <= 63 & (vga_in.vcount)%128 <= 63 | (vga_in.hcount - 256)%128 >= 64 & (vga_in.vcount)%128 >= 64)
                rgb_nxt = DARK_COLOR;
            else
                rgb_nxt = LIGHT_COLOR;
        
        else                                    // The rest of active display pixels:
            rgb_nxt = 12'h8_8_8;                // - fill with gray.
    end
end

endmodule
