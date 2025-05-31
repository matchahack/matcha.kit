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

`ifndef i2c_M   // Prevent multiple definitions of the module
`define i2c_M   // Define the module identifier

module i2c_module(
    input               clk_scl,        // Serial clock input
    input               clk_scl_split,  // Split clock input for additional timing control
    input               clk_sda,        // Data clock input
    input   [7:0]       address,        // 8-bit I2C address
    input   [7:0]       control,        // 8-bit control signal
    input   [7:0]       data,           // 8-bit data to be sent
    input               op_start,       // Start operation signal
    output              op_done,        // Operation done flag
    inout               sck,            // Serial clock output
    inout               sda             // Serial data line
);
    // SDA line control: tristate logic for bidirectional communication
    reg sda_enable, sck_enable;
    assign sda = sda_enable ? 1'bz : 1'b0; // High impedance or driven low
    assign sck = sck_enable ? 1'bz : 1'b0; // High impedance or driven low

    // Operation done signal
    reg op_done_reg;
    assign op_done = op_done_reg;

    // Finite State Machine (FSM) states
    reg [3:0] STATE;
    localparam  START       = 0, // Initial state
                CLOCK_START = 1, // Start clock sequence
                ADDRESS_OUT = 2, // Transmit address
                CONTROL_OUT = 3, // Transmit control byte
                COMMAND_OUT = 4, // Transmit command or data
                CLOCK_END   = 5, // End clock sequence
                STOP        = 6; // Stop condition

    // Counter for tracking bits to send
    reg [3:0] op_counter;
    reg       delay; // Delay flag for timing adjustments

    // Initialization block
    initial begin
        sck_enable      <= 1;      // Set SCL high
        sda_enable      <= 1;      // Release SDA line
        op_done_reg     <= 0;      // Reset done flag
        op_counter      <= 4'd8;   // Initialize bit counter
        delay           <= 1;      // Initialize delay
        STATE           <= START;  // Set initial FSM state
    end

    // Data control logic triggered on SDA clock edge
    always @ (posedge clk_sda) begin
        if (op_done == 1) op_done_reg <= 0;                     // Reset operation done flag
        if (op_start == 1 && op_done_reg == 0) begin
            if (STATE == STOP) STATE <= START;                  // Restart FSM
            case (STATE)
                START: begin
                    STATE <= CLOCK_START;                       // Transition to clock start
                end
                CLOCK_START: begin
                    sda_enable <= 0;                            // Pull SDA low for start condition
                    STATE      <= ADDRESS_OUT;                  // Move to address transmission
                end
                ADDRESS_OUT: begin
                    if (op_counter >= 1) begin
                        sda_enable <= address[op_counter-1];    // Transmit address bits
                        op_counter <= op_counter - 1;
                    end else begin
                        sda_enable <= 1;                        // Acknowledge phase
                        op_counter <= 4'd8;                     // Reset bit counter
                        STATE      <= CONTROL_OUT;              // Move to control byte
                    end
                end
                CONTROL_OUT: begin
                    if (op_counter >= 1) begin
                        sda_enable <= control[op_counter-1];    // Transmit control bits
                        op_counter <= op_counter - 1;
                    end else begin
                        sda_enable <= 1;                        // Acknowledge phase
                        op_counter <= 4'd8;                     // Reset bit counter
                        STATE      <= COMMAND_OUT;              // Move to command/data
                    end
                end
                COMMAND_OUT: begin
                    if (op_counter >= 1) begin
                        sda_enable <= data[op_counter-1];       // Transmit data bits
                        op_counter <= op_counter - 1;
                    end else begin
                        sda_enable <= 1;                        // Acknowledge phase
                        op_counter <= 4'd8;                     // Reset bit counter
                        STATE      <= CLOCK_END;                // Move to clock end
                    end
                end
                CLOCK_END: begin
                    sda_enable <= 0;                            // Prepare for stop condition
                    STATE      <= STOP;
                end
                STOP: begin
                    sda_enable <= 1;                            // Release SDA for stop condition
                    op_counter <= 4'd8;                         // Reset counter
                    op_done_reg <= 1;                           // Signal operation complete
                    STATE <= START;                             // Return to start
                end
            endcase
        end
    end

    // Delay control triggered on SCL clock edge
    always @ (posedge clk_scl) begin
        case (STATE)
            ADDRESS_OUT:    if (delay == 1) delay <= delay - 1;
            CLOCK_END:                      delay <= 1;
        endcase
    end

    // SCL clock control
    always @ (posedge clk_scl_split) begin
        case (STATE)
            ADDRESS_OUT:    if (delay == 0)         sck_enable <= ~sck_enable;    // Toggle SCL
            CONTROL_OUT, COMMAND_OUT, CLOCK_END:    sck_enable <= ~sck_enable;    // Toggle SCL
            STOP:                                   sck_enable <= 1;              // Ensure SCL high during stop
        endcase
    end

endmodule

`endif
