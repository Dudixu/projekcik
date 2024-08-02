`timescale 1ns/1ps

module mouse_position
import vga_pkg::*; (
    input logic        clk,
    input logic        rst,
    input logic        LMB,
    input logic [11:0] mouse_xpos,
    input logic [11:0] mouse_ypos,
    output logic [5:0] mouse_position, // miejsce na planszy na którym znajduje sie myszka
    output logic pick_piece,
    output logic place_piece
);
logic LMB_pressed;
always_ff @(posedge clk) begin : xypos_blk
    if(rst) begin
        mouse_position <= '0;
        pick_piece <= '0;
        place_piece <= '0;
        LMB_pressed <= '0;
    end else begin
        if(LMB == 1 & LMB_pressed == 0) begin
            LMB_pressed <= 1;
        end else if(LMB == 0 & LMB_pressed == 1 & pick_piece == 0)begin
            LMB_pressed <= 0;
            pick_piece <= 1;
            place_piece <= 0;
        end else if(LMB == 0 & LMB_pressed == 1 & pick_piece == 1)begin
            LMB_pressed <= 0;
            pick_piece <= 0;
            place_piece <= 1;
        end
        mouse_position[2:0] <= (mouse_ypos-128)/64;
        mouse_position[5:3] <= (mouse_xpos-256)/64;

    end
end

endmodule