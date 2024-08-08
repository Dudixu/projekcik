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
        // MODYFIKACJA POSZCEGÓLNYCH POZYCJI W TRAKCIE ROZGRYWKI ////////////////////////////////////////////////////////////////////

        end else begin
            if (place_piece == 1 & piece_already_picked == 1) begin
                board[figure_position[5:3]][figure_position[2:0]] <= figure_taken;     // WPISANIE KODU FIGURY //
                piece_already_picked <= '0;
            end else if (pick_piece == 1 & piece_already_picked == 0 & board[figure_position[5:3]][figure_position[2:0]] != '0) begin
                figure_taken <= board[figure_position[5:3]][figure_position[2:0]];
                board[figure_position[5:3]][figure_position[2:0]] <= 4'h0;            // USUNIECIE KODU FIGURY //
                piece_already_picked <= '1;
                pp_pos <= figure_position;
            end 
            if(board[0][0] == 0)begin
                board[0][0] <= possible_moves[62] ? 4'hD:board[0][0];
            end else if(board[0][1] == 0)begin
                board[0][1] <= possible_moves[62] ? 4'hD:board[0][1];
            end else if(board[0][2] == 0)begin
                board[0][2] <= possible_moves[61] ? 4'hD:board[0][2];
            end else if(board[0][3] == 0)begin
                board[0][3] <= possible_moves[60] ? 4'hD:board[0][3];
            end else if(board[0][4] == 0)begin
                board[0][4] <= possible_moves[59] ? 4'hD:board[0][4];
            end else if(board[0][5] == 0)begin
                board[0][5] <= possible_moves[58] ? 4'hD:board[0][5];
            end else if(board[0][6] == 0)begin
                board[0][6] <= possible_moves[57] ? 4'hD:board[0][6];
            end else if(board[0][7] == 0)begin
                board[0][7] <= possible_moves[56] ? 4'hD:board[0][7];
            
            end else if(board[1][0] == 0)begin
                board[1][0] <= possible_moves[55] ? 4'hD:board[1][0];
            end else if(board[1][1] == 0)begin
                board[1][1] <= possible_moves[54] ? 4'hD:board[1][1];
            end else if(board[1][2] == 0)begin
                board[1][2] <= possible_moves[53] ? 4'hD:board[1][2];
            end else if(board[1][3] == 0)begin
                board[1][3] <= possible_moves[52] ? 4'hD:board[1][3];
            end else if(board[1][4] == 0)begin
                board[1][4] <= possible_moves[51] ? 4'hD:board[1][4];
            end else if(board[1][5] == 0)begin
                board[1][5] <= possible_moves[50] ? 4'hD:board[1][5];
            end else if(board[1][6] == 0)begin
                board[1][6] <= possible_moves[49] ? 4'hD:board[1][6];
            end else if(board[1][7] == 0)begin
                board[1][7] <= possible_moves[48] ? 4'hD:board[1][7];  

            end else if(board[2][0] == 0)begin        
                board[2][0] <= possible_moves[47] ? 4'hD:board[2][0];
            end else if(board[2][1] == 0)begin
                board[2][1] <= possible_moves[46] ? 4'hD:board[2][1];
            end else if(board[2][2] == 0)begin
                board[2][2] <= possible_moves[45] ? 4'hD:board[2][2];
            end else if(board[2][3] == 0)begin
                board[2][3] <= possible_moves[44] ? 4'hD:board[2][3];
            end else if(board[2][4] == 0)begin
                board[2][4] <= possible_moves[43] ? 4'hD:board[2][4];
            end else if(board[2][5] == 0)begin
                board[2][5] <= possible_moves[42] ? 4'hD:board[2][5];
            end else if(board[2][6] == 0)begin
                board[2][6] <= possible_moves[41] ? 4'hD:board[2][6];
            end else if(board[2][7] == 0)begin
                board[2][7] <= possible_moves[40] ? 4'hD:board[2][7];
                
            end else if(board[3][0] == 0)begin
                board[3][0] <= possible_moves[39] ? 4'hD:board[3][0];
            end else if(board[3][1] == 0)begin
                board[3][1] <= possible_moves[38] ? 4'hD:board[3][1];
            end else if(board[3][2] == 0)begin
                board[3][2] <= possible_moves[37] ? 4'hD:board[3][2];
            end else if(board[3][3] == 0)begin
                board[3][3] <= possible_moves[36] ? 4'hD:board[3][3];
            end else if(board[3][4] == 0)begin
                board[3][4] <= possible_moves[35] ? 4'hD:board[3][4];
            end else if(board[3][5] == 0)begin
                board[3][5] <= possible_moves[34] ? 4'hD:board[3][5];
            end else if(board[3][6] == 0)begin
                board[3][6] <= possible_moves[33] ? 4'hD:board[3][6];
            end else if(board[3][7] == 0)begin
                board[3][7] <= possible_moves[32] ? 4'hD:board[3][7];

            end else if(board[4][0] == 0)begin
                board[4][0] <= possible_moves[31] ? 4'hD:board[4][0];
            end else if(board[4][1] == 0)begin
                board[4][1] <= possible_moves[30] ? 4'hD:board[4][1];
            end else if(board[4][2] == 0)begin
                board[4][2] <= possible_moves[29] ? 4'hD:board[4][2];
            end else if(board[4][3] == 0)begin
                board[4][3] <= possible_moves[28] ? 4'hD:board[4][3];
            end else if(board[4][4] == 0)begin
                board[4][4] <= possible_moves[27] ? 4'hD:board[4][4];
            end else if(board[4][5] == 0)begin
                board[4][5] <= possible_moves[26] ? 4'hD:board[4][5];
            end else if(board[4][6] == 0)begin
                board[4][6] <= possible_moves[25] ? 4'hD:board[4][6];
            end else if(board[4][7] == 0)begin
                board[4][7] <= possible_moves[24] ? 4'hD:board[4][7];

            end else if(board[5][0] == 0)begin
                board[5][0] <= possible_moves[23] ? 4'hD:board[5][0];
            end else if(board[5][1] == 0)begin
                board[5][1] <= possible_moves[22] ? 4'hD:board[5][1];
            end else if(board[5][2] == 0)begin
                board[5][2] <= possible_moves[21] ? 4'hD:board[5][2];
            end else if(board[5][3] == 0)begin
                board[5][3] <= possible_moves[20] ? 4'hD:board[5][3];
            end else if(board[5][4] == 0)begin
                board[5][4] <= possible_moves[19] ? 4'hD:board[5][4];
            end else if(board[5][5] == 0)begin
                board[5][5] <= possible_moves[18] ? 4'hD:board[5][5];
            end else if(board[5][6] == 0)begin
                board[5][6] <= possible_moves[17] ? 4'hD:board[5][6];
            end else if(board[5][7] == 0)begin
                board[5][7] <= possible_moves[16] ? 4'hD:board[5][7];

            end else if(board[6][0] == 0)begin
                board[6][0] <= possible_moves[15] ? 4'hD:board[6][0];
                board[6][1] <= possible_moves[14] ? 4'hD:board[6][1];
                board[6][2] <= possible_moves[13] ? 4'hD:board[6][2];
                board[6][3] <= possible_moves[12] ? 4'hD:board[6][3];
                board[6][4] <= possible_moves[11] ? 4'hD:board[6][4];
                board[6][5] <= possible_moves[10] ? 4'hD:board[6][5];
                board[6][6] <= possible_moves[9] ? 4'hD:board[6][6];
                board[6][7] <= possible_moves[8] ? 4'hD:board[6][7];   

                board[7][0] <= possible_moves[7] ? 4'hD:board[7][0];
                board[7][1] <= possible_moves[6] ? 4'hD:board[7][1];
                board[7][2] <= possible_moves[5] ? 4'hD:board[7][2];
                board[7][3] <= possible_moves[4] ? 4'hD:board[7][3];
                board[7][4] <= possible_moves[3] ? 4'hD:board[7][4];
                board[7][5] <= possible_moves[2] ? 4'hD:board[7][5];
                board[7][6] <= possible_moves[1] ? 4'hD:board[7][6];
                board[7][7] <= possible_moves[0] ? 4'hD:board[7][7];   
        end
        figure_code <= board[figure_xy[5:3]][figure_xy[2:0]];
    end

endmodule

