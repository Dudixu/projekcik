module MoveController (
    input logic clk,                           // Zegar
    input logic rst,                           // Reset
    input logic [63:0] valid_moves,            // 64-bitowa maska możliwych ruchów
    input logic [5:0] selected_position,       // Pozycja wybrana przez gracza
    input logic [2:0] piece_code,              // Kod figury, którą gracz chce przesunąć
    input logic confirm_move,                  // Sygnał zatwierdzenia ruchu przez gracza
    output logic error_message,                // Sygnał błędu: ruch nie dozwolony
    output logic update_board,                 // Sygnał aktualizacji planszy
    output logic [5:0] position_to_update      // Pozycja do zaktualizowania na planszy
);

    logic [5:0] current_position;              // Bieżąca pozycja figury
    logic valid_move;                          // Flaga sprawdzająca czy ruch jest dozwolony

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            error_message <= 0;
            update_board <= 0;
            position_to_update <= 6'b000000;
        end else begin
            if (confirm_move) begin
                // Sprawdzanie, czy wybrane pole jest dozwolone
                if (valid_moves[selected_position]) begin
                    valid_move <= 1;
                    error_message <= 0;
                    update_board <= 1;
                    position_to_update <= selected_position;
                end else begin
                    valid_move <= 0;
                    error_message <= 1;
                    update_board <= 0;
                end
            end else begin
                update_board <= 0;
                error_message <= 0;
            end
        end
    end

endmodule