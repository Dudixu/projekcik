/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * Testbench for top_vga.
 * Thanks to the tiff_writer module, an expected image
 * produced by the project is exported to a tif file.
 * Since the vs signal is connected to the go input of
 * the tiff_writer, the first (top-left) pixel of the tif
 * will not correspond to the vga project (0,0) pixel.
 * The active image (not blanked space) in the tif file
 * will be shifted down by the number of lines equal to
 * the difference between VER_SYNC_START and VER_TOTAL_TIME.
 */

`timescale 1 ns / 1 ps

module top_vga_tb;


/**
 *  Local parameters
 */

localparam CLK_PERIOD_40 = 25;
localparam CLK_PERIOD_100 = 10;     // 40 MHz

/**
 * Local variables and signals
 */

logic clk_40, clk_100, rst;
wire vs, hs;
wire [3:0] r, g, b;


/**
 * Clock generation
 */

initial begin
    clk_40 = 1'b0;
    forever #(CLK_PERIOD_40/2) clk_40 = ~clk_40;
end

initial begin
    clk_100 = 1'b0;
    forever #(CLK_PERIOD_100/2) clk_100 = ~clk_100;
end


/**
 * Submodules instances
 */

top_vga dut (
    .clk_40,
    .clk_100,
    .ps2_clk(),
    .ps2_data(),
    .rst(rst),
    .vs(vs),
    .hs(hs),
    .r(r),
    .g(g),
    .b(b)
);

initial begin
force dut.xpos = 100;
force dut.ypos = 100;
end


tiff_writer #(
    .XDIM(16'd1056),
    .YDIM(16'd628),
    .FILE_DIR("../../results")
) u_tiff_writer (
    .clk(clk_40),
    .r({r,r}), // fabricate an 8-bit value
    .g({g,g}), // fabricate an 8-bit value
    .b({b,b}), // fabricate an 8-bit value
    .go(vs)
);


/**
 * Main test
 */

initial begin
    rst = 1'b0;
    # 30 rst = 1'b1;
    # 30 rst = 1'b0;

    $display("If simulation ends before the testbench");
    $display("completes, use the menu option to run all.");
    $display("Prepare to wait a long time...");

    wait (vs == 1'b0);
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    @(negedge vs) $display("Info: negedge VS at %t",$time);

    // End the simulation.
    $display("Simulation is over, check the waveforms.");
    $finish;
end

endmodule
