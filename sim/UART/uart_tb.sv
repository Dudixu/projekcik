module tb_uart;

  // Parametry UART
  parameter DBIT = 8;    // liczba bitów danych
  parameter SB_TICK = 16; // liczba taktów zegara na bit stopu
  parameter DVSR = 326;   // dzielnik szybkości transmisji
  parameter DVSR_BIT = 9; // liczba bitów dzielnika szybkości transmisji
  parameter FIFO_W = 2;   // szerokość adresu FIFO

  // Zmienne sygnałowe
  reg clk;
  reg reset;
  reg rx;
  reg rd_uart;
  reg wr_uart;
  reg [7:0] w_data;
  wire tx_full;
  wire rx_empty;
  wire tx;
  wire [7:0] r_data;

  // Instancjonowanie modułu uart
  uart #(
    .DBIT(DBIT),
    .SB_TICK(SB_TICK),
    .DVSR(DVSR),
    .DVSR_BIT(DVSR_BIT),
    .FIFO_W(FIFO_W)
  ) uut (
    .clk(clk),
    .reset(reset),
    .rd_uart(rd_uart),
    .wr_uart(wr_uart),
    .rx(rx),
    .w_data(w_data),
    .tx_full(tx_full),
    .rx_empty(rx_empty),
    .tx(tx),
    .r_data(r_data)
  );

  // Generowanie zegara (Clock Generation)
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // zegar o częstotliwości 100 MHz (10 ns okres)
  end

  // Procedura testowa
  initial begin
    // Inicjalizacja
    reset = 1;
    rx = 1;
    rd_uart = 0;
    wr_uart = 0;
    w_data = 8'b0;

    // Resetowanie systemu
    #20;
    reset = 0;

    // Symulacja transmisji UART (RX)
    simulate_rx(8'hAB); // symulowanie odbioru bajtu 0xAB
    simulate_rx(8'hCD); // symulowanie odbioru bajtu 0xCD
    simulate_rx(8'hEF); // symulowanie odbioru bajtu 0xEF

    // Czekanie na zakończenie odbioru danych
    #1000;

    // Symulacja nadawania UART (TX)
    send_byte(8'h12);  // symulowanie wysyłania bajtu 0x12
    send_byte(8'h34);  // symulowanie wysyłania bajtu 0x34

    #1000; // Czekanie na zakończenie transmisji

    $stop; // Zakończenie symulacji
  end

  // Symulacja odbioru UART
  task simulate_rx(input [7:0] byte);
    integer i;
    begin
      // Wysłanie bitu startu
      rx = 0;
      #(DVSR * 16 * 10); // czekanie na jeden pełny okres transmisji (bit startu)
      
      // Wysłanie bitów danych (LSB najpierw)
      for (i = 0; i < 8; i = i + 1) begin
        rx = byte[i];
        #(DVSR * 16 * 10); // czekanie na każdy bit
      end

      // Wysłanie bitu stopu
      rx = 1;
      #(DVSR * 16 * 10); // czekanie na jeden pełny okres transmisji (bit stopu)
    end
  endtask

  // Symulacja wysyłania danych przez UART
  task send_byte(input [7:0] byte);
    begin
      @(posedge clk); // czekanie na zbocze narastające zegara
      if (!tx_full) begin
        wr_uart = 1;
        w_data = byte;
        @(posedge clk);
        wr_uart = 0; // resetowanie sygnału zapisu po jednym takcie zegara
      end
    end
  endtask

endmodule
