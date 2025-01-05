`ifndef clk_div_V   // Check if clk_div_V is not defined
`define clk_div_V   // Define clk_div_V

module clk_div(
    input       clk,        // Input clock: 27 MHz
    output reg  sck
);

    // Counter to divide the clock
    reg [20:0]  counter;
    reg         counter_reg;

    initial begin
        counter             <= 0;
        counter_reg         <= 0;
        sck                 <= 0;
    end

    always @(posedge clk) begin
        if (counter == 20'd175) begin
            counter         <= 20'b0;
            counter_reg     <= ~counter_reg;
        end else begin
            counter <= counter + 1'b1;
        end
    end

    always @(negedge counter_reg) begin
        sck <= ~sck;
    end

endmodule

`endif
