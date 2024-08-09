/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company : AGH University of Krakow
// Create Date : 28.07.2024
// Designers Name : Dawid Mironiuk & Michał Malara
// Module Name : chess_board
// Project Name : SZACHY - Projekt zaliczeniowy
// Target Devices : BASYS3
// 
// Description : 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module chess_board 
(
    input logic clk,                           // Zegar
    input logic rst,                           // Reset
    input logic [5:0] figure_xy,               // kod miejsca na planszy
    input logic [5:0] figure_position,         // 6-bitowa pozycja: [2:0] - kolumna (0-7), [5:3] - wiersz (0-7) wspolrzedne z myszki
    input logic place_piece,                   // Sygnał umieszczania figury na planszy
    input logic pick_piece,                    // Sygnał usuwania figury z planszy
    input logic [63:0] possible_moves,
    output logic [3:0] board [0:7][0:7],       // Macierz 8x8 zawierająca kody figur
    output logic [3:0] figure_code,            // kod figury znajduącej się w miejscu figure_xy
    output logic [3:0] figure_taken,
    output logic [5:0] pp_pos

);

    logic piece_already_picked;

    always_ff @(posedge clk, posedge rst) begin
        
        // INICIALIZACJA PLANSZY ////////////////////////////////////////////////////////////////////////////////////////////////////
        if (rst) begin

            // FIGURY //
            board[0] <= {4'hA, 4'h9, 4'h8, 4'hB, 4'hC, 4'h8, 4'h9, 4'hA}; // Figury czarne  1 wiersz
            board[1] <= {4'h7, 4'h7, 4'h7, 4'h7, 4'h7, 4'h7, 4'h7, 4'h7}; // Piony czarne 2 wiersz
            board[2] <= {4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0}; //
            board[3] <= {4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0}; //
            board[4] <= {4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0}; //
            board[5] <= {4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0}; //
            board[6] <= {4'h1, 4'h1, 4'h1, 4'h1, 4'h1, 4'h1, 4'h1, 4'h1}; // Piony białe 7 wiersz
            board[7] <= {4'h4, 4'h3, 4'h2, 4'h5, 4'h6, 4'h2, 4'h3, 4'h4}; // Figury białe 8 wiersz
            
            pp_pos <= '0;
            figure_taken <= '0;
            piece_already_picked <= '0;
            figure_code <= '0;
        // MODYFIKACJA POSZCEGÓLNYCH POZYCJI W TRAKCIE ROZGRYWKI ////////////////////////////////////////////////////////////////////

        end else begin
            if (place_piece == 1 & piece_already_picked == 1) begin
                board[figure_position[5:3]][figure_position[2:0]] <= figure_taken;     // WPISANIE KODU FIGURY //
                piece_already_picked <= '0;
                figure_taken <= '0;
            end else if (pick_piece == 1 & piece_already_picked == 0) begin
                figure_taken <= board[figure_position[5:3]][figure_position[2:0]];
                board[figure_position[5:3]][figure_position[2:0]] <= 4'h0;            // USUNIECIE KODU FIGURY //
                piece_already_picked <= '1;
                pp_pos <= figure_position;
            end 
            if(board[figure_xy[5:3]][figure_xy[2:0]] == 0 & possible_moves[figure_xy] == 1)begin
                figure_code <= 4'hD;
            end
            else begin
                figure_code <= board[figure_xy[5:3]][figure_xy[2:0]];
            end
        end
    end
endmodule

