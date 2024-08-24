
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
    if(white_win == 1)begin
if ((vga_in.hcount >= 320 & vga_in.hcount < 704) & vga_in.vcount >= 644 & vga_in.vcount < 668)begin //PODSTAWKA SZAA
            rgb_nxt = 12'h6_6_6;
        end else if(((vga_in.hcount >= 320 & vga_in.hcount < 344)|(vga_in.hcount >= 680 & vga_in.hcount < 704) )& vga_in.vcount >= 620 & vga_in.vcount < 644)begin
            rgb_nxt = 12'h6_6_6;
        end else if((vga_in.hcount >= 344 & vga_in.hcount < 680) & vga_in.vcount >= 620 & vga_in.vcount < 644)begin
            rgb_nxt = 12'hf_f_f;
        end else if((vga_in.hcount >= 320 & vga_in.hcount < 704) & vga_in.vcount >= 596 & vga_in.vcount < 620)begin
            rgb_nxt = 12'h6_6_6;
        end else if(((vga_in.hcount >= 344 & vga_in.hcount < 368)|(vga_in.hcount >= 656 & vga_in.hcount < 680) )& vga_in.vcount >= 572 & vga_in.vcount < 596)begin
            rgb_nxt = 12'h6_6_6;
        end else if((vga_in.hcount >= 368 & vga_in.hcount < 656) & vga_in.vcount >= 572 & vga_in.vcount < 596)begin
            rgb_nxt = 12'hf_f_f;
        end else if((vga_in.hcount >= 344 & vga_in.hcount < 680) & vga_in.vcount >= 548 & vga_in.vcount < 572)begin
            rgb_nxt = 12'h6_6_6;
        end else if(((vga_in.hcount >= 320 & vga_in.hcount < 344)|(vga_in.hcount >= 680 & vga_in.hcount < 704) )& vga_in.vcount >= 524 & vga_in.vcount < 548)begin
            rgb_nxt = 12'h6_6_6;
        end else if((vga_in.hcount >= 344 & vga_in.hcount < 680) & vga_in.vcount >= 524 & vga_in.vcount < 548)begin
            rgb_nxt = 12'hf_f_f;
        end else if(((vga_in.hcount >= 296 & vga_in.hcount < 320)|(vga_in.hcount >= 704 & vga_in.hcount < 728) )& vga_in.vcount >= 476 & vga_in.vcount < 524)begin
            rgb_nxt = 12'h6_6_6;
        end else if((vga_in.hcount >= 320 & vga_in.hcount < 704) & vga_in.vcount >= 476 & vga_in.vcount < 524)begin
            rgb_nxt = 12'hf_f_f;
        end else if(((vga_in.hcount >= 272 & vga_in.hcount < 296)|(vga_in.hcount >= 728 & vga_in.hcount < 752) )& vga_in.vcount >= 380 & vga_in.vcount < 476)begin
            rgb_nxt = 12'h6_6_6;
        end else if((vga_in.hcount >= 296 & vga_in.hcount < 728) & vga_in.vcount >= 380 & vga_in.vcount < 476)begin
            rgb_nxt = 12'hf_f_f;
        end else if(((vga_in.hcount >= 272 & vga_in.hcount < 296)|(vga_in.hcount >= 728 & vga_in.hcount < 752)|(vga_in.hcount >= 488 & vga_in.hcount < 536))& vga_in.vcount >= 332 & vga_in.vcount < 380)begin
            rgb_nxt = 12'h6_6_6;
         end else if((vga_in.hcount >= 296 & vga_in.hcount < 488) & (vga_in.hcount >= 536 & vga_in.hcount < 728) & vga_in.vcount >= 332 & vga_in.vcount < 380)begin
            rgb_nxt = 12'hf_f_f;
        end else if(((vga_in.hcount >= 272 & vga_in.hcount < 296)|(vga_in.hcount >= 728 & vga_in.hcount < 752)|(vga_in.hcount >= 464 & vga_in.hcount < 488)|(vga_in.hcount >= 536 & vga_in.hcount < 560))& vga_in.vcount >= 308 & vga_in.vcount < 332)begin
            rgb_nxt = 12'h6_6_6;
        end else if((vga_in.hcount >= 296 & vga_in.hcount < 464) & (vga_in.hcount >= 488 & vga_in.hcount < 536)& (vga_in.hcount >= 560 & vga_in.hcount < 728) & vga_in.vcount >= 308 & vga_in.vcount < 332)begin
            rgb_nxt = 12'hf_f_f;
        end else begin
            rgb_nxt = 12'h0_f_0;
        end
    end else if (black_win == 1)begin
        rgb_nxt = 12'h0_0_0;
    end else begin                                    // KOLOR TŁA //
            rgb_nxt = vga_in.rgb;                
    end
end

endmodule
