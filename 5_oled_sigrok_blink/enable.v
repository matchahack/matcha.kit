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

`ifndef enable_M   // Check if enable_M is not defined
`define enable_M   // Define enable_M

module enable (
    input       clk,
    output reg  sck_scl,
    output reg  sck_scl_split,
    output reg  sck_sda
);

    // Counter to divide the clock
    reg [9:0]  counter;
    reg [9:0]  CYCLE_LEN;
    reg [9:0]  HALF_CYLE_LEN;

    reg [9:0]  scl_split_offset;

    initial begin
        counter             <= 0;
        HALF_CYLE_LEN       <= 10'd350;
        scl_split_offset    <= 10'd174;
        CYCLE_LEN           <= 10'd700;
        sck_scl             <= 1;
        sck_scl_split       <= 1;
        sck_sda             <= 0;
    end

    always @(posedge clk) begin
        if (counter != CYCLE_LEN)       counter <= counter + 10'b1;
        if (counter == CYCLE_LEN)       counter <= 0;
        if (counter == HALF_CYLE_LEN)   begin
            sck_scl         <= ~1;
            sck_scl_split   <= ~1;
        end
        if (counter == CYCLE_LEN) begin
            counter         <= 0;
            sck_scl         <= ~0;
            sck_scl_split   <= ~0;
        end
        if (counter == HALF_CYLE_LEN - scl_split_offset) sck_scl_split <= 1;
        if (counter == HALF_CYLE_LEN + scl_split_offset) sck_scl_split <= 0;
        if (sck_scl == 0) begin
            if (counter == CYCLE_LEN - 10'd1)   sck_sda <= 1;
            if (counter == CYCLE_LEN)           sck_sda <= 0;
        end
    end

endmodule

`endif