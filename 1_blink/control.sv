module control
(
    input           clk,                    // Clock input signal
    output  [2:0]   led                     // 3-bit LED output
);

    reg [31:0] counter;                     // 32-bit counter register

    initial begin
        counter <= 31'd0;                   // Initialize counter to 0
        led <= 3'b110;                      // Initialize LED pattern
    end

    always @(posedge clk) begin
        if (counter < 31'd1350_0000)        // Check if counter is less than 135 million (for 0.5s delay)
            counter <= counter + 1;         // Increment counter
        else begin
            counter <= 31'd0;               // Reset counter
            led[2:0] <= {led[1:0],led[2]};  // Rotate LED pattern left
        end
    end

endmodule
