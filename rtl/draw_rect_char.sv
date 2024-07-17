`timescale 1 ns / 1 ps

module draw_rect_char (
    input  logic clk,
    input  logic rst,
    input  logic [63:0]  char_pixels,
    output logic [7:0] char_xy,
    output logic [4:0] char_line,
    output logic [10:0]  char_addr,
    vga_if.in vga_in,
    vga_if.out vga_out
);

import vga_pkg::*;

/**
 * Local variables and signals
 */

vga_if int1();
vga_if int2();

logic [11:0]   rgb_nxt;
logic [10:0]   char_xy_buf;
logic [10:0]   char_line_buf;
logic [5:0]    char_code;
logic [63:0]  char_pixels_ts;
/**
 * int1al logic
 */
always_ff @(posedge clk) begin
    if (rst) begin
        int1.vcount <= '0;
        int1.vsync  <= '0;
        int1.vblnk  <= '0;
        int1.hcount <= '0;
        int1.hsync  <= '0;
        int1.hblnk  <= '0;
        int1.rgb    <= '0;
    end else begin
        int1.vcount <= vga_in.vcount;
        int1.vsync  <= vga_in.vsync;
        int1.vblnk  <= vga_in.vblnk;
        int1.hcount <= vga_in.hcount;
        int1.hsync  <= vga_in.hsync;
        int1.hblnk  <= vga_in.hblnk;
        int1.rgb    <= vga_in.rgb;
    end
end
delay #(
    .WIDTH(38),
    .CLK_DEL(2)
) u_delay(
    .clk(clk),
    .rst(rst),
    .din({vga_in.vcount, vga_in.vsync, vga_in.vblnk, vga_in.hcount, vga_in.hsync, vga_in.hblnk, vga_in.rgb}),
    .dout({int2.vcount, int2.vsync, int2.vblnk, int2.hcount, int2.hsync, int2.hblnk, int2.rgb})
);

always_ff @(posedge clk) begin
    vga_out.vcount <= int2.vcount;
    vga_out.vsync  <= int2.vsync;
    vga_out.vblnk  <= int2.vblnk;
    vga_out.hcount <= int2.hcount;
    vga_out.hsync  <= int2.hsync;
    vga_out.hblnk  <= int2.hblnk;
    vga_out.rgb    <= rgb_nxt;
end

always_comb begin
    char_line_buf = vga_in.vcount - CHAR_Y;
    char_xy_buf = vga_in.hcount - CHAR_X;
    char_xy = char_xy_buf[10:6] + 8*char_line_buf[10:6];

    char_line = int1.vcount[5:1] - CHAR_Y[5:1];
end
always_comb begin
    if(((int2.hcount >= CHAR_X) & (int2.hcount < CHAR_LENGTH + CHAR_X) & (int2.vcount >= CHAR_Y) & (int2.vcount <= CHAR_Y + CHAR_HEIGHT)))    
        if((char_pixels[63 - (int2.hcount[10:1]*2 - CHAR_X)%64] == 1'b0) & (char_pixels[62 - (int2.hcount[10:1]*2 - CHAR_X)%64] == 1'b1)) begin    
            rgb_nxt = 12'h6_6_6;
        end else if((char_pixels[63 - (int2.hcount[10:1]*2 - CHAR_X)%64] == 1'b1) & (char_pixels[62 - (int2.hcount[10:1]*2 - CHAR_X)%64] == 1'b0)) begin    
            rgb_nxt = 12'hf_f_f;
        end else if((char_pixels[63 - (int2.hcount[10:1]*2 - CHAR_X)%64] == 1'b1) & (char_pixels[62 - (int2.hcount[10:1]*2 - CHAR_X)%64] == 1'b1)) begin    
            rgb_nxt = 12'h0_0_0;
        end else begin
            rgb_nxt = int2.rgb;
        end
    else begin
        rgb_nxt = int2.rgb;
    end
end

endmodule