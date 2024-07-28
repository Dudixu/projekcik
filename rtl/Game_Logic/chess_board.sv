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
    input logic [4:0] figure_code,             // 5-bit kod figury
    input logic [5:0] figure_position,         // 6-bitowa pozycja: [2:0] - kolumna (0-7), [5:3] - wiersz (0-7)
    input logic place_piece,                   // Sygnał umieszczania figury na planszy
    input logic remove_piece,                  // Sygnał usuwania figury z planszy
    output logic [2:0] board [7:0][7:0]        // Macierz 8x8 zawierająca kody figur
);

    
    always_ff @(posedge clk or posedge rst) begin
        
        // INICIALIZACJA PLANSZY ////////////////////////////////////////////////////////////////////////////////////////////////////

        if (rst) begin

            // FIGURY //
            board[0] <= {4'hA, 4'h9, 4'h8, 4'hB, 4'hC, 4'h8, 4'h9, 4'hA}; // Figury czarne  1 wiersz
            board[1] <= {4'h7, 4'h7, 4'h7, 4'h7, 4'h7, 4'h7, 4'h7, 4'h7}; // Piony czarne 2 wiersz
            board[6] <= {4'h1, 4'h1, 4'h1, 4'h1, 4'h1, 4'h1, 4'h1, 4'h1}; // Piony białe 7 wiersz
            board[7] <= {4'h4, 4'h3, 4'h2, 4'h5, 4'h6, 4'h2, 4'h3, 4'h4}; // Figury białe 8 wiersz

            // PUSTE POLA //
            for (int i = 2; i < 6; i++) begin
                for (int j = 0; j < 8; j++) begin
                    board[i][j] <= 4'h0;          
                end
            end

        // MODYFIKACJA POSZCEGÓLNYCH POZYCJI W TRAKCIE ROZGRYWKI ////////////////////////////////////////////////////////////////////

        end else begin
            if (place_piece) begin
                board[position[5:3]][position[2:0]] <= figure_code;
            end else if (remove_piece) begin
                board[position[5:3]][position[2:0]] <= 4'h0;
            end
        end
    end

endmodule

