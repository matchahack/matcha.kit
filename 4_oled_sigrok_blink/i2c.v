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
    input               clk_scl,
    input               clk_scl_split,
    input               clk_sda,
    input   [63:0]      command,
    input               op_start,
    output              op_done,
    output              sck,
    output              sda
);

    // wiring
    reg sda_reg, scl_reg;
    assign sda = sda_reg;
    assign sck = scl_reg;

    // signal
    reg op_done_reg;
    assign op_done = op_done_reg;

    // FSM state
    reg [3:0] STATE;
    localparam  START       = 0;
    localparam  CLOCK_START = 1;
    localparam  DATA_OUT    = 2;
    localparam  CLOCK_END   = 3;
    localparam  DATA_FINISH = 4;
    localparam  STOP        = 5;

    // op_counter
    reg [6:0] op_counter;
    reg       delay;

    initial begin
        scl_reg         <= 1;
        sda_reg         <= 1;
        op_done_reg     <= 0;
        op_counter      <= 6'd63;
        delay           <= 1;
        STATE           <= START;
    end

    // data control
    always @ (posedge clk_sda) begin
        if (op_done == 1) op_done_reg <= 0;
        if (op_start == 1 && op_done_reg == 0) begin
            if (STATE == STOP) STATE <= START;
            case (STATE)
                START:begin
                    STATE   <= CLOCK_START;
                end
                CLOCK_START: begin
                    sda_reg <= 0;
                    STATE   <= DATA_OUT;
                end
                DATA_OUT:begin
                    if (op_counter == 0) begin
                        STATE       <= CLOCK_END;
                    end
                    else begin
                        if (op_counter % 9 == 0) op_counter  <= op_counter - 1;
                        sda_reg     <= command[op_counter-1];
                        op_counter  <= op_counter - 1;
                    end
                end
                CLOCK_END:begin
                    sda_reg     <= 1;
                    STATE       <= DATA_FINISH;
                end
                DATA_FINISH:begin
                    sda_reg <= 0;
                    STATE   <= STOP;
                end
                STOP:begin
                    sda_reg     <= 1;
                    op_done_reg <= 1;
                    op_counter  <= 6'd63;
                    STATE       <= START;
                end
            endcase
        end
    end

    always @ (posedge clk_scl) begin
        case (STATE)
            DATA_OUT:   if (delay == 1) delay <= delay - 1;
            CLOCK_END:  delay   <= 1;
        endcase
    end

    // clock control
    always @ (posedge clk_scl_split) begin
        case (STATE)
            DATA_OUT:   if (delay == 0) scl_reg <= ~scl_reg;
            DATA_OUT, CLOCK_END, DATA_FINISH:    scl_reg <= ~scl_reg;
            STOP:                                scl_reg <= 1;
        endcase
    end

endmodule

`endif
