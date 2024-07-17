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
    vga_if.in vga_in,    // Wejście interfejsu vga_if
    vga_if.out vga_out   // Wyjście interfejsu vga_if
);
import vga_pkg::*;



/**
 * Local variables and signals
 */

logic [11:0] rgb_nxt;
localparam LETTER_COLOR = 12'hB_D_7;;

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
        else if ((vga_in.hcount >= 230 & vga_in.hcount <= 350 & vga_in.vcount >= 100 & vga_in.vcount <= 220) & ((vga_in.hcount - 230)*(vga_in.hcount - 230))+((vga_in.vcount - 220)*(vga_in.vcount - 220)) <= 14400 & ((vga_in.hcount - 230)*(vga_in.hcount - 230))+((vga_in.vcount - 220)*(vga_in.vcount - 220)) >= 6400)
            rgb_nxt = LETTER_COLOR;
        else if ((vga_in.hcount >= 230 & vga_in.hcount <= 350 & vga_in.vcount >= 380 & vga_in.vcount <= 500) & ((vga_in.hcount - 230)*(vga_in.hcount - 230))+((vga_in.vcount - 380)*(vga_in.vcount - 380)) <= 14400 & ((vga_in.hcount - 230)*(vga_in.hcount - 230))+((vga_in.vcount - 380)*(vga_in.vcount - 380)) >= 6400)
            rgb_nxt = LETTER_COLOR;
        else if ((vga_in.hcount >= 310 & vga_in.hcount <= 350 & vga_in.vcount >= 220 & vga_in.vcount <= 380))
            rgb_nxt = LETTER_COLOR;
        else if ((vga_in.hcount >= 140 & vga_in.hcount <= 230 & vga_in.vcount >= 100 & vga_in.vcount <= 140))
            rgb_nxt = LETTER_COLOR;
        else if ((vga_in.hcount >= 140 & vga_in.hcount <= 230 & vga_in.vcount >= 460 & vga_in.vcount <= 500))
            rgb_nxt = LETTER_COLOR;
        else if ((vga_in.hcount >= 100 & vga_in.hcount <= 140 & vga_in.vcount >= 100 & vga_in.vcount <= 500))
            rgb_nxt = LETTER_COLOR;
        else if ((((vga_in.hcount-1)%4) >= 2 & vga_in.hcount <= 140 & vga_in.vcount >= 100 & vga_in.vcount <= 500))
            rgb_nxt = 12'h0_0_0;
        else if ((vga_in.hcount == 65 ))
            rgb_nxt = LETTER_COLOR;
            // Litera M ukos
        else if ((vga_in.hcount >= 450 & vga_in.hcount <= 490 & vga_in.vcount >= 100 & vga_in.vcount <= 500))
            rgb_nxt = LETTER_COLOR;
        else if ((vga_in.hcount >= 660 & vga_in.hcount <= 700 & vga_in.vcount >= 100 & vga_in.vcount <= 500))
            rgb_nxt = LETTER_COLOR;
        else if ((vga_in.hcount >= 490 & vga_in.hcount <= 575 & vga_in.hcount >= vga_in.vcount + 340 & vga_in.hcount <= vga_in.vcount + 390))
            rgb_nxt = LETTER_COLOR;
        else if ((vga_in.hcount >= 575 & vga_in.hcount <= 660 & vga_in.hcount + vga_in.vcount <= 810 & vga_in.hcount + vga_in.vcount >= 760))
            rgb_nxt = LETTER_COLOR; 
        
            /*/ //Litera M zaoblona
        else if ((vga_in.hcount >= 450 & vga_in.hcount <= 575 & vga_in.vcount >= 100 & vga_in.vcount <= 174) & ((vga_in.hcount - 522)*(vga_in.hcount - 522))+((vga_in.vcount - 174)*(vga_in.vcount - 174)) <= 5476 & ((vga_in.hcount - 522)*(vga_in.hcount - 522))+((vga_in.vcount - 174)*(vga_in.vcount - 174)) >= 1156)
            rgb_nxt = 12'h0_4_3;
        else if ((vga_in.hcount >= 575 & vga_in.hcount <= 700 & vga_in.vcount >= 100 & vga_in.vcount <= 174) & ((vga_in.hcount - 626)*(vga_in.hcount - 626))+((vga_in.vcount - 174)*(vga_in.vcount - 174)) <= 5476 & ((vga_in.hcount - 626)*(vga_in.hcount - 626))+((vga_in.vcount - 174)*(vga_in.vcount - 174)) >= 1156)
            rgb_nxt = 12'h0_4_3;
        else if ((vga_in.hcount >= 450 & vga_in.hcount <= 488 & vga_in.vcount >= 174 & vga_in.vcount <= 500))
            rgb_nxt = 12'h0_4_3;
        else if ((vga_in.hcount >= 660 & vga_in.hcount <= 700 & vga_in.vcount >= 174 & vga_in.vcount <= 500))
            rgb_nxt = 12'h0_4_3;
        else if ((vga_in.hcount >= 556 & vga_in.hcount <= 592 & vga_in.vcount >= 174 & vga_in.vcount <= 300))
            rgb_nxt = 12'h0_4_3; /*/
        else                                    // The rest of active display pixels:
            rgb_nxt = 12'h8_8_8;                // - fill with gray.
    end
end

endmodule
