module control
(
    input           clk,
    input           bbutton,
    output  [2:0]   led
);

    localparam WAIT_TIME = 13500000;

    reg [2:0]   ledCounter      = 0;
    reg [23:0]  clockCounter    = 0;
    reg         start           = 0;
    reg         bbutton_prev    = 1;
    reg         initialized     = 0;

    assign led = ~ledCounter;

    always @(posedge clk) begin
        if (!initialized) begin
            bbutton_prev <= bbutton;
            if (bbutton == 1) begin
                initialized <= 1;
            end
        end else begin
            if (bbutton_prev && !bbutton) begin
                start <= 1;
            end
            bbutton_prev <= bbutton;
        end

        if (start) begin
            if (clockCounter < WAIT_TIME) begin
                clockCounter <= clockCounter + 1;
            end else begin
                clockCounter <= 0;
                ledCounter <= ledCounter + 1;
            end
        end
    end

endmodule
