`ifndef clk_div_V   // Check if clk_div_V is not defined
`define clk_div_V   // Define clk_div_V

module clk_div(
    input       clk,        // Input clock: 27 MHz
    output reg  sck,
    output reg  phase_shift_sck
);

    // Counter to divide the clock
    reg [20:0]  double_counter;
    reg         double_reg;

    initial begin
        double_counter      <= 0;
        double_reg          <= 0;
        sck                 <= 0;
        phase_shift_sck     <= 0;
    end

    always @(posedge clk) begin
        if (double_counter == 20'd350) begin
            double_counter  <= 20'b0;
            double_reg      <= ~double_reg;
        end else begin
            double_counter <= double_counter + 1'b1;
        end
    end

    always @(negedge double_reg) begin
        sck <= ~sck;
    end

    always @(posedge double_reg) begin
        phase_shift_sck <= ~phase_shift_sck;
    end

endmodule

`endif
