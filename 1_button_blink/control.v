module control
(
    input           clk,
    input   [1:0]   button,
    output  [5:0]   led
);

    localparam WAIT_TIME = 13500000;

    reg [5:0]   ledCounter      = 0;
    reg [23:0]  clockCounter    = 0;
    reg         start           = 0;

    always @(posedge clk) begin
        if (button[0] == 0) start <= 1;
        if (button[1] == 0) start <= 0;
        if (start == 1) begin
            clockCounter <= clockCounter + 1;
            if (clockCounter == WAIT_TIME) begin
                clockCounter <= 0;
                ledCounter <= ledCounter + 1;
            end
        end
    end

    assign led = ~ledCounter;
endmodule