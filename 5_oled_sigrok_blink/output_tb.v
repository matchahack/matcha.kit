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
 
`timescale 1 ns / 1 ps  // Time scale directive, 1 ns time unit, 1 ps time precision

module output_tb();
    reg clk = 0;
    reg bbutton = 1;
    wire sda, sck;

    localparam CLK_PERIOD       = 3.704;    // 27 MHz clock -> 1/27_000_000 second period -> 3.704 nanoseconds
    localparam HALF_CLK_PERIOD  = 1.852;
    localparam DURATION         = 2000000;

    integer clk_counter = 0;             // Counter to manage signal toggling

    // Initial block to setup waveform dumping
    initial begin
        $dumpfile("output_tb.vcd");    
        $dumpvars(0, output_tb);       
        #(DURATION);                  
        $finish;                       
    end

    // Clock generation block
    always begin
        #(HALF_CLK_PERIOD);            // Half-period delay
        clk = ~clk;                    // Toggle clock signal every half period
        clk_counter = clk_counter + 1;

        if (clk_counter == 2000) begin
            bbutton = 0;
        end
        
        if (clk_counter == 2500) begin
            bbutton = 1;
        end
    end

    control main_tb (
        .clk(clk),
        .bbutton(bbutton),
        .sck(sck),
        .sda(sda)
    );
endmodule

