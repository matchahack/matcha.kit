`ifndef clk_div_M   // Check if clk_div_M is not defined
`define clk_div_M   // Define clk_div_M

module clk_div(
    input       clk,
    output reg  sck_scl,
    output reg  sck_sda
);

    // Counter to divide the clock
    reg [19:0]  counter;
    reg [19:0]  CYCLE_LEN;
    reg [19:0]  HALF_CYLE_LEN;

    initial begin
        counter             <= 0;
        HALF_CYLE_LEN       <= 20'd175;
        CYCLE_LEN           <= 20'd350;
        sck_scl             <= 1;
        sck_sda             <= 1;
    end

    always @(posedge clk) begin
        if (counter != CYCLE_LEN)       counter <= counter + 20'b1;
        if (counter == CYCLE_LEN)       counter <= 0;
        if (counter == HALF_CYLE_LEN)   sck_scl <= ~sck_scl;
        if (sck_scl == 0) begin
            if (counter == CYCLE_LEN - 20'b1)   sck_sda     <= ~sck_sda;
            if (counter == CYCLE_LEN)           sck_sda     <= ~sck_sda;
        end
    end

endmodule

`endif
