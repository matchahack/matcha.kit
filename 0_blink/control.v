module control
(
    input           clk,
    output  [2:0]   led
);

    reg [31:0] counter;

    initial begin
        counter <= 31'd0;
        led <= 3'b110;
    end

    always @(posedge clk) begin
        if (counter < 31'd1350_0000)       // 0.5s delay
            counter <= counter + 1;
        else begin
            counter <= 31'd0;
            led[2:0] <= {led[1:0],led[2]};
        end
    end

endmodule