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
    reg sda_reg, scl_reg;
    wire sck_wire, phase_shift_sck_wire;
    assign sda = sda_reg;
    assign sck = scl_reg;

    // FSM state
    reg start;
    reg [2:0] STATE;
    localparam IDLE     = 0;
    localparam INIT     = 1;
    localparam TURN_ON  = 2;
    localparam DONE     = 3;

    // FSM counters
    reg [3:0] counter;
    reg [10:0] one_microsec;
    localparam micro_sec = 1; // dummy

    // SSD1306 opcodes
    reg [7:0] ON        = 8'hA5; //A4
    reg [7:0] INVERT    = 8'hA7; //A6

    initial begin
        sda_reg         <= 1;
        scl_reg         <= 1;
        start           <= 0;
        STATE           <= IDLE;
        counter         <= 7;           // opcode length
        one_microsec    <= micro_sec;
    end

    // operation control
    always @ (negedge sck_wire) begin
        if (start == 1) STATE <= INIT;
        case (STATE)
            IDLE:begin
            end
            INIT:begin
                sda_reg <= 0;
                one_microsec <= one_microsec - 1;
                if (one_microsec == 0) begin        // wait 1 micro_seconds
                    scl_reg         <= ~scl_reg;
                    one_microsec    <= micro_sec;
                    STATE           <= TURN_ON;
                end
            end
            TURN_ON:begin
                scl_reg <= ~scl_reg;
                sda_reg <= ON[counter];
                counter <= counter - 1;
                if (counter == 0) STATE <= DONE;
            end
            DONE:begin
                scl_reg         <= 1;
                one_microsec <= one_microsec - 1;
                if (one_microsec == 0) begin
                    sda_reg         <= 1;
                    one_microsec    <= micro_sec;
                    STATE           <= IDLE;
                end
            end
        endcase
    end

    // UX control
    always @(posedge sck_wire) begin
        if (bbutton == 0) start <= 1;  // begin program if button press
        if (STATE == INIT) start <= 0; // set start back to 0 one program has begun
    end

    // ~2.5 microsecond clock
    clk_div clk_div (
        .clk(clk),
        .sck(sck_wire),
        .phase_shift_sck(phase_shift_sck_wire)
    );

endmodule