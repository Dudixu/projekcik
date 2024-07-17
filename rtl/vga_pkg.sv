/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Package with vga related constants.
 */

package vga_pkg;

// Parameters for VGA Display 1024 x 768 @ 60fps using a 65 MHz clock;
localparam HOR_PIXELS = 1024;
localparam VER_PIXELS = 768;
localparam HOR_TOTAL_TIME = 1344;
localparam HOR_BLANK_START = 1024;
localparam HOR_SYNC_START = 1048;
localparam VER_TOTAL_TIME = 806;
localparam VER_BLANK_START = 768;
localparam VER_SYNC_START = 771;

// Add VGA timing parameters here and refer to them in other modules.
localparam HOR_SYNC_END = 1184;
localparam HOR_BLANK_END = 1344;
localparam VER_SYNC_END = 777;
localparam VER_BLANK_END = 806;

localparam RECT_LENGTH = 48;
localparam RECT_HEIGHT = 64;

localparam CHAR_HEIGHT = 256;
localparam CHAR_LENGTH = 128;
localparam CHAR_X = 0;
localparam CHAR_Y = 0;
endpackage
