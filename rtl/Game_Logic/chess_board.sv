/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company : AGH University of Krakow
// Create Date : 28.07.2024
// Designers Name : Dawid Mironiuk & Michał Malara
// Module Name : chess_board
// Project Name : SZACHY - Projekt zaliczeniowy
// Target Devices : BASYS3
// 
// Description : Zarządzanie planszą podczas gry.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module chess_board 
(
    input logic clk,                           
    input logic rst,                           
    input logic [5:0] figure_xy,               // kod miejsca na planszy
    input logic [5:0] figure_position,         // 6-bitowa pozycja: [2:0] - kolumna (0-7), [5:3] - wiersz (0-7) wspolrzedne z myszki
    input logic pick_place,                    // Sygnał umieszczania figury na planszy                
    input logic [63:0] possible_moves,
    output logic [3:0] board [0:7][0:7],       // Macierz 8x8 zawierająca kody figur
    output logic [3:0] figure_code,            // kod figury znajduącej się w miejscu figure_xy
    output logic [3:0] figure_taken,
    output logic [5:0] pp_pos,
    output logic white_castle,
    output logic black_castle,
    output logic black_win,
    output logic white_win

);
logic piece_already_picked;
    always_ff @(posedge clk) begin
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
            
            // SYGNAŁY //
            pp_pos <= '0;
            figure_taken <= '0;
            figure_code <= '0;
            piece_already_picked <= '0;
            white_castle <= '0;
            black_castle <= '0;
            black_win <= '0;
            white_win <= '0;

        // MODYFIKACJA POSZCEGÓLNYCH POZYCJI W TRAKCIE ROZGRYWKI ////////////////////////////////////////////////////////////////////

        end else begin
            if (pick_place == 0 & piece_already_picked == 1) begin
                pp_pos <= figure_position;

                // PROMOCJA PIONA //
                if(figure_taken == 4'h1 & figure_position[5:3] == 0)begin            
                    board[figure_position[5:3]][figure_position[2:0]] <= 4'h5; 
                end else if(figure_taken == 4'h7 & figure_position[5:3] == 7)begin
                    board[figure_position[5:3]][figure_position[2:0]] <= 4'hB; 

                // ROSZADA BIAŁYCH //
                end else if(figure_position == 62 & board[7][5] == 4'h0 & board[7][6] == 4'h0 & board[7][7] == 4'h4 & figure_taken == 4'h6 & white_castle == 0)begin
                    board[7][7] <= 4'h0;
                    board[7][6] <= 4'h6;
                    board[7][5] <= 4'h4;
                    board[7][4] <= 4'h0;
                    white_castle <= '1;
                end else if(figure_position == 58 & board[7][1] == 4'h0 & board[7][2] == 4'h0 & board[7][3] == 4'h0 & board[7][0] == 4'h4 & figure_taken == 4'h6 & white_castle == 0)begin
                    board[7][0] <= 4'h0;
                    board[7][1] <= 4'h0;
                    board[7][2] <= 4'h6;
                    board[7][3] <= 4'h4;
                    board[7][4] <= 4'h0;
                    white_castle <= '1;

                // ROSZADA CZARNYCH //
                end else if(figure_position == 6 & board[0][5] == 4'h0 & board[0][6] == 4'h0 & board[0][7] == 4'hA & figure_taken == 4'hC & black_castle == 0)begin
                    board[0][7] <= 4'h0;
                    board[0][6] <= 4'hC;
                    board[0][5] <= 4'hA;
                    board[0][4] <= 4'h0;
                    black_castle <= '1;
                end else if(figure_position == 2 & board[0][1] == 4'h0 & board[0][2] == 4'h0 & board[0][3] == 4'h0 & board[0][0] == 4'hA & figure_taken == 4'hC & black_castle == 0)begin
                    board[0][0] <= 4'h0;
                    board[0][1] <= 4'h0;
                    board[0][2] <= 4'hC;
                    board[0][3] <= 4'hA;
                    board[0][4] <= 4'h0;
                    black_castle <= '1;
                
                // ZWYCIĘSTWO CZARNYCH //
                end else if(board[figure_position[5:3]][figure_position[2:0]] == 4'h6)begin
                    black_win <= 1;

                // ZWYCIĘSTWO BIAŁYCH //
                end else if(board[figure_position[5:3]][figure_position[2:0]] == 4'hC)begin
                    white_win <= 1;

                // WPISANIE KODU FIGURY //
                end else begin
                    board[figure_position[5:3]][figure_position[2:0]] <= figure_taken; 
                end    
                figure_taken <= '0;
                piece_already_picked <= '0;

            end else if (pick_place == 1 & piece_already_picked == 0) begin
                figure_taken <= board[figure_position[5:3]][figure_position[2:0]];    // PODNIESIENIE FIGURY //
                board[figure_position[5:3]][figure_position[2:0]] <= 4'h0;            // USUNIECIE KODU FIGURY //
                pp_pos <= figure_position;
                piece_already_picked <= '1;
            end 
        end

        // WPISANIE DO TABLICY MOŻLIWYCH RUCHÓW //
        if(board[figure_xy[5:3]][figure_xy[2:0]] == 0 & possible_moves[figure_xy] == 1)begin
            figure_code <= 4'hD;
        end
        else begin
            figure_code <= board[figure_xy[5:3]][figure_xy[2:0]];
        end
    end
 
endmodule

