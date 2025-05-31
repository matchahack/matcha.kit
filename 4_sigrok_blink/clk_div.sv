`ifndef clk_div_V   // Check if clk_div_V is not defined
`define clk_div_V   // Define clk_div_V

module clk_div(
    input  clk, // Input clock: 27 MHz
    output reg sck  // Output clock: 3 MHz
);

    // Counter to divide the clock
    reg [3:0] counter; // 4-bit counter (0 to 8 requires at least 4 bits)

    initial begin
        counter <= 0;
        sck <= 0;
    end

    always @(posedge clk) begin
        if (counter == 4'd8) begin
            counter <= 4'b0;        // Reset counter after 8
            sck <= ~sck;            // Toggle output clock
        end else begin
            counter <= counter + 1'b1; // Increment counter
        end
    end

endmodule

`endif