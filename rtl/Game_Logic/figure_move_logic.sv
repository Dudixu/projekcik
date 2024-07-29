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
    input logic [4:0] selected_figure,         // 5-bit kod figury: 0001 - pion biały 1, 10001 - pion czarny...
    input logic [2:0] board [7:0][7:0],        // Macierz 8x8 zawierająca kody figur, mijesce w macierzy odpowiada mijscu na planszy
    input logic [5:0] position,                // 6-bitowa pozycja na planszy: [2:0] - kolumna (0-7), [5:3] - wiersz (0-7)
    output logic [63:0] possible_moves         // 64-bitowa maska możliwych ruchów (1 bit na pole planszy)
);

    // Definicje kolumn i wierszy z pozycji
    logic [2:0] col;
    logic [2:0] row;

    assign col = position[2:0];
    assign row = position[5:3];

    // Maska wszystkich możliwych ruchów
    logic [63:0] moves;



    // OBLICZANIE MOZLIWYCH RUCHÓW PIONKA ///////////////////////////////////////////////////////////////////////////////////////////
    
    function logic [63:0] pawn_moves
    (
    input logic [2:0] col, 
    input logic [2:0] row, 
    input logic [2:0] board [7:0][7:0]
    );

        logic [63:0] result;
        result = 0;
        // Ruch do przodu
        if (row < 7 && board[row+1][col] == 0) begin
            result[(row+1)*8 + col] = 1;
        end
        // Dwa pola do przodu przy pierwszym ruchu
        if (row == 1 && board[row+1][col] == 0 && board[row+2][col] == 0) begin
            result[(row+2)*8 + col] = 1;
        end
        // Bicie po przekątnych
        if (row < 7 && col > 0 && board[row+1][col-1][3] != 0) begin
            result[(row+1)*8 + (col-1)] = 1;
        end
        if (row < 7 && col < 7 && board[row+1][col+1][3] != 0) begin
            result[(row+1)*8 + (col+1)] = 1;
        end
        return result;
    endfunction

    // OBLICZANIE MOZLIWYCH RUCHÓW WIEZY ////////////////////////////////////////////////////////////////////////////////////////////
    
    function logic [63:0] rook_moves
    (
        input logic [2:0] col, 
        input logic [2:0] row, 
        input logic [2:0] board [7:0][7:0]
    );

        logic [63:0] result;
        result = 0;

        /*
        for (int i = 0; i < 8; i++) begin
            if (i != row && board[i][col] == 0) result[i*8 + col] = 1;  // pionowe ruchy
            if (i != col && board[row][i] == 0) result[row*8 + i] = 1;  // poziome ruchy
        end
        */

        // Ruch w prawo
            for (int c = col + 1; c < 8; c++) begin
                if (board[row][c] == 4'h0) begin
                    result[row * 8 + c] = 1;
                end else begin
                    result[row * 8 + c] = 0;
                    break;
                end
            end
        // Ruch w lewo
            for (int c = col - 1; c >= 0; c--) begin
                if (board[row][c] == 4'h0) begin
                    result[row * 8 + c] = 1;
                end else begin
                    result[row * 8 + c] = 1;
                    break;
                end
            end
        // Ruch w dół
            for (int r = row + 1; r < 8; r++) begin
                if (board[r][col] == 4'h0) begin
                    result[r * 8 + col] = 1;
                end else begin
                    result[r * 8 + col] = 1;
                    break;
                end
            end
        // Ruch w górę
            for (int r = row - 1; r >= 0; r--) begin
                if (board[r][col] == 4'h0) begin
                    result[r * 8 + col] = 1;
                end else begin
                    result[r * 8 + col] = 1;
                    break;
                end
            end    
        return result;
    endfunction

    // OBLICZANIE MOZLIWYCH RUCHÓW SKOCZKA //////////////////////////////////////////////////////////////////////////////////////////
    
    function logic [63:0] knight_moves
    (
        input logic [2:0] col, 
        input logic [2:0] row, 
        input logic [2:0] board [7:0][7:0]
    );
        
        logic [63:0] result;
        result = 0;
        int moves[8][2] = '{ '{2, 1}, {2, -1}, {-2, 1}, {-2, -1}, {1, 2}, {1, -2}, {-1, 2}, {-1, -2} };
       
        for (int i = 0; i < 8; i++) begin
            int new_col = col + moves[i][1];
            int new_row = row + moves[i][0];
            if (new_col >= 0 && new_col < 8 && new_row >= 0 && new_row < 8 && board[new_row][new_col] == 0) begin
                result[new_row*8 + new_col] = 1;
            end
        end
        return result;
    endfunction

    // OBLICZANIE MOZLIWYCH RUCHÓW GOŃCA ///////////////////////////////////////////////////////////////////////////////////////////
    
    function logic [63:0] bishop_moves
    (
        input logic [2:0] col, 
        input logic [2:0] row, 
        input logic [2:0] board [7:0][7:0]
    );

        logic [63:0] result;
        result = 0;

        /*
        for (int i = 1; i < 8; i++) begin
            if (col + i < 8 && row + i < 8 && board[row + i][col + i] == 0) result[(row + i)*8 + (col + i)] = 1; // prawa dolna przekątna
            if (col - i >= 0 && row + i < 8 && board[row + i][col - i] == 0) result[(row + i)*8 + (col - i)] = 1; // lewa dolna przekątna
            if (col + i < 8 && row - i >= 0 && board[row - i][col + i] == 0) result[(row - i)*8 + (col + i)] = 1; // prawa górna przekątna
            if (col - i >= 0 && row - i >= 0 && board[row - i][col - i] == 0) result[(row - i)*8 + (col - i)] = 1; // lewa górna przekątna
        end
        */


        // PRAWA DOLNA PRZEKATNA //  
        for (int i = 1; i < 8; i++) begin 
            if (col + i < 8 && row + i < 8 && board[row + i][col + i] == 0) begin
                result[(row + i)*8 + (col + i)] = 1; 
            end
            else begin
                result[(row + i)*8 + (col + i)] = 1;
                break;
            end
        end

        // LEWA DOLNA PRZEKATNA //
        for (int i = 1; i < 8; i++) begin
            if (col - i >= 0 && row + i < 8 && board[row + i][col - i] == 0) begin
                result[(row + i)*8 + (col - i)] = 1; 
            end
            else begin
                result[(row + i)*8 + (col - i)] = 1;
                break;
            end
        end

        // PRAWA GÓRNA PRZEKATNA //
        for (int i = 1; i < 8; i++) begin
            if (col + i < 8 && row - i >= 0 && board[row - i][col + i] == 0) begin
                result[(row - i)*8 + (col + i)] = 1; 
            end
            else begin
                result[(row + i)*8 + (col - i)] = 1;
                break;
            end
        end

        // LEWA GÓRNA PRZEKATNA //
        for (int i = 1; i < 8; i++) begin
            if (col - i >= 0 && row - i >= 0 && board[row - i][col - i] == 0) begin
                result[(row - i)*8 + (col - i)] = 1; 
            end
            else begin
                 result[(row - i)*8 + (col - i)] = 1; 
                 break,
            end
        end

        return result;
    endfunction

    // OBLICZANIE MOZLIWYCH RUCHÓW KRÓLOWEJ /////////////////////////////////////////////////////////////////////////////////////////

    function logic [63:0] queen_moves
    
    (
        input logic [2:0] col, 
        input logic [2:0] row, 
        input logic [2:0] board [7:0][7:0]
    );
        
        return rook_moves(col, row, board) | bishop_moves(col, row, board);

    endfunction

    // OBLICZANIE MOZLIWYCH RUCHÓW KRÓLA ////////////////////////////////////////////////////////////////////////////////////////////

    function logic [63:0] king_moves
    (
        input logic [2:0] col, 
        input logic [2:0] row, 
        input logic [2:0] board [7:0][7:0]
    );

        logic [63:0] result;
        result = 0;

        for (int dc = -1; dc <= 1; dc++) begin
            for (int dr = -1; dr <= 1; dr++) begin
                if (dc != 0 || dr != 0) begin
                    int new_col = col + dc;
                    int new_row = row + dr;
                    if (new_col >= 0 && new_col < 8 && new_row >= 0 && new_row < 8 && board[new_row][new_col] == 0) begin
                        result[new_row*8 + new_col] = 1;
                    end
                end
            end
        end

        return result;
    endfunction

    always_comb begin
        case (selected_figure)

            // KODY FIGUR BIAŁYCH /////////////////////////////////

            4'b0001: possible_moves = pawn_moves(col, row, board); 
            4'b0010: possible_moves = rook_moves(col, row, board);
            4'b0011: possible_moves = knight_moves(col, row, board);
            4'b0100: possible_moves = bishop_moves(col, row, board);
            4'b0101: possible_moves = queen_moves(col, row, board);
            4'b0110: possible_moves = king_moves(col, row, board);
            
            // KODY FIGUR CZARNYCH /////////////////////////////////

            4'b1001: possible_moves = pawn_moves(col, row, board); 
            4'b1010: possible_moves = rook_moves(col, row, board);
            4'b1011: possible_moves = knight_moves(col, row, board);
            4'b1100: possible_moves = bishop_moves(col, row, board);
            4'b1101: possible_moves = queen_moves(col, row, board);
            4'b1110: possible_moves = king_moves(col, row, board);

            default: possible_moves = 0;
        endcase
    end

endmodule
