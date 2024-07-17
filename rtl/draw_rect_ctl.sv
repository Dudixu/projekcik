`timescale 1ns/1ps

module draw_rect_ctl
import vga_pkg::*; (
    input logic        clk,
    input logic        rst,
    vga_if.in vga_in,
    input logic        mouse_left,
    input logic [11:0] mouse_xpos,
    input logic [11:0] mouse_ypos,

    output logic [11:0] xpos,
    output logic [11:0] ypos
);

localparam acceleration = 2;
localparam bounce_rate = 3*acceleration;

logic [11:0]    xpos_nxt, ypos_nxt;
logic [8:0]     velocity, velocity_nxt;

typedef enum bit [2:0]{
    IDLE        = 3'b000,
    DOWN        = 3'b001,
    BOUNCE      = 3'b010,
    UP          = 3'b011,
    STOP        = 3'b100,
    RESET       = 3'b101
} STATE_T;

STATE_T state, state_nxt;


always_ff @(posedge clk) begin : xypos_blk
    if(vga_in.hcount == 0 & vga_in.vcount == 0) begin
        if(rst) begin
            state    <= IDLE;
            velocity <= '0;
            xpos     <= mouse_xpos;
            ypos     <= mouse_ypos;

        end else begin
            state    <= state_nxt;
            velocity <= velocity_nxt;
            xpos     <= xpos_nxt;
            ypos     <= ypos_nxt;

        end
    end else begin
    end
end


always_comb begin : state_nxt_blk
    case(state)
        IDLE:       state_nxt = mouse_left && mouse_ypos <= VER_PIXELS - RECT_HEIGHT ? DOWN : IDLE;
        DOWN:       state_nxt = ypos >= VER_PIXELS - RECT_HEIGHT - velocity - acceleration ? BOUNCE : DOWN;
        BOUNCE:     state_nxt = velocity <= bounce_rate ? STOP : UP;
        UP:         state_nxt = velocity <= acceleration ? DOWN : UP;
        STOP:       state_nxt = mouse_left ? RESET : STOP;
        RESET:      state_nxt = mouse_left == 0 ? IDLE : RESET; 
        default:    state_nxt = IDLE;
    endcase  
end


always_comb begin : output_blk
    case(state)
        IDLE: begin
            velocity_nxt = 0;
            xpos_nxt = mouse_xpos;
            ypos_nxt = mouse_ypos; 
        end

        DOWN: begin
            velocity_nxt = velocity + acceleration; 
            xpos_nxt = xpos;
            ypos_nxt = ypos + velocity; 
        end

        BOUNCE: begin
            velocity_nxt = velocity - bounce_rate;
            xpos_nxt = xpos;
            ypos_nxt = ypos;
        end

        UP: begin
            velocity_nxt = velocity - acceleration;
            xpos_nxt = xpos;
            ypos_nxt = ypos - velocity;
        end

        STOP, RESET: begin
            velocity_nxt = 0;
            xpos_nxt = xpos;
            ypos_nxt = VER_PIXELS - RECT_HEIGHT - 1; 
        end

        default: begin
            xpos_nxt = mouse_xpos;
            ypos_nxt = mouse_ypos;
            velocity_nxt = 0;
        end
    endcase
end

endmodule