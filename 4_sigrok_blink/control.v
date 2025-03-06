/*
 *
 *  Copyright(C) 2024 Kai Harris <matchahack@gmail.com>
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
    reg start = 0;
    reg sda_reg;
    wire clk_wire, sck_wire;
    assign sda = sda_reg;
    assign sck = sck_wire;

    initial begin
        start   <= 0;
        sda_reg <= 0;
    end

    always @(posedge sck) begin
        if (bbutton == 0) begin
            start <= 1;
        end

        if (start == 1) begin
            sda_reg <= 1;
        end
    end

    clk_div clk_div (
        .clk(clk),
        .sck(sck_wire)
    );

endmodule