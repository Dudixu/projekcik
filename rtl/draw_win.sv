//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company : AGH University of Krakow
// Create Date : 23.08.2024
// Designers Name : Dawid Mironiuk & Michał Malara
// Module Name : draw_win
// Project Name : SZACHY - Projekt zaliczeniowy
// Target Devices : BASYS3
// 
// Description : Moduł odpowiedzialny za rysowanie ekranu końcowego informującego o zwyciestwie.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module draw_win 
(
    input  logic clk,
    input  logic rst,
    input  logic white_win, black_win,
    vga_if.in vga_in,    
    vga_if.out vga_out   
);

import vga_pkg::*;

// LOCAL VARIABLES AND SIGNALES ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

logic [11:0] rgb_nxt;

 // INTERNAL LOGIC ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
    
    // ZWYCIĘSTWO BIAŁYCH //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if(white_win == 1)begin 

        // RYSOWANIE BIAŁEGO KRÓLA /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 1 LINIA RAMKA //
        if ((vga_in.hcount >= 320 & vga_in.hcount < 704) & vga_in.vcount >= 644 & vga_in.vcount < 668)begin 
            rgb_nxt = 12'h6_6_6;
        // 2 LINIA RAMKA //
        end else if(((vga_in.hcount >= 320 & vga_in.hcount < 344)|(vga_in.hcount >= 680 & vga_in.hcount < 704) )& vga_in.vcount >= 620 & vga_in.vcount < 644)begin
            rgb_nxt = 12'h6_6_6;
        // 2 LINIA BIAŁE WYPEŁNIENIE //
        end else if((vga_in.hcount >= 344 & vga_in.hcount < 680) & vga_in.vcount >= 620 & vga_in.vcount < 644)begin
            rgb_nxt = 12'hf_f_f;
        // 3 LINIA RAMKA //   
        end else if((vga_in.hcount >= 320 & vga_in.hcount < 704) & vga_in.vcount >= 596 & vga_in.vcount < 620)begin
            rgb_nxt = 12'h6_6_6;
        // 4 LINIA RAMKA //
        end else if(((vga_in.hcount >= 344 & vga_in.hcount < 368)|(vga_in.hcount >= 656 & vga_in.hcount < 680) )& vga_in.vcount >= 572 & vga_in.vcount < 596)begin
            rgb_nxt = 12'h6_6_6;
        // 4 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 368 & vga_in.hcount < 656) & vga_in.vcount >= 572 & vga_in.vcount < 596)begin
            rgb_nxt = 12'hf_f_f;
        // 5 LINIA RAMKA //
        end else if((vga_in.hcount >= 344 & vga_in.hcount < 680) & vga_in.vcount >= 548 & vga_in.vcount < 572)begin
            rgb_nxt = 12'h6_6_6;
        // 6 LINIA RAMKA //
        end else if(((vga_in.hcount >= 320 & vga_in.hcount < 344)|(vga_in.hcount >= 680 & vga_in.hcount < 704) )& vga_in.vcount >= 524 & vga_in.vcount < 548)begin
            rgb_nxt = 12'h6_6_6;
        // 6 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 344 & vga_in.hcount < 680) & vga_in.vcount >= 524 & vga_in.vcount < 548)begin
            rgb_nxt = 12'hf_f_f;
        // 7 - 8 LINIA RAMKA //
        end else if(((vga_in.hcount >= 296 & vga_in.hcount < 320)|(vga_in.hcount >= 704 & vga_in.hcount < 728) )& vga_in.vcount >= 476 & vga_in.vcount < 524)begin
            rgb_nxt = 12'h6_6_6;
        // 7 - 8 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 320 & vga_in.hcount < 704) & vga_in.vcount >= 476 & vga_in.vcount < 524)begin
            rgb_nxt = 12'hf_f_f;
        // 9 - 12 LINIA RAMKA //
        end else if(((vga_in.hcount >= 272 & vga_in.hcount < 296)|(vga_in.hcount >= 728 & vga_in.hcount < 752) )& vga_in.vcount >= 380 & vga_in.vcount < 476)begin
            rgb_nxt = 12'h6_6_6;
        // 9 - 12 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 296 & vga_in.hcount < 728) & vga_in.vcount >= 380 & vga_in.vcount < 476)begin
            rgb_nxt = 12'hf_f_f;
        // 13 - 14 LINIA RAMKA //
        end else if(((vga_in.hcount >= 272 & vga_in.hcount < 296)|(vga_in.hcount >= 728 & vga_in.hcount < 752)|(vga_in.hcount >= 488 & vga_in.hcount < 536))& vga_in.vcount >= 332 & vga_in.vcount < 380)begin
            rgb_nxt = 12'h6_6_6;
        // 13 - 14 LINIA WYPEŁNIENIE //
         end else if(((vga_in.hcount >= 296 & vga_in.hcount < 488) | (vga_in.hcount >= 536 & vga_in.hcount < 728)) & vga_in.vcount >= 332 & vga_in.vcount < 380)begin
            rgb_nxt = 12'hf_f_f;
        // 15 LINIA RAMKA //
        end else if(((vga_in.hcount >= 272 & vga_in.hcount < 296)|(vga_in.hcount >= 728 & vga_in.hcount < 752)|(vga_in.hcount >= 464 & vga_in.hcount < 488)|(vga_in.hcount >= 536 & vga_in.hcount < 560))& vga_in.vcount >= 308 & vga_in.vcount < 332)begin
            rgb_nxt = 12'h6_6_6;
        // 15 LINIA WYPEŁNIENIE //
        end else if(((vga_in.hcount >= 296 & vga_in.hcount < 464) | (vga_in.hcount >= 488 & vga_in.hcount < 536) | (vga_in.hcount >= 560 & vga_in.hcount < 728)) & vga_in.vcount >= 308 & vga_in.vcount < 332)begin
            rgb_nxt = 12'hf_f_f;
        // 16 LINIA RAMKA //
        end else if(((vga_in.hcount >= 296 & vga_in.hcount < 320)|(vga_in.hcount >= 704 & vga_in.hcount < 728)|(vga_in.hcount >= 416 & vga_in.hcount < 488)|(vga_in.hcount >= 536 & vga_in.hcount < 608))& vga_in.vcount >= 284 & vga_in.vcount < 308)begin
            rgb_nxt = 12'h6_6_6; 
        // 16 LINIA WYPEŁNIEIE //
        end else if(((vga_in.hcount >= 320 & vga_in.hcount < 416) | (vga_in.hcount >= 488 & vga_in.hcount < 536) | (vga_in.hcount >= 608 & vga_in.hcount < 704)) & vga_in.vcount >= 284 & vga_in.vcount < 308)begin
            rgb_nxt = 12'hf_f_f;
        // 17 LINIA RAMKA //
        end else if(((vga_in.hcount >= 320 & vga_in.hcount < 416)|(vga_in.hcount >= 608 & vga_in.hcount < 704)|(vga_in.hcount >= 464 & vga_in.hcount < 488)|(vga_in.hcount >= 536 & vga_in.hcount < 560))& vga_in.vcount >= 260 & vga_in.vcount < 284)begin
            rgb_nxt = 12'h6_6_6;
        // 17 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 488 & vga_in.hcount < 536) & vga_in.vcount >= 260 & vga_in.vcount < 284)begin
            rgb_nxt = 12'hf_f_f;
        // 18 - 19 LINIA RAMKA //
        end else if(((vga_in.hcount >= 440 & vga_in.hcount < 488)|(vga_in.hcount >= 536 & vga_in.hcount < 584)) & vga_in.vcount >= 236 & vga_in.vcount < 284)begin
            rgb_nxt = 12'h6_6_6;
        // 18 - 19 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 488 & vga_in.hcount < 536) & vga_in.vcount >= 236 & vga_in.vcount < 260)begin
            rgb_nxt = 12'hf_f_f;
        // 20 LINIA RAMKA
        end else if(((vga_in.hcount >= 416 & vga_in.hcount < 440)|(vga_in.hcount >= 584 & vga_in.hcount < 608)) & vga_in.vcount >= 188 & vga_in.vcount < 236)begin
            rgb_nxt = 12'h6_6_6;
        // 20 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 440 & vga_in.hcount < 584) & vga_in.vcount >= 188 & vga_in.vcount < 236)begin
            rgb_nxt = 12'hf_f_f;
        // 21 LINIA RAMKA //
        end else if(((vga_in.hcount >= 440 & vga_in.hcount < 488)|(vga_in.hcount >= 536 & vga_in.hcount < 584)) & vga_in.vcount >= 164 & vga_in.vcount < 188)begin
            rgb_nxt = 12'h6_6_6;
        // 21 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 488 & vga_in.hcount < 536) & vga_in.vcount >= 164 & vga_in.vcount < 188)begin
            rgb_nxt = 12'hf_f_f;
        // 22 LINIA RAMKA //
        end else if(((vga_in.hcount >= 464 & vga_in.hcount < 488)|(vga_in.hcount >= 536 & vga_in.hcount < 560)) & vga_in.vcount >= 140 & vga_in.vcount < 164)begin
            rgb_nxt = 12'h6_6_6;
        // 22 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 488 & vga_in.hcount < 536) & vga_in.vcount >= 140 & vga_in.vcount < 164)begin
            rgb_nxt = 12'hf_f_f;
        // 23 LINIA RAMKA //
        end else if((vga_in.hcount >= 488 & vga_in.hcount < 536) & vga_in.vcount >= 116 & vga_in.vcount < 140)begin
            rgb_nxt = 12'h6_6_6;
        // TŁO EKRANU //
        end else begin
            rgb_nxt = 12'h0_f_0;
        end
    
    // ZWYCIĘSTWO CZARNYCH //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    end else if (black_win == 1)begin
        
        // RYSOWANIE CZARNEGO KRÓLA /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // 1 LINIA RAMKA //
        if ((vga_in.hcount >= 320 & vga_in.hcount < 704) & vga_in.vcount >= 644 & vga_in.vcount < 668)begin 
            rgb_nxt = 12'h6_6_6;
        // 2 LINIA RAMKA //
        end else if(((vga_in.hcount >= 320 & vga_in.hcount < 344)|(vga_in.hcount >= 680 & vga_in.hcount < 704) )& vga_in.vcount >= 620 & vga_in.vcount < 644)begin
            rgb_nxt = 12'h6_6_6;
        // 2 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 344 & vga_in.hcount < 680) & vga_in.vcount >= 620 & vga_in.vcount < 644)begin
            rgb_nxt = 12'h0_0_0;
        // 3 LINIA RAMKA //   
        end else if((vga_in.hcount >= 320 & vga_in.hcount < 704) & vga_in.vcount >= 596 & vga_in.vcount < 620)begin
            rgb_nxt = 12'h6_6_6;
        // 4 LINIA RAMKA //
        end else if(((vga_in.hcount >= 344 & vga_in.hcount < 368)|(vga_in.hcount >= 656 & vga_in.hcount < 680) )& vga_in.vcount >= 572 & vga_in.vcount < 596)begin
            rgb_nxt = 12'h6_6_6;
        // 4 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 368 & vga_in.hcount < 656) & vga_in.vcount >= 572 & vga_in.vcount < 596)begin
            rgb_nxt = 12'h0_0_0;
        // 5 LINIA RAMKA //
        end else if((vga_in.hcount >= 344 & vga_in.hcount < 680) & vga_in.vcount >= 548 & vga_in.vcount < 572)begin
            rgb_nxt = 12'h6_6_6;
        // 6 LINIA RAMKA //
        end else if(((vga_in.hcount >= 320 & vga_in.hcount < 344)|(vga_in.hcount >= 680 & vga_in.hcount < 704) )& vga_in.vcount >= 524 & vga_in.vcount < 548)begin
            rgb_nxt = 12'h6_6_6;
        // 6 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 344 & vga_in.hcount < 680) & vga_in.vcount >= 524 & vga_in.vcount < 548)begin
            rgb_nxt = 12'h0_0_0;
        // 7 - 8 LINIA RAMKA //
        end else if(((vga_in.hcount >= 296 & vga_in.hcount < 320)|(vga_in.hcount >= 704 & vga_in.hcount < 728) )& vga_in.vcount >= 476 & vga_in.vcount < 524)begin
            rgb_nxt = 12'h6_6_6;
        // 7 - 8 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 320 & vga_in.hcount < 704) & vga_in.vcount >= 476 & vga_in.vcount < 524)begin
            rgb_nxt = 12'h0_0_0;
        // 9 - 12 LINIA RAMKA //
        end else if(((vga_in.hcount >= 272 & vga_in.hcount < 296)|(vga_in.hcount >= 728 & vga_in.hcount < 752) )& vga_in.vcount >= 380 & vga_in.vcount < 476)begin
            rgb_nxt = 12'h6_6_6;
        // 9 - 12 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 296 & vga_in.hcount < 728) & vga_in.vcount >= 380 & vga_in.vcount < 476)begin
            rgb_nxt = 12'h0_0_0;
        // 13 - 14 LINIA RAMKA //
        end else if(((vga_in.hcount >= 272 & vga_in.hcount < 296)|(vga_in.hcount >= 728 & vga_in.hcount < 752)|(vga_in.hcount >= 488 & vga_in.hcount < 536))& vga_in.vcount >= 332 & vga_in.vcount < 380)begin
            rgb_nxt = 12'h6_6_6;
        // 13 - 14 LINIA WYPEŁNIENIE //
         end else if(((vga_in.hcount >= 296 & vga_in.hcount < 488) | (vga_in.hcount >= 536 & vga_in.hcount < 728)) & vga_in.vcount >= 332 & vga_in.vcount < 380)begin
            rgb_nxt = 12'h0_0_0;
        // 15 LINIA RAMKA //
        end else if(((vga_in.hcount >= 272 & vga_in.hcount < 296)|(vga_in.hcount >= 728 & vga_in.hcount < 752)|(vga_in.hcount >= 464 & vga_in.hcount < 488)|(vga_in.hcount >= 536 & vga_in.hcount < 560))& vga_in.vcount >= 308 & vga_in.vcount < 332)begin
            rgb_nxt = 12'h6_6_6;
        // 15 LINIA WYPEŁNIENIE //
        end else if(((vga_in.hcount >= 296 & vga_in.hcount < 464) | (vga_in.hcount >= 488 & vga_in.hcount < 536) | (vga_in.hcount >= 560 & vga_in.hcount < 728)) & vga_in.vcount >= 308 & vga_in.vcount < 332)begin
            rgb_nxt = 12'h0_0_0;
        // 16 LINIA RAMKA //
        end else if(((vga_in.hcount >= 296 & vga_in.hcount < 320)|(vga_in.hcount >= 704 & vga_in.hcount < 728)|(vga_in.hcount >= 416 & vga_in.hcount < 488)|(vga_in.hcount >= 536 & vga_in.hcount < 608))& vga_in.vcount >= 284 & vga_in.vcount < 308)begin
            rgb_nxt = 12'h6_6_6; 
        // 16 LINIA WYPEŁNIEIE //
        end else if(((vga_in.hcount >= 320 & vga_in.hcount < 416) | (vga_in.hcount >= 488 & vga_in.hcount < 536) | (vga_in.hcount >= 608 & vga_in.hcount < 704)) & vga_in.vcount >= 284 & vga_in.vcount < 308)begin
            rgb_nxt = 12'h0_0_0;
        // 17 LINIA RAMKA //
        end else if(((vga_in.hcount >= 320 & vga_in.hcount < 416)|(vga_in.hcount >= 608 & vga_in.hcount < 704)|(vga_in.hcount >= 464 & vga_in.hcount < 488)|(vga_in.hcount >= 536 & vga_in.hcount < 560))& vga_in.vcount >= 260 & vga_in.vcount < 284)begin
            rgb_nxt = 12'h6_6_6;
        // 17 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 488 & vga_in.hcount < 536) & vga_in.vcount >= 260 & vga_in.vcount < 284)begin
            rgb_nxt = 12'h0_0_0;
        // 18 - 19 LINIA RAMKA //
        end else if(((vga_in.hcount >= 440 & vga_in.hcount < 488)|(vga_in.hcount >= 536 & vga_in.hcount < 584)) & vga_in.vcount >= 236 & vga_in.vcount < 284)begin
            rgb_nxt = 12'h6_6_6;
        // 18 - 19 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 488 & vga_in.hcount < 536) & vga_in.vcount >= 236 & vga_in.vcount < 260)begin
            rgb_nxt = 12'h0_0_0;
        // 20 LINIA RAMKA
        end else if(((vga_in.hcount >= 416 & vga_in.hcount < 440)|(vga_in.hcount >= 584 & vga_in.hcount < 608)) & vga_in.vcount >= 188 & vga_in.vcount < 236)begin
            rgb_nxt = 12'h6_6_6;
        // 20 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 440 & vga_in.hcount < 584) & vga_in.vcount >= 188 & vga_in.vcount < 236)begin
            rgb_nxt = 12'h0_0_0;
        // 21 LINIA RAMKA //
        end else if(((vga_in.hcount >= 440 & vga_in.hcount < 488)|(vga_in.hcount >= 536 & vga_in.hcount < 584)) & vga_in.vcount >= 164 & vga_in.vcount < 188)begin
            rgb_nxt = 12'h6_6_6;
        // 21 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 488 & vga_in.hcount < 536) & vga_in.vcount >= 164 & vga_in.vcount < 188)begin
            rgb_nxt = 12'h0_0_0;
        // 22 LINIA RAMKA //
        end else if(((vga_in.hcount >= 464 & vga_in.hcount < 488)|(vga_in.hcount >= 536 & vga_in.hcount < 560)) & vga_in.vcount >= 140 & vga_in.vcount < 164)begin
            rgb_nxt = 12'h6_6_6;
        // 22 LINIA WYPEŁNIENIE //
        end else if((vga_in.hcount >= 488 & vga_in.hcount < 536) & vga_in.vcount >= 140 & vga_in.vcount < 164)begin
            rgb_nxt = 12'h0_0_0;
        // 23 LINIA RAMKA //
        end else if((vga_in.hcount >= 488 & vga_in.hcount < 536) & vga_in.vcount >= 116 & vga_in.vcount < 140)begin
            rgb_nxt = 12'h6_6_6;
        // TŁO EKRANU //
        end else begin
            rgb_nxt = 12'h0_f_0;
        end
    
    // PRZEPISYWANIE BG W TRAKCIE ROZGRYWKI //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    end else begin                                   
            rgb_nxt = vga_in.rgb;     // KOLOR TŁA //           
    end
end

endmodule
