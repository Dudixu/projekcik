///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
//Company : AGH University of Krakow
// Create Date : 07.08.2024
// Designers Name : Dawid Mironiuk & Michał Malara
// Module Name : check_king_safety
// Project Name : SZACHY - Projekt zaliczeniowy
// Target Devices : BASYS3
// 
// Description : Moduł odpowiada za sprawdzenie czy Król jest atakowany
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module check_king_safety 
(
    input logic [2:0] board [7:0][7:0],    // Aktualna plansza
    input logic [5:0] king_position,       // Pozycja króla
    output logic king_in_check             // Sygnał szacha
);

    logic [2:0] king_row, king_col;

    // Możliwe ruchy skoczka ///////////////////////////////////////////////////////////////////////////////////////////////////////

    const int knight_moves[8][2] = '{'{-2, -1}, '{-2,  1}, '{-1, -2}, '{-1,  2}, '{ 1, -2}, '{ 1,  2}, '{ 2, -1}, '{ 2,  1} };

    // SPRAWDZANIE WSZYSTKICH MOŻLIWYCH KOMBINACJI PÓL W PRZYPADKU SZACHU ////////////////////////////////////////////////////////////
    always_comb begin
        king_in_check = 0;
        king_row = king_position[5:3];
        king_col = king_position[2:0];

        // SKOSY - GONIEC I KRÓLOWA /////////////////////////////////////////////////////////////////////////////////////////////////
        
        // Lewo-góra //
        for (int i = 1; (king_row - i >= 0) && (king_col - i >= 0); i++) begin
            if (board[king_row - i][king_col - i] == 3'b011 || board[king_row - i][king_col - i] == 3'b111) begin
                king_in_check = 1;
                break;
            end else if (board[king_row - i][king_col - i] != 3'b000) begin
                break;
            end
        end

        // Prawo-góra //
        for (int i = 1; (king_row - i >= 0) && (king_col + i < 8); i++) begin
            if (board[king_row - i][king_col + i] == 3'b011 || board[king_row - i][king_col + i] == 3'b111) begin
                king_in_check = 1;
                break;
            end else if (board[king_row - i][king_col + i] != 3'b000) begin
                break;
            end
        end

        // Lewo-dół //
        for (int i = 1; (king_row + i < 8) && (king_col - i >= 0); i++) begin
            if (board[king_row + i][king_col - i] == 3'b011 || board[king_row + i][king_col - i] == 3'b111) begin
                king_in_check = 1;
                break;
            end else if (board[king_row + i][king_col - i] != 3'b000) begin
                break;
            end
        end

        // Prawo-dół //
        for (int i = 1; (king_row + i < 8) && (king_col + i < 8); i++) begin
            if (board[king_row + i][king_col + i] == 3'b011 || board[king_row + i][king_col + i] == 3'b111) begin
                king_in_check = 1;
                break;
            end else if (board[king_row + i][king_col + i] != 3'b000) begin
                break;
            end
        end

        // PION I POZIOM - RUCHY KRÓLOWEJ I WIEŻY ////////////////////////////////////////////////////////////////////////////////////
        
        // Lewo //
        for (int c = king_col - 1; c >= 0; c--) begin
            if (board[king_row][c] == 3'b100 || board[king_row][c] == 3'b111) begin
                king_in_check = 1;
                break;
            end else if (board[king_row][c] != 3'b000) begin
                break;
            end
        end

        // Prawo //
        for (int c = king_col + 1; c < 8; c++) begin
            if (board[king_row][c] == 3'b100 || board[king_row][c] == 3'b111) begin
                king_in_check = 1;
                break;
            end else if (board[king_row][c] != 3'b000) begin
                break;
            end
        end

        // Góra //
        for (int r = king_row - 1; r >= 0; r--) begin
            if (board[r][king_col] == 3'b100 || board[r][king_col] == 3'b111) begin
                king_in_check = 1;
                break;
            end else if (board[r][king_col] != 3'b000) begin
                break;
            end
        end

        // Dół //
        for (int r = king_row + 1; r < 8; r++) begin
            if (board[r][king_col] == 3'b100 || board[r][king_col] == 3'b111) begin
                king_in_check = 1;
                break;
            end else if (board[r][king_col] != 3'b000) begin
                break;
            end
        end

        // LEWY I PRAWY GÓRNY RÓG - POZYCJE PIONÓW //////////////////////////////////////////////////////////////////////////////////////////////////////
        
        // Lewo-góra //
        if (king_row > 0 && king_col > 0) begin
            if (board[king_row - 1][king_col - 1] == 3'b001) begin
                king_in_check = 1;
            end
        end

        // Prawo-góra //
        if (king_row > 0 && king_col < 7) begin
            if (board[king_row - 1][king_col + 1] == 3'b001) begin
                king_in_check = 1;
            end
        end

        // POLA WOKÓŁ KRÓLA - POZYCJE WROGIEGO KRÓLA I KRÓLOWEJ ////////////////////////////////////////////////////////////////////////////////////////////////

        for (int dr = -1; dr <= 1; dr++) begin
            for (int dc = -1; dc <= 1; dc++) begin
                if (dr != 0 || dc != 0) begin
                    int row = king_row + dr;
                    int col = king_col + dc;
                    if (row >= 0 && row < 8 && col >= 0 && col < 8) begin
                        if (board[row][col] == 3'b110 || board[row][col] == 3'b111) begin
                            king_in_check = 1;
                        end
                    end
                end
            end
        end

        // POLA KONIA ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       
        for (int i = 0; i < 8; i++) begin
            int row = king_row + knight_moves[i][0];
            int col = king_col + knight_moves[i][1];
            if (row >= 0 && row < 8 && col >= 0 && col < 8) begin
                if (board[row][col] == 3'b010) begin
                    king_in_check = 1;
                end
            end
        end
    end

endmodule
