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
    // FSM state
    reg start;
    reg [2:0] STATE;
    localparam IDLE     = 0;
    localparam INST_0   = 1;
    localparam INST_1   = 2;
    localparam INST_2   = 3;

    // FSM counters
    reg [3:0] counter;
    reg [1:0] delay_counter;
    reg [9:0] wait_counter;

    // opcodes
    reg [7:0] E_ON      = 8'hA5;
    reg [7:0] INVERT    = 8'hA7;
    reg [7:0] D_ON      = 8'hAF;

    // signals
    reg         op_start;
    wire         op_busy;
    reg [7:0]   instruction;

    initial begin
        counter     <= 4'd10;
        op_start    <= 0;
        instruction <= 0;        
        STATE       <= IDLE;
    end

    // instructions
    always @(posedge clk) begin
        case(STATE)
            IDLE:begin
                if (bbutton == 0)   STATE <= INST_0;     // begin program if button press
            end
            INST_0:begin
                instruction <= E_ON;
                counter     <= counter - 1;
                if (counter == 0) begin
                    counter     <= 4'd10;
                    op_start    <= 1;
                    if (op_busy == 0) begin
                        STATE   <= INST_1;
                    end
                end
            end
            INST_1:begin
                instruction <= INVERT;
                counter     <= counter - 1;
                op_start    <= 0;
                if (counter == 0) begin
                    counter     <= 4'd10;
                    op_start    <= 1;
                    if (op_busy == 0) begin
                        STATE   <= INST_2;
                    end
                end
            end
            INST_2:begin
                instruction <= D_ON;
                counter     <= counter - 1;
                op_start    <= 0;
                if (counter == 0) begin
                    counter     <= 4'd10;
                    op_start    <= 1;
                    if (op_busy == 0) begin
                        STATE   <= IDLE;
                    end                
                end
            end
        endcase
    end

    // ~2.5 microsecond clock
    clk_div clk_div (
        .clk(clk),
        .sck(sck_wire)
    );

    i2c_module i2c(
        .i_clk(clk),
        .command(instruction),
        .op_start(op_start),
        .sck(sck),
        .sda(sda),
        .op_busy(op_busy)
    );

endmodule