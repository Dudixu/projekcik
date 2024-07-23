
module frame_letters (
    input  logic clk,
    input  logic rst,
    output logic [10:0] char_addr,
    vga_if.in vga_in,    // Wejście interfejsu vga_if
);
import vga_pkg::*;

logic [10:0] char_line_buf;
logic [10:0] char_code_buf;

always_comb begin
    char_line_buf = vga_in.vcount - 120;
    char_code_buf = "1" + (vga_in.hcount - 280)[10:6];   
end

always_ff @(posedge clk) begin
    if((vga_in.hcount >= 280) & (vga_in.vcount >= 104) & (vga_in.vcount <= 120)) begin
        char_addr <= {char_code_buf[6:0] , char_line_buf[3:0]};
    end
    else
        char_addr <= 0
    end
end

endmodule