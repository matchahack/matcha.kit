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

`ifndef i2c_M   // Check if i2c_M is not defined
`define i2c_M   // Define i2c_M

module i2c_module(
    input               i_clk,
    input   [7:0]       command,
    input               op_start,
    output              sck,
    output              sda,
    output              op_busy
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
    reg [5:0] wait_counter;

    // opcodes
    reg [7:0] E_ON      = 8'hA5;
    reg [7:0] INVERT    = 8'hA7;
    reg [7:0] D_ON      = 8'hAF;

    // signal
    reg op_busy_reg;
    assign op_busy = op_busy_reg;

    initial begin
        sck_reg         <= 0;
        sda_reg         <= 0;
        start           <= 0;
        STATE           <= IDLE;
        counter         <= 7;           // opcode length
        delay_counter   <= 1;
        wait_counter    <= 6'b100000;
        op_busy_reg     <= 1;
    end

    // data control
    always @ (negedge i_clk) begin
        if (op_start == 1 && op_busy_reg == 0) STATE <= INIT;
        case (STATE)
            IDLE:begin
                op_busy_reg <= 0;
            end
            INIT:begin
                op_busy_reg <= 1;
                if (delay_counter == 0) begin           // wait a cycle (>= 2.5 microseconds)
                    sda_reg         <= command[counter];
                    counter         <= counter - 1;
                    STATE           <= START;
                end else begin
                    sda_reg         <= 0;                   // sda to LOW
                    delay_counter   <= delay_counter - 1;
                end
            end
            START:begin
                if (counter == 0) begin
                    counter         <= 7;
                    sda_reg         <= command[counter];
                    STATE           <= DONE;
                end else begin
                    sda_reg         <= command[counter];         // pump out ON data during rising edge of SCK
                    counter         <= counter - 1;
                end
            end
            DONE:begin
                wait_counter <= wait_counter - 1;
                if (wait_counter == 0) begin
                    wait_counter    <= 6'b100000;
                    STATE           <= IDLE;
                end
            end
        endcase
    end

    // clock control
    always @ (posedge i_clk) begin
        if (STATE == INIT)  start <= 0;     // set start back to 0 one program has begun
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
                start   <= 0;
            end
        endcase
    end

endmodule

`endif
