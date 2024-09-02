/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 * Michał Malara
 * Dawid Mironiuk
 *
 * Description:
 * The project top module.
 */

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company : AGH University of Krakow
// Create Date : 23.07.2024
// Designers Name : prof. Eric Crabilla San Jose State University
// MODIFIED BY : Piotr Kaczmarczyk & Dawid Mironiuk & Michał Malara 
// Module Name : top_vga
// Project Name : SZACHY - Projekt zaliczeniowy
// Target Devices : BASYS3
// 
// Description : Moduł top projktu.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


 `timescale 1 ns / 1 ps

 module top_vga 
 (
     input  logic clk_75,
     input  logic clk_100,
     inout  logic ps2_clk,
     inout  logic ps2_data,
     input  logic rst,
     input  logic set_player,
     input  logic [7:0] data_in,
     output logic [7:0] data_out,
     output logic vs,
     output logic hs,
     output logic [3:0] r,
     output logic [3:0] g,
     output logic [3:0] b,
     output logic [3:0] led
 );
 
 
// LOCAL VARIABLES AND SIGNALS /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 vga_if vga_tim();
 vga_if vga_bg();
 vga_if vga_win();
 vga_if vga_figure();
 vga_if mouse_out();

 logic  mouse_left;

 logic  [11:0] xpos_buf_in;
 logic  [11:0] ypos_buf_in;
 logic  [11:0] xpos_buf_out;
 logic  [11:0] ypos_buf_out;

 logic  [10:0] char_addr;
 logic  [7:0]  char_pixels;

 logic  [63:0] figure_pixels;
 logic  [8:0]  figure_addr;
 logic  [5:0]  figure_xy;
 logic  [3:0]  figure_code;
 logic  [4:0]  figure_line;
 logic  [5:0]  figure_position;
 logic  [3:0]  board[0:7][0:7];
 logic  [3:0]  figure_taken;
 logic  [5:0]  p_pos;
 logic  [63:0] possible_moves;
 logic pick_place;
 logic white_castle;
 logic black_castle;
 logic white_win;
 logic black_win;



 
 // SIGNALS ASSIGNMENTS ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 assign vs = mouse_out.vsync;
 assign hs = mouse_out.hsync;
 assign {r,g,b} = mouse_out.rgb;
 
 // SUBMODULES ISTANCES /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 vga_timing u_vga_timing (
     .clk(clk_75),
     .rst,
     .vga_out(vga_tim)
 );

bg_letters u_bg_letters(
    .hcount(vga_tim.hcount),
    .vcount(vga_tim.vcount),
    .char_addr(char_addr)
);

font_rom u_font_rom(
    .clk(clk_75),
    .addr(char_addr),
    .char_line_pixels(char_pixels)
);

draw_bg u_draw_bg (
    .clk(clk_75),
    .rst,
    .frame_pixels(char_pixels),
    .vga_in(vga_tim),
    .vga_out(vga_bg)
);
draw_figure u_draw_figure (
    .clk(clk_75),
    .rst,
    .vga_in(vga_bg),
    .vga_out(vga_figure),
    .figure_pixels(figure_pixels),
    .figure_xy(figure_xy),
    .figure_line(figure_line)
);
draw_win u_draw_win(
    .clk(clk_75),
    .rst,
    .vga_in(vga_figure),
    .vga_out(vga_win),
    .black_win(black_win),
    .white_win(white_win)
);
chess_board u_chess_board(
    .clk(clk_75),
    .rst,
    .board(board),
    .figure_xy(figure_xy),
    .figure_code(figure_code),
    .figure_position(figure_position),
    .pick_place(pick_place),
    .pp_pos(p_pos),
    .figure_taken(figure_taken),
    .possible_moves(possible_moves),
    .white_castle(white_castle),
    .black_castle(black_castle),
    .black_win(black_win),
    .white_win(white_win)
);
figure_move_logic u_figure_move_logic(
    .clk(clk_75),
    .rst,
    .pick_piece(pick_place),
    .selected_figure(figure_taken),
    .board(board),
    .position(p_pos),
    .possible_moves(possible_moves),
    .white_castle(white_castle),
    .black_castle(black_castle)
);
always_comb begin
    figure_addr = {figure_code, figure_line};
end
figure_rom u_figure_rom(
    .clk(clk_75),    
    .addr(figure_addr),
    .figure_line_pixels(figure_pixels)
);
mouse_position u_mouse_position(
    .clk(clk_75),
    .rst,
    .set_player(set_player),
    .possible_moves(possible_moves),
    .mouse_left(mouse_left),
    .board(board),
    .mouse_xpos(xpos_buf_out),
    .mouse_ypos(ypos_buf_out),
    .pick_place(pick_place),
    .mouse_position(figure_position),
    .hcount(vga_figure.hcount),
    .vcount(vga_figure.vcount),
    .begin_turn(data_in[7]),
    .next_turn(data_out[7]),
    .oponent_pick(data_in[6]),
    .oponent_position(data_in[5:0]),
    .led(led)
);
always_comb begin
    data_out[6:0] = {pick_place, figure_position};
end

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

always_ff @(posedge clk_75) begin
    xpos_buf_out <= xpos_buf_in;
    ypos_buf_out <= ypos_buf_in;
end

draw_mouse u_draw_mouse(
    .clk(clk_75),
    .rst,
    .vga_in(vga_win),
    .vga_out(mouse_out),
    .xpos(xpos_buf_out),
    .ypos(ypos_buf_out)
);

 endmodule
