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
    input               clk_sda,
    input   [7:0]       address,
    input   [7:0]       control,
    input   [7:0]       data,
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
    localparam  ADDRESS_OUT = 2;
    localparam  CONTROL_OUT = 3;
    localparam  DATA_OUT    = 4;
    localparam  CLOCK_END   = 5;
    localparam  ACK         = 6;
    localparam  STOP        = 7;

    // op_counter
    reg [3:0] op_counter;
    reg       delay;

    initial begin
        scl_reg         <= 1;
        sda_reg         <= 1;
        op_done_reg     <= 0;
        op_counter      <= 4'd8;
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
                    STATE   <= ADDRESS_OUT;
                end
                ADDRESS_OUT:begin
                    if (op_counter > 1) begin
                        sda_reg     <= address[op_counter-1];
                        op_counter  <= op_counter - 1;
                    end
                    if (op_counter == 1) begin
                        op_counter <= op_counter - 1;
                    end
                    if (op_counter == 0) begin
                        op_counter  <= 8;
                        STATE       <= CONTROL_OUT;
                    end
                end
                CONTROL_OUT:begin
                    if (op_counter > 1) begin
                        sda_reg     <= control[op_counter-1];
                        op_counter  <= op_counter - 1;
                    end
                    if (op_counter == 1) begin
                        op_counter <= op_counter - 1;
                    end
                    if (op_counter == 0) begin
                        op_counter  <= 8;
                        STATE       <= DATA_OUT;
                    end
                end
                DATA_OUT:begin
                    if (op_counter > 1) begin
                        sda_reg     <= data[op_counter-1];
                        op_counter  <= op_counter - 1;
                    end
                    if (op_counter == 1) begin
                        op_counter <= op_counter - 1;
                    end
                    if (op_counter == 0) begin
                        op_counter  <= 8;
                        STATE       <= CLOCK_END;
                    end
                end
                CLOCK_END:begin
                    sda_reg     <= 1;
                    STATE       <= ACK;
                end
                ACK:begin
                    sda_reg     <= 0;
                    STATE       <= STOP;
                end
                STOP:begin
                    sda_reg     <= 1;
                    op_counter  <= 8;
                    op_done_reg <= 1;
                    STATE       <= START;
                end
            endcase
        end
    end

    always @ (posedge clk_scl) begin
        case (STATE)
            ADDRESS_OUT:    if (delay == 1) delay <= delay - 1;
            CLOCK_END:      delay   <= 1;
        endcase
    end

    // clock control
    always @ (posedge clk_scl or negedge clk_scl) begin
        case (STATE)
            ADDRESS_OUT:    if (delay == 0) scl_reg <= ~scl_reg;
            CONTROL_OUT:    scl_reg <= ~scl_reg;
            DATA_OUT:       scl_reg <= ~scl_reg;
            CLOCK_END:      scl_reg <= ~scl_reg;
            ACK:            scl_reg <= ~scl_reg;
            STOP:           scl_reg <= 1;
        endcase
    end

endmodule

`endif
