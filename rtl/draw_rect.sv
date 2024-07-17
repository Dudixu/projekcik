`timescale 1 ns / 1 ps

module draw_rect (
    input  logic clk,
    input  logic rst,
    input  logic [11:0] xpos,
    input  logic [11:0] ypos,
    input  logic [11:0] rgb_pixel,
    output logic [11:0] pixel_addr,
    vga_if.in vga_in,
    vga_if.out vga_out
);

import vga_pkg::*;

/**
 * Local variables and signals
 */

vga_if intern();

logic [11:0] rgb_nxt;
logic [5:0]  xaddr;
logic [5:0]  yaddr;

/**
 * Internal logic
 */

always_ff @(posedge clk) begin
    if (rst) begin
        intern.vcount <= '0;
        intern.vsync  <= '0;
        intern.vblnk  <= '0;
        intern.hcount <= '0;
        intern.hsync  <= '0;
        intern.hblnk  <= '0;
        intern.rgb    <= '0;
    end else begin
        intern.vcount <= vga_in.vcount;
        intern.vsync  <= vga_in.vsync;
        intern.vblnk  <= vga_in.vblnk;
        intern.hcount <= vga_in.hcount;
        intern.hsync  <= vga_in.hsync;
        intern.hblnk  <= vga_in.hblnk;
        intern.rgb    <= vga_in.rgb;
    end
end

always_ff @(posedge clk) begin
    vga_out.vcount <= intern.vcount;
    vga_out.vsync  <= intern.vsync;
    vga_out.vblnk  <= intern.vblnk;
    vga_out.hcount <= intern.hcount;
    vga_out.hsync  <= intern.hsync;
    vga_out.hblnk  <= intern.hblnk;
    vga_out.rgb    <= rgb_nxt;
end

always_comb begin
    xaddr = vga_in.hcount - xpos ;
    yaddr = vga_in.vcount - ypos ;
    pixel_addr = {yaddr, xaddr};
end

always_comb begin
    if(((intern.hcount >= xpos) & (intern.hcount <= xpos + RECT_LENGTH) & (intern.vcount >= ypos) & (intern.vcount <= ypos + RECT_HEIGHT)))
        rgb_nxt = rgb_pixel;
    else 
        rgb_nxt = intern.rgb;
end

endmodule
