///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
//Company : AGH University of Krakow
// Create Date : 28.07.2024
// Designers Name : Dawid Mironiuk & Michał Malara
// Module Name : figure_move_logic
// Project Name : SZACHY - Projekt zaliczeniowy
// Target Devices : BASYS3
// 
// Description : Moduł podaje mozliwości ruchu wybranej figury oraz potwierdza legalność ruchu 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module figure_move_logic 
(
    input logic clk,
    input logic rst,
    input logic [3:0] selected_figure,         // 5-bit kod figury: 0001 - pion biały 1, 0111 - pion czarny...
    input logic [3:0] board [7:0][7:0],        // Macierz 8x8 zawierająca kody figur, mijesce w macierzy odpowiada mijscu na planszy
    input logic [5:0] position,                // 6-bitowa pozycja na planszy: [2:0] - kolumna (0-7), [5:3] - wiersz (0-7)
    output logic [63:0] possible_moves         // 64-bitowa maska możliwych ruchów (1 bit na pole planszy)
);

    // Definicje kolumn i wierszy z pozycji
    logic [2:0] col;
    logic [2:0] row;
    logic [63:0] result;

    assign col = position[2:0];
    assign row = position[5:3];

always_comb begin

// RUCHY PIONKA BIAŁEGO //
if(selected_figure == 4'H1)begin
    if(board[row - 1][col] == 4'H0)begin
        result[63 - position - 8] = 1;
    end
    else if(board[row - 1 ][col - 1] > 4'H6)begin
        result[63 - ((row - 1) * 8 - col - 1)] = 1;
    end
    else if(board[row - 1][col + 1] > 4'H6)begin
         result[63 - ((row - 1) * 8 - col + 1)] = 1;
    end
    else if(row == 6) begin
        result[63 - position - 16] = 1;
    end
end

end

always_ff @(posedge clk, posedge rst)begin
    if(rst)begin
        possible_moves <= 0;
    end
    else begin
        possible_moves <= result;
    end
end

endmodule
