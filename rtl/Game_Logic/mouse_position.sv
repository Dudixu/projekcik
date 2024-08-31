///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
//Company : AGH University of Krakow
// Create Date : 07.08.2024
// Designers Name : Dawid Mironiuk & Michał Malara
// Module Name : mouse_position
// Project Name : SZACHY - Projekt zaliczeniowy
// Target Devices : BASYS3
// 
// Description : Odczytuje połozenie kursora na szachownicy + maszyna stanów odpowiedzialna za wykonywanie ruchów.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module mouse_position
 (
    input logic        clk,
    input logic        rst,
    input logic  [3:0] board[0:7][0:7],
    input logic        mouse_left,
    input logic [10:0] hcount,
    input logic [10:0] vcount,
    input logic [63:0] possible_moves,
    input logic [11:0] mouse_xpos,
    input logic [11:0] mouse_ypos,
    input logic        begin_turn,
    input logic        oponent_pick,
    input logic  [5:0] oponent_position,
    input logic        set_player,
    output logic [5:0] mouse_position,
    output logic       pick_place,
    output logic       next_turn,
    output logic [3:0] led
    //vga_if.in vga_in
);

import vga_pkg::*;

typedef enum bit [1:0]{IDLE = 2'b00, WAIT = 2'b01, PICK = 2'b10, PLACE = 2'b11} STATE_T;

STATE_T state, state_nxt;

logic pick_place_nxt;
logic next_turn_nxt = 0;
logic [5:0] pick_position;
logic [5:0] mouse_pos_buf;
logic force_turn;
logic turn_forced;
logic begin_turn_spike;
logic player_already_set = 0;
logic player_token;
logic your_turn;
logic your_turn_nxt;

always_ff @(posedge clk) begin : xypos_blk
        if(rst) begin
            state    <= IDLE;
            mouse_position <= 0;
            pick_place <= '0;
            force_turn <= '0;
            player_already_set <= '0;
            next_turn <= '0;
            your_turn <= '0;
            begin_turn_spike <= '0;
            player_token <= '1;
        end else begin
            if(hcount == 300 & vcount == 300)begin
                if(begin_turn_spike == 1)begin
                    force_turn <= '1;
                    begin_turn_spike <= '0;
                end
            end else if(hcount == 0 & vcount == 0) begin
                mouse_pos_buf[5:3] <= (mouse_ypos-128)/64;
                mouse_pos_buf[2:0] <= (mouse_xpos-256)/64;
                state    <= state_nxt;
                next_turn <= next_turn_nxt;
                if(begin_turn == 1)begin
                    begin_turn_spike <= '1;
                end
                if(turn_forced == '1)begin
                    force_turn <= '0;
                end else if(player_already_set == 0 & set_player == 1)begin
                    player_already_set <= '1;
                    player_token <= '0;
                    force_turn <= '1;
                end  else if(your_turn == 0)begin
                    if(oponent_pick == 1 & player_already_set == 0)begin
                        player_already_set <= '1;
                    end 
                    your_turn <= your_turn_nxt;
                    pick_place <= oponent_pick;
                    mouse_position <= oponent_position;
                end else begin
                    your_turn <= your_turn_nxt;
                    pick_place <= pick_place_nxt;
                    mouse_position <= mouse_pos_buf;
                end
            end
        end
end


// MASZYNA STANU ODPOWIEDZIALNA ZA WYKONANIE RUCHU /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
always_comb begin : state_nxt_blk
    case(state)
        IDLE:       state_nxt = mouse_left && your_turn && ((player_token == '0 & board[mouse_pos_buf[5:3]][mouse_pos_buf[2:0]] <= 4'h6) | (player_token == '1 && board[mouse_pos_buf[5:3]][mouse_pos_buf[2:0]] >= 4'h7)) & board[mouse_pos_buf[5:3]][mouse_pos_buf[2:0]] != '0 ? PICK : IDLE;
        PICK:       state_nxt = mouse_left ? PICK : WAIT;
        WAIT:       state_nxt = mouse_left && possible_moves[mouse_pos_buf] == '1 ? PLACE : WAIT;
        PLACE:      state_nxt = mouse_left ? PLACE : IDLE;

        default:    state_nxt = IDLE;
    endcase  
end

// SYGANŁY STERUACE W POSCZEGÓLNUCH STANACH //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
always_comb begin : output_blk
    case(state)
        // STAN POCZATKOWY //
        IDLE: begin
            pick_place_nxt = '0;
            if(force_turn == 1)begin
                your_turn_nxt = '1;
            end else if(next_turn == 1) begin
                next_turn_nxt = '0;
            end
            turn_forced = '0;
            led = 4'b1000;
        end

        // PODNOSZENIE FIGURY //
        PICK: begin
            pick_position = mouse_pos_buf;
            turn_forced = '1;
            pick_place_nxt = '1;
            led = 4'b0100;
        end

        // STAN POMIĘDZY KLIKNIECIAMI MYSZY //
        WAIT: begin
            pick_place_nxt = '1;
            led = 4'b0010;
        end

        // ODKŁADANIE FIGURY //
        PLACE: begin
            pick_place_nxt = '0;
            led = 4'b0001;
            if(pick_position == mouse_pos_buf)begin
                your_turn_nxt = '1;
                next_turn_nxt = '0;
            end else if (pick_position != mouse_pos_buf)begin
                your_turn_nxt = '0;
                next_turn_nxt = '1;
            end

        end

        default: begin
            pick_place_nxt = '0;
            turn_forced = '0;
            your_turn_nxt = '0;

        end
    endcase
end

endmodule
