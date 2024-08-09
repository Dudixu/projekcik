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
        result[position - 8] = 1;
    end
    else if(board[row - 1 ][col - 1] > 4'H6 & col != 0)begin
        result[((row - 1) * 8 - col - 1)] = 1;
    end
    else if(board[row - 1][col + 1] > 4'H6 & col != 7)begin
         result[((row - 1) * 8 - col + 1)] = 1;
    end
    else if(row == 6 & board[row - 2][col] == 4'h0) begin
        result[position - 16] = 1;
    end
end 
// RUCHY PIONKA CZARNEGO //
else if(selectrd_figure == 4'h7)begin
    if(board[row +1][col] == 4'H0)begin
        result[position + 8] = 1;
    end
    else if(board[row + 1 ][col + 1] < 4'H7 & col != 7)begin
        result[((row + 1) * 8 - col + 1)] = 1;
    end
    else if(board[row + 1][col - 1] < 4'H7 & col != 0)begin
        result[((row + 1) * 8 - col - 1)] = 1;
    end
    else if(row == 1 & board[row + 2][col] == 4'h0) begin
        result[position + 16] = 1;
    end
end 
// RUCHY GOŃCÓW ( i królowych)//
    
else if(selected_figure == 4'h2 | selected_figure == 4'h8 | selected_figure == 4'h5 | selected_figure == 4'hB)begin
    // prawy dół //
    for(int i = 1; i < 8; i++)begin
        if(col + i < 8 & row + i < 8 & board[row + i][col +i] == 0)begin
            result[(row + i) * 8 + (col + i)] = 1;
        end else if(col + i < 8 & row + i < 8 & board[row + i][col + i] > 4'h6 & (selected_figure == 4'h2 | selected_figure == 4'h5))begin
            result[(row + i) * 8 + (col + i)] = 1;
            break;
        end else if(col + i < 8 & row + i < 8 & board[row + i][col + i] < 4'h7 & (selected_figure == 4'h8 | selected_figure == 4'hB))begin
            result[(row + i) * 8 + (col + i)] = 1;
            break;
        end else begin
            break;
        end
    end
    // lewy dól //
    for(int i = 1; i < 8; i++)begin
        if(col - i >= 0 & row + i < 8 & board[row + i][col - i] == 0)begin
            result[(row + i) * 8 + (col - i)] = 1;
        end else if(col - i >= 0 & row + i < 8 & board[row + i][col - i] > 4'h6 & (selected_figure == 4'h2 | selected_figure == 4'h5))begin
            result[(row + i) * 8 + (col - i)] = 1;
            break;
        end else if(col - i >= 0 & row + i < 8 & board[row + i][col - i] < 4'h7 & (selected_figure == 4'h8 | selected_figure == 4'hB))begin
            result[(row + i) * 8 + (col - i)] = 1;
            break;
        end else begin
            break;
        end
    end 
    // prawa góra //
    for(int i = 1; i < 8; i++)begin
        if(col + i < 8 & row - i >= 0 & board[row - i][col + i] == 0)begin
            result[(row - i) * 8 + (col + i)] = 1;
        end else if(col + i < 8 & row - i >= 0 & board[row - i][col + i] > 4'h6 & (selected_figure == 4'h2 | selected_figure == 4'h5))begin
            result[(row - i) * 8 + (col + i)] = 1;
            break;
        end else if(col + i < 8 & row - i >= 0 & board[row - i][col + i] < 4'h7 & (selected_figure == 4'h8 | selected_figure == 4'hB))begin
            result[(row - i) * 8 + (col + i)] = 1;
            break;
        end else begin
            break;
        end
    end
    // lewa góra //
    for(int i = 1; i < 8; i++)begin
        if(col - i >= 0 & row - i >= 0 & board[row - i][col - i] == 0)begin
            result[(row - i) * 8 + (col - i)] = 1;
        end else if(col - i >= 0 & row - i >= 0 & board[row - i][col - i] > 4'h6 & (selected_figure == 4'h2 | selected_figure == 4'h5))begin
            result[(row - i) * 8 + (col - i)] = 1;
            break;
        end else if(col - i >= 0 & row - i >= 0 & board[row - i][col - i] < 4'h7 & (selected_figure == 4'h8 | selected_figure == 4'hB))begin
            result[(row - i) * 8 + (col - i)] = 1;
            break;
        end else begin
            break;
        end
    end
end     
// RUCHY WIEŻ ( i Królowych) //
else if(selected_figure == 4'h4 | selected_figure == 4'hA | selected_figure == 4'h5 | selected_figure == 4'hB)begin 
    // GÓRA //
    for(int i = 1; i < 8; i++)begin
        if(row - i >= 0 & board[row-i][col] == 0)begin
            result[(row - i) * 8 + col] = 1;
        end else if(row - i >= 0 & board[row-i][col] > 4'h6 & (selected_figure == 4'h4 | selected_figure == 4'h5))begin
            result[(row - i) * 8 + col] = 1;
            break;
        end else if(row - i >= 0 & board[row-i][col] < 4'h7 & (selected_figure == 4'hA | selected_figure == 4'hB))begin
            result[(row - i) * 8 + col] = 1;
            break;
        end else begin
            break;
        end
    end
    // dół //
    for(int i = 1; i < 8; i++)begin
        if(row + i < 8 & board[row+i][col] == 0)begin
            result[(row + i) * 8 + col] = 1;
        end else if(row + i < 8 & board[row+i][col] > 4'h6 & (selected_figure == 4'h4 | selected_figure == 4'h5))begin
            result[(row + i) * 8 + col] = 1;
            break;
        end else if(row + i < 8 & board[row+i][col] < 4'h7 & (selected_figure == 4'hA | selected_figure == 4'hB))begin
            result[(row + i) * 8 + col] = 1;
            break;
        end else begin
            break;
        end
    end
    // LEWO // 
    for(int i = 1; i < 8; i++)begin
        if(col - i >= 0 & board[row][col - i] == 0)begin
            result[(col - i) * 8 + col] = 1;
        end else if(col - i >= 0 & board[row][col - i] > 4'h6 & (selected_figure == 4'h4 | selected_figure == 4'h5))begin
            result[row * 8 + col - i] = 1;
            break;
        end else if(col - i >= 0 & board[row][col - i] < 4'h7 & (selected_figure == 4'hA | selected_figure == 4'hB))begin
            result[row * 8 + col - i] = 1;
            break;
        end else begin
            break;
        end
    end
    
    // PRAWO //
    for(int i = 1; i < 8; i++)begin
        if(col + i >= 0 & board[row][col + i] == 0)begin
            result[(col + i) * 8 + col] = 1;
        end else if(col + i < 8 & board[row][col + i] > 4'h6 & (selected_figure == 4'h4 | selected_figure == 4'h5))begin
            result[row * 8 + col + i] = 1;
            break;
        end else if(col + i < 8 & board[row][col + i] < 4'h7 & (selected_figure == 4'hA | selected_figure == 4'hB))begin
            result[row * 8 + col + i] = 1;
            break;
        end else begin
            break;
        end
    end
// RUCHY KONIA BIAŁEGO //
else if(selected_figure == 4'h3)begin
    
    if(board[row - 2][col + 1] == 4'h0 | board[row - 2][col + 1] > 4'h6)begin
        result[(row - 2)*8 + col + 1] = 1;
    end else if(board[row - 2][col - 1] == 4'h0 | board[row - 2][col - 1] > 4'h6)begin
        result[(row - 2)*8 + col - 1] = 1;
    end else if(board[row + 2][col + 1] == 4'h0 | board[row + 2][col +1] > 4'h6)begin
        result[(row + 2)*8 + col + 1] = 1;
    end else if(board[row + 2][col - 1] == 4'h0 | board[row + 2][col - 1] > 4'h6)begin
        result[(row + 2)*8 + col - 1] = 1;
    end else if(board[row - 1][col + 2] == 4'h0 | board[row - 1][col + 2] > 4'h6)begin
        result[(row - 1)*8 + col + 2] = 1;
    end else if(board[row - 1][col - 2] == 4'h0 | board[row - 1][col - 2] > 4'h6)begin
        result[(row - 1)*8 + col - 2] = 1;
    end else if(board[row + 1][col + 2] == 4'h0 | board[row + 1][col + 2] > 4'h6)begin
        result[(row + 1)*8 + col + 2] = 1;
    end else if(board[row + 1][col - 2] == 4'h0 | board[row + 1][col - 2] > 4'h6)begin
        result[(row + 1)*8 + col - 2] = 1;
    end else begin
    end
end
// RUCHY CZARNEGO KONIA //    
else if(selected_figure == 4'h9)begin
    
    if(board[row - 2][col + 1] == 4'h0 | board[row - 2][col + 1] < 4'h7)begin
        result[(row - 2)*8 + col + 1] = 1;
    end else if(board[row - 2][col - 1] == 4'h0 | board[row - 2][col - 1] < 4'h7)begin
        result[(row - 2)*8 + col - 1] = 1;
    end else if(board[row + 2][col + 1] == 4'h0 | board[row + 2][col +1] < 4'h7)begin
        result[(row + 2)*8 + col + 1] = 1;
    end else if(board[row + 2][col - 1] == 4'h0 | board[row + 2][col - 1] < 4'h7)begin
        result[(row + 2)*8 + col - 1] = 1;
    end else if(board[row - 1][col + 2] == 4'h0 | board[row - 1][col + 2] < 4'h7)begin
        result[(row - 1)*8 + col + 2] = 1;
    end else if(board[row - 1][col - 2] == 4'h0 | board[row - 1][col - 2] < 4'h7)begin
        result[(row - 1)*8 + col - 2] = 1;
    end else if(board[row + 1][col + 2] == 4'h0 | board[row + 1][col + 2] < 4'h7)begin
        result[(row + 1)*8 + col + 2] = 1;
    end else if(board[row + 1][col - 2] == 4'h0 | board[row + 1][col - 2] < 4'h7)begin
        result[(row + 1)*8 + col - 2] = 1;
    end else begin
    end
end
//bialy król//
else if(selected_figure == 4'h6)begin
    
    if(board[row - 1][col + 1] == 4'h0 | board[row - 1][col + 1] > 4'h6)begin
        result[(row - 1)*8 + col + 1] = 1;
    end else if(board[row - 1][col - 1] == 4'h0 | board[row - 1][col - 1] > 4'h6)begin
        result[(row - 1)*8 + col - 1] = 1;
    end else if(board[row + 1][col + 1] == 4'h0 | board[row + 1][col + 1] > 4'h6)begin
        result[(row + 1)*8 + col + 1] = 1;
    end else if(board[row + 1][col - 1] == 4'h0 | board[row + 1][col - 1] > 4'h6)begin
        result[(row + 1)*8 + col - 1] = 1;
    end else if(board[row - 1][col + 1] == 4'h0 | board[row - 1][col + 1] > 4'h6)begin
        result[(row - 1)*8 + col + 1] = 1;
    end else if(board[row - 1][col - 1] == 4'h0 | board[row - 1][col - 1] > 4'h6)begin
        result[(row - 1)*8 + col - 1] = 1;
    end else if(board[row + 1][col + 1] == 4'h0 | board[row + 1][col + 1] > 4'h6)begin
        result[(row + 1)*8 + col + 1] = 1;
    end else if(board[row + 1][col - 1] == 4'h0 | board[row + 1][col - 1] > 4'h6)begin
        result[(row + 1)*8 + col - 1] = 1;
    end else if(position == 60 & board[7][5] == 4'h0 & board[7][6] == 4'h0 & board[7][7] == 4'h4)begin
        result[62] = 1;
    end else if(position == 60 & board[7][1] == 4'h0 & board[7][2] == 4'h0 & board[7][3] == 4'h0 & board[7][0] == 4'h4)begin
        result[58] = 1;
    end else begin
    end
end    
// czarny król //
else if(selected_figure == 4'hC)begin

    
    if(board[row - 1][col + 1] == 4'h0 | board[row - 1][col + 1] < 4'h7)begin
        result[(row - 1)*8 + col + 1] = 1;
    end else if(board[row - 1][col - 1] == 4'h0 | board[row - 1][col - 1] < 4'h7)begin
        result[(row - 1)*8 + col - 1] = 1;
    end else if(board[row + 1][col + 1] == 4'h0 | board[row + 1][col +1] < 4'h7)begin
        result[(row + 1)*8 + col + 1] = 1;
    end else if(board[row + 1][col - 1] == 4'h0 | board[row + 1][col - 1] < 4'h7)begin
        result[(row + 1)*8 + col - 1] = 1;
    end else if(board[row - 1][col + 1] == 4'h0 | board[row - 1][col + 1] < 4'h7)begin
        result[(row - 1)*8 + col + 1] = 1;
    end else if(board[row - 1][col - 1] == 4'h0 | board[row - 1][col - 1] < 4'h7)begin
        result[(row - 1)*8 + col - 1] = 1;
    end else if(board[row + 1][col + 1] == 4'h0 | board[row + 1][col + 1] < 4'h7)begin
        result[(row + 1)*8 + col + 1] = 1;
    end else if(board[row + 1][col - 1] == 4'h0 | board[row + 1][col - 1] < 4'h7)begin
        result[(row + 1)*8 + col - 1] = 1;
    end else if(position == 4 & board[0][1] == 0'h0 & board[0][2] == 0'h0 & board[0][3] == 0'h0 & board[0][0] == 4'hA)begin
        result[2] = 1;
    end else if(position == 4 & board[0][5] == 4'h0 & board[0][6] == 0'h0 & board[0][7] == 0'hA)begin
        result[6] = 1;
    end else begin
    end
end
else begin
    result = 0;
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
