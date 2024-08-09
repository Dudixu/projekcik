`timescale 1ns/1ps

module draw_rect_ctl
import vga_pkg::*; (
    input logic        clk,
    input logic        rst,
    vga_if.in vga_in,
    input logic [3:0]  board[0:7][0:7],
    input logic        mouse_left,
    input logic [11:0] mouse_xpos,
    input logic [11:0] mouse_ypos,
    output logic [5:0] mouse_position,
    output logic pick_piece,
    output logic place_piece
);
typedef enum bit [2:0]{
    IDLE        = 3'b000,
    PICK        = 3'b001,
    PLACE       = 3'b010
} STATE_T;

STATE_T state, state_nxt;


always_ff @(posedge clk) begin : xypos_blk
    if(vga_in.hcount == 0 & vga_in.vcount == 0) begin
        if(rst) begin
            state    <= IDLE;
            mouse_position <= 0;
        end else begin
            state    <= state_nxt;
            mouse_position[5:3] <= (mouse_ypos-128)/64;
            mouse_position[2:0] <= (mouse_xpos-256)/64;
        end
    end else begin
    end
end


always_comb begin : state_nxt_blk
    case(state)
        IDLE:       state_nxt = mouse_left && board[mouse_position[5:3]][mouse_positon[2:0]] != '0 ? PICK : IDLE;
        PICK:       state_nxt = mouse_left && possible_moves[mouse_position] == '1 ? PLACE : PICK;
        PLACE:      state_nxt = IDLE;

        default:    state_nxt = IDLE;
    endcase  
end


always_comb begin : output_blk
    case(state)
        IDLE: begin
            pick_piece = 0;
            place_piece = 0;
        end

        PICK: begin
            pick_piece = 1;
            place_piece = 0;
        end

        PLACE: begin
            pick_piece = 0;
            place_piece = 1;
        end

        default: begin
            pick_piece = 0;
            place_piece = 0;
        end
    endcase
end

endmodule
