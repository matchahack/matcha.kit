`ifndef clk_div_M   // Check if clk_div_M is not defined
`define clk_div_M   // Define clk_div_M

module clk_div(
    input       clk,
    output reg  sck_scl,
    output reg  sck_scl_split,
    output reg  sck_sda
);

    // Counter to divide the clock
    reg [19:0]  counter;
    reg [19:0]  CYCLE_LEN;
    reg [19:0]  HALF_CYLE_LEN;

    reg [19:0]  scl_split_offset;

    initial begin
        counter             = 0;
        HALF_CYLE_LEN       = 20'd350;
        scl_split_offset    = 20'd174;
        CYCLE_LEN           = 20'd700;
        sck_scl             = 1;
        sck_scl_split       = 1;
        sck_sda             = 0;
    end

    always @(posedge clk) begin
        if (counter != CYCLE_LEN)       counter <= counter + 20'b1;
        if (counter == CYCLE_LEN)       counter <= 0;
        if (counter == HALF_CYLE_LEN)   begin
            sck_scl         <= ~sck_scl;
            sck_scl_split   <= ~sck_scl_split;
        end
        if (counter == HALF_CYLE_LEN - scl_split_offset) sck_scl_split <= ~sck_scl_split;
        if (sck_scl == 0) begin
            if (counter == CYCLE_LEN - 20'd1)   sck_sda <= ~sck_sda;
            if (counter == CYCLE_LEN)           sck_sda <= ~sck_sda;
        end
    end

endmodule

`endif