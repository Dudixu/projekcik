/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * The project top module.
 */

 `timescale 1 ns / 1 ps

 module top_vga 
 (
     input  logic clk_65,
     input  logic clk_100,
     inout  logic ps2_clk,
     inout  logic ps2_data,
     input  logic rst,
     output logic vs,
     output logic hs,
     output logic [3:0] r,
     output logic [3:0] g,
     output logic [3:0] b
 );
 
 
// LOCAL VARIABLES AND SIGNALS /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 vga_if vga_tim();
 vga_if vga_bg();
 vga_if vga_rect();
 vga_if vga_figure();
 vga_if mouse_out();

 //logic  [11:0] xpos;
 //logic  [11:0] ypos;
 logic  mouse_left;

 logic  [11:0] xpos_buf_in;
 logic  [11:0] ypos_buf_in;
 logic  [11:0] xpos_buf_out;
 logic  [11:0] ypos_buf_out;

 logic  [10:0] char_addr;
 logic  [7:0]  char_pixels;

 logic  [63:0] figure_pixels;
 logic  [8:0] figure_addr;
 logic  [5:0]  figure_xy;
 logic  [3:0]  figure_code;
 logic  [4:0]  figure_line;
 
 // SIGNALS ASSIGNMENTS ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 assign vs = mouse_out.vsync;
 assign hs = mouse_out.hsync;
 assign {r,g,b} = mouse_out.rgb;
 
 // SUBMODULES ISTANCES /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 vga_timing u_vga_timing (
     .clk(clk_65),
     .rst,
     .vga_out(vga_tim)
 );

bg_letters u_bg_letters(
    .clk(clk_65),
    .rst,
    .vga_in(vga_tim),
    .char_addr(char_addr)
);

font_rom u_font_rom(
    .clk(clk_65),
    .addr(char_addr),
    .char_line_pixels(char_pixels)
);

draw_bg u_draw_bg (
    .clk(clk_65),
    .rst,
    .frame_pixels(char_pixels),
    .vga_in(vga_tim),
    .vga_out(vga_bg)
);

draw_figure u_draw_figure (
    .clk(clk_65),
    .rst,
    .vga_in(vga_bg),
    .vga_out(vga_figure),
    .figure_pixels(figure_pixels),
    .figure_xy(figure_xy),
    .figure_line(figure_line)
);

figure_position u_figure_position(
    .clk(clk_65),
    .figure_xy(figure_xy),
    .figure_code(figure_code)
);

always_comb begin
    figure_addr = {figure_code, figure_line};
end

/*draw_rect u_draw_rect (
    .clk(clk_65),
    .rst,
    .vga_in(vga_figure),
    .vga_out(vga_rect),
    .xpos,
    .ypos,
    .rgb_pixel(logo_rgb),
    .pixel_addr(logo_addr)
);*/
/*draw_rect_ctl u_draw_rect_ctl(
    .clk(clk_65),
    .rst,
    .vga_in(vga_figure),
    .mouse_left(mouse_left),
    .mouse_xpos(xpos_buf_out),
    .mouse_ypos(ypos_buf_out),
    .xpos,
    .ypos
);*/
MouseCtl u_MouseCtl(
    .clk(clk_100),
    .rst,
    .ps2_data,
    .ps2_clk,
    .xpos(xpos_buf_in),
    .ypos(ypos_buf_in),

    .zpos(),
    .left(mouse_left),
    .middle(),
    .right(),
    .new_event(),
    .value('0),
    .setx('0),
    .sety('0),
    .setmax_x('0),
    .setmax_y('0)
    );

always_ff @(posedge clk_65) begin
    xpos_buf_out <= xpos_buf_in;
    ypos_buf_out <= ypos_buf_in;
end

draw_mouse u_draw_mouse(
    .clk(clk_65),
    .rst,
    .vga_in(vga_figure),
    .vga_out(mouse_out),
    .xpos(xpos_buf_out),
    .ypos(ypos_buf_out)
);
figure_rom u_figure_rom(
    .clk(clk_65),    
    .addr(figure_addr),
    .figure_line_pixels(figure_pixels)
);

 endmodule
