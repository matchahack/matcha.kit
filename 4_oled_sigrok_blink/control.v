/*
 *
 *  Copyright(C) 2025 Kai Harris <matchahack@gmail.com>
 * 
 *  Permission to use, copy, modify, and/or distribute this software for any purpose with or
 *  without fee is hereby granted, provided that the above copyright notice and 
 *  this permission notice appear in all copies.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO
 *  THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. 
 *  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL 
 *  DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
 *  AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN 
 *  CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 * 
 */

`include "clk_div.v"
`include "i2c.v"

module control
(
    input   clk,        // system clock
    input   bbutton,    // bread-board button
    output  sda,        // serial data
    output  sck         // serial clock
);

    // wiring
    wire sck_scl_wire, sck_sda_wire;

    // FSM state
    reg start;
    reg [2:0] NEXT_STATE;
    reg [2:0] STATE;
    localparam IDLE     = 3'd0;
    localparam WAIT     = 3'd1;
    localparam INST_0   = 3'd2;
    localparam INST_1   = 3'd3;
    localparam INST_2   = 3'd4;

    // opcodes
    reg [7:0] ADDRESS;
    reg [7:0] CONTROL;
    reg [7:0] DATA;
    reg [7:0] CHARGE_PUMP      = 8'h8D; // 1000 1101
    reg [7:0] DISPLAY_ON       = 8'hAF; // 1010 1111

    // signals
    reg     op_start;
    wire    op_done;

    // delay counter
    reg [15:0] wait_counter;

    initial begin
        op_start        <= 0;
        ADDRESS         <= 0;
        CONTROL         <= 0;
        DATA            <= 0;
        STATE           <= IDLE;
        NEXT_STATE      <= IDLE;
        wait_counter    <= 16'h1000;
    end

    // instructions
    always @(posedge clk) begin
        case(STATE)
            IDLE:begin
                if (bbutton == 0)   begin           // begin program if button press
                    ADDRESS     <= 8'h3C;           // WRITE MODE: 0011 1100
                    CONTROL     <= 8'h00;           // DATA ONLY:  0000 0000
                    DATA        <= CHARGE_PUMP;
                    NEXT_STATE  <= INST_0;
                    STATE       <= WAIT;
                end
            end
            WAIT:begin
                wait_counter <= wait_counter - 1;
                if (wait_counter == 0) begin
                    wait_counter    <= 16'h1000;
                    STATE           <= NEXT_STATE;
                end
            end
            INST_0:begin
                if (op_done == 0) op_start <= 1;
                if (op_done == 1 && op_start == 1) begin
                    op_start    <= 0;
                    DATA        <= DISPLAY_ON;
                    NEXT_STATE  <= INST_1;
                    STATE       <= WAIT;
                end
            end
            INST_1:begin
                if (op_done == 0) op_start <= 1;
                if (op_done == 1 && op_start == 1) begin
                    op_start    <= 0;
                    ADDRESS     <= 0;
                    CONTROL     <= 0;
                    DATA        <= 0;
                    NEXT_STATE  <= IDLE;
                    STATE       <= IDLE;
                end
            end
        endcase
    end

    // ~2.5 microsecond clock
    clk_div clk_div (
        .clk(clk),
        .sck_scl(sck_scl_wire),
        .sck_sda(sck_sda_wire)
    );

    // IIC control module
    i2c_module i2c(
        .clk_scl(sck_scl_wire),
        .clk_sda(sck_sda_wire),
        .address(ADDRESS),
        .control(CONTROL),
        .data(DATA),
        .op_start(op_start),
        .op_done(op_done),
        .sck(sck),
        .sda(sda)
    );

endmodule