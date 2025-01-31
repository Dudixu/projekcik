`timescale 1 ns / 1 ps

module draw_mouse (
    input  logic clk,
    input  logic rst,
    vga_if.in vga_in,
    vga_if.out vga_out,
    input logic [11:0] xpos,
    input logic [11:0] ypos
);

import vga_pkg::*;

/**
 * Internal logic
 */

always_ff @(posedge clk) begin
    if(rst) begin
        vga_out.vcount <= '0;
        vga_out.vsync  <= '0;
        vga_out.vblnk  <= '0;
        vga_out.hcount <= '0;
        vga_out.hsync  <= '0;
        vga_out.hblnk  <= '0;
    end
    else begin
        vga_out.vcount <= vga_in.vcount;
        vga_out.vsync  <= vga_in.vsync;
        vga_out.vblnk  <= vga_in.vblnk;
        vga_out.hcount <= vga_in.hcount;
        vga_out.hsync  <= vga_in.hsync;
        vga_out.hblnk  <= vga_in.hblnk;
    end
end

MouseDisplay u_MouseDisplay(
    .pixel_clk(clk),
    .hcount(vga_in.hcount),
    .vcount(vga_in.vcount),
    .blank(vga_in.vblnk | vga_in.hblnk),
    .rgb_in(vga_in.rgb),
    .rgb_out(vga_out.rgb),
    .xpos,
    .ypos,
    .enable_mouse_display_out()

 );
 endmodule