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
 * Top level synthesizable module including the project top and all the FPGA-referred modules.
 */

`timescale 1 ns / 1 ps

module top_vga_basys3 (
    input  wire clk,
    input  wire btnC,
    input  wire btnU,
    inout  wire PS2Clk,
    inout  wire PS2Data,
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    input  wire JB1, JB2, JB3, JB4, JB5, JB6, JB7, JB8,
    output wire JC1, JC2, JC3, JC4, JC5, JC6, JC7, JC8,
    output wire led0, led1, led2, led3
);


/**
 * Local variables and signals
 */
wire locked;
wire [7:0] data_in;
wire [7:0] data_out;
wire clk_100;
wire clk_75;

/**
 * Signals assignments
 */
assign data_in = {JB1, JB2, JB3, JB4, JB5, JB6, JB7, JB8};
assign {JC4, JC3, JC2, JC1, JC8, JC7, JC6, JC5} = data_out;

// Mirror pclk on a pin for use by the testbench;
// not functionally required for this design to work.

ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(clk_75),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
);

clk_wiz_0 u_clk_wiz_0 (
    .clk(clk),
    .locked(locked),
    .clk100MHz(clk_100),
    .clk75MHz(clk_75)
);

/**
 *  Project functional top module
 */

top_vga u_top_vga (
    .clk_75,
    .clk_100,
    .ps2_data(PS2Data),
    .ps2_clk(PS2Clk),
    .rst(btnC),
    .r(vgaRed),
    .g(vgaGreen),
    .b(vgaBlue),
    .hs(Hsync),
    .vs(Vsync),
    .set_player(btnU),
    .data_in(data_in),
    .data_out(data_out),
    .led({led0, led1, led2, led3})
);

endmodule
