///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
//Company : AGH University of Krakow
// Create Date : 07.08.2024
// Designers Name : Dawid Mironiuk & Michał Malara
// Module Name : mouse_position
// Project Name : SZACHY - Projekt zaliczeniowy
// Target Devices : BASYS3
// 
// Description : Odczytuje połozenie kursora na szachownicy
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module mouse_position
import vga_pkg::*; (
    input logic        clk,
    input logic        rst,
    input logic [3:0]  board[0:7][0:7],
    input logic        mouse_left,
    input logic [63:0] possible_moves,
    input logic [11:0] mouse_xpos,
    input logic [11:0] mouse_ypos,
    input logic begin_turn,
    output logic [5:0] mouse_position,
    output logic pick_place,
    output logic next_turn,
    vga_if.in vga_in
);
typedef enum bit [2:0]{
    IDLE        = 3'b000,
    WAIT        = 3'b001,
    PICK        = 3'b010,
    PLACE       = 3'b011
} STATE_T;

STATE_T state, state_nxt;

logic pick_place_nxt;
logic [5:0] pick_position;
logic your_turn;

always_ff @(posedge clk) begin : xypos_blk
        if(rst) begin
            state    <= IDLE;
            mouse_position <= 0;
            pick_place <= '0;
        end else begin
            if(vga_in.hcount == 0 & vga_in.vcount == 0)begin
                state    <= state_nxt;
                pick_place <= pick_place_nxt;
                mouse_position[5:3] <= (mouse_ypos-128)/64;
                mouse_position[2:0] <= (mouse_xpos-256)/64;
            end
        end
end


always_comb begin : state_nxt_blk
    case(state)
        IDLE:       state_nxt = mouse_left && your_turn && board[mouse_position[5:3]][mouse_position[2:0]] != '0 ? PICK : IDLE;
        PICK:       state_nxt = mouse_left ? PICK : WAIT;
        WAIT:       state_nxt = mouse_left && possible_moves[mouse_position] == '1 ? PLACE : WAIT;
        PLACE:      state_nxt = mouse_left ? PLACE : IDLE;

        default:    state_nxt = IDLE;
    endcase  
end


always_comb begin : output_blk
    case(state)
        IDLE: begin
            pick_place_nxt = 0;

        end
        
        WAIT: begin
            pick_place_nxt = 1;

        end

        PICK: begin
            pick_place_nxt = 1;
            pick_position = mouse_position;

        end

        PLACE: begin
            pick_place_nxt = 0;
            if(pick_position == mouse_position)begin
                your_turn = 1;
            end else begin
                your_turn = 0;
                next_turn = !begin_turn;
            end

        end

        default: begin
            pick_place_nxt = 0;

        end
    endcase
end

endmodule
