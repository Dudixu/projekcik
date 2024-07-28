//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company : AGH University of Krakow
// Create Date : 28.07.2024
// Designers Name : Dawid Mironiuk & Michał Malara
// Module Name : transmission
// Project Name : SZACHY - Projekt zaliczeniowy
// Target Devices : BASYS3
// 
// Description : Moduł odpowiedzialny za transmisje UART miedzy płytkami BASYS3
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`default_nettype none

module transmission
(
    parameter int BUFFER_SIZE = 16,
    parameter int CLOCK = 65000000,
    parameter int BAUD = 9600
)
(
    input wire clk_in,
    input wire rst_in,
    input wire valid_in,
    input wire [BUFFER_SIZE-1:0] data_in,
    output logic tx_out,
    output logic ready_out
);

    localparam int DIVISOR = CLOCK / BAUD;
    localparam int DATA_FRAME = 8;

    typedef enum logic [1:0] {IDLE, SEND_DATA, END_SEND} transmission_state;

    logic [BUFFER_SIZE-1:0] data;
    logic [$clog2(BUFFER_SIZE):0] data_ptr;
    logic [$clog2(DIVISOR)-1:0] baud_count;
    logic [9:0] frame;
    logic [3:0] frame_count;

    transmission_state state;

    always_ff @(posedge clk_in or posedge rst_in) begin
        if (rst_in) begin
            state <= IDLE;
            baud_count <= 0;
            frame <= 10'b11_1111_1111;
            frame_count <= 0;
            data_ptr <= 0;
            ready_out <= 1'b0;
            tx_out <= 1'b1;
        end else begin
            case (state)
                IDLE: begin
                    if (valid_in) begin
                        state <= SEND_DATA;
                        frame_count <= 0;
                        frame <= {1'b1, data_in[data_ptr +: DATA_FRAME], 1'b0};
                        data <= data_in;
                        ready_out <= 1'b0;
                        baud_count <= 0;
                    end
                end

                SEND_DATA: begin
                    if (baud_count == DIVISOR - 1) begin
                        baud_count <= 0;
                        tx_out <= frame[0];
                        if (frame_count == DATA_FRAME + 1) begin
                            data_ptr <= data_ptr + DATA_FRAME;
                            if (data_ptr == BUFFER_SIZE - DATA_FRAME) begin
                                state <= END_SEND;
                            end else begin
                                frame <= {1'b1, data[data_ptr + DATA_FRAME +: DATA_FRAME], 1'b0};
                                frame_count <= 0;
                            end
                        end else begin
                            frame_count <= frame_count + 1;
                            frame <= frame >> 1;
                        end
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end

                END_SEND: begin
                    state <= IDLE;
                    ready_out <= 1'b1;
                    tx_out <= 1'b1;
                    data_ptr <= 0;
                    frame_count <= 0;
                    baud_count <= 0;
                end
            endcase
        end
    end

endmodule

