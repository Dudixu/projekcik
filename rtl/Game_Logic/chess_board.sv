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
    output logic [3:0] board [7:0][0:7],       // Macierz 8x8 zawierająca kody figur
    output logic [3:0] figure_code,            // kod figury znajduącej się w miejscu figure_xy
    output logic [3:0] figure_taken
);

    

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
            figure_taken <= 0;
        // MODYFIKACJA POSZCEGÓLNYCH POZYCJI W TRAKCIE ROZGRYWKI ////////////////////////////////////////////////////////////////////

        end else begin
            if (place_piece) begin
                board[figure_position[5:3]][figure_position[2:0]] <= figure_taken;     // WPISANIE KODU FIGURY //
            end else if (pick_piece) begin
                figure_taken <= board[figure_position[5:3]][figure_position[2:0]];
                board[figure_position[5:3]][figure_position[2:0]] <= 4'h0;            // USUNIECIE KODU FIGURY //
            end
        end
        figure_code <= board[figure_xy[5:3]][figure_xy[2:0]];
    end

endmodule

