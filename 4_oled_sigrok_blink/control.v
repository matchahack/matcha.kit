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

module control
(
    input   clk,        // system clock
    input   bbutton,    // bread-board button
    output  sda,        // serial data
    output  sck         // serial clock
);

    // wiring
    reg sda_reg, sck_reg;
    wire sck_wire;
    assign sda = sda_reg;
    assign sck = sck_reg;

    // FSM state
    reg start;
    reg [2:0] STATE;
    localparam IDLE     = 0;
    localparam INIT     = 1;
    localparam START    = 2;
    localparam DONE     = 3;

    // FSM counters
    reg [3:0] counter;
    reg [1:0] delay_counter;

    // SSD1306 opcodes
    reg [7:0] ON        = 8'hA5; //A5:10100101, A4
    reg [7:0] INVERT    = 8'hA7; //A6

    initial begin
        sda_reg         <= 1;
        sck_reg         <= 1;
        start           <= 0;
        STATE           <= IDLE;
        counter         <= 7;           // opcode length
        delay_counter   <= 1;
    end

    // data control
    always @ (negedge sck_wire) begin
        if (start == 1) STATE <= INIT;
        case (STATE)
            IDLE:begin
            end
            INIT:begin
                if (delay_counter == 0) begin           // wait a cycle (>= 2.5 microseconds)
                    sda_reg         <= ON[counter];
                    counter         <= counter - 1;
                    STATE           <= START;
                end else begin
                    sda_reg         <= 0;                   // sda to LOW
                    delay_counter   <= delay_counter - 1;
                end
            end
            START:begin
                if (counter == 0) begin
                    sda_reg         <= ON[counter];
                    STATE           <= DONE;
                end else begin
                    sda_reg         <= ON[counter];         // pump out ON data during rising edge of SCK
                    counter         <= counter - 1;
                end
            end
            DONE:begin
                STATE   <= IDLE;
            end
        endcase
    end

    // clock control
    always @ (posedge sck_wire) begin
        case (STATE)
            INIT:begin
                if(delay_counter==0)begin
                    sck_reg <= 0;
                end
            end
            START:begin  
                sck_reg <= ~sck_reg;
            end
            DONE:begin   
                sck_reg <= 1;
            end
        endcase
    end

    // UX control
    always @(posedge clk) begin
        if (bbutton == 0)   start <= 1;     // begin program if button press
        if (STATE == INIT)  start <= 0;     // set start back to 0 one program has begun
    end

    // ~2.5 microsecond clock
    clk_div clk_div (
        .clk(clk),
        .sck(sck_wire)
    );

endmodule