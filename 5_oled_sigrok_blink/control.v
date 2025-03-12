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

`include "enable.v" // Include the clock divider module
`include "i2c.v"     // Include the I2C module

// Top-level control module for I2C communication
module control
(
    input   clk,        // System clock input
    input   bbutton,    // Button input for triggering operations
    inout   sck,        // Serial clock output for I2C
    inout   sda         // Serial data line for I2C (bi-directional)
);

    // Internal wiring between modules
    wire sck_scl_wire, sck_scl_split_wire, sck_sda_wire;

    // Finite State Machine (FSM) states and control signals
    reg start;              // Start signal for FSM
    reg [4:0] NEXT_STATE;   // Next state register for FSM
    reg [4:0] STATE;        // Current state register for FSM
    
    // FSM state definitions
    localparam IDLE     = 5'd0, // Idle state
               WAIT     = 5'd1, // Wait state for delays
               STOP     = 5'd2, // Stop state (currently unused)
               INST_0   = 5'd4, // State for executing instruction 0
               INST_1   = 5'd5, // State for executing instruction 0
               INST_2   = 5'd6; // State for executing instruction 0

    // I2C control registers
    reg [7:0] ADDRESS;  // I2C device address
    reg [7:0] CONTROL;  // Control register for I2C operations
    reg [7:0] COMMAND;  // Command data to send over I2C

    // Operation control signals
    reg     op_start, one_punch;    // Signal to start I2C operation
    wire    op_done;                // Signal indicating operation completion

    // Delay counter for timing control
    reg [15:0] wait_counter;

    // Initialization of registers
    initial begin
        op_start            <= 0;        // Initialize operation start signal
        one_punch           <= 0;
        ADDRESS             <= 8'h78;    // Set default I2C device address (example)
        CONTROL             <= 8'h00;    // Set default control register value
        COMMAND             <= 8'h00;    // Set default command value
        STATE               <= IDLE;     // Set initial FSM state
        NEXT_STATE          <= IDLE;     // Set next state to idle initially
        wait_counter        <= 16'hFFFF; // Set default delay counter value
    end

    // FSM to control I2C operations
    always @(posedge clk) begin
        case (STATE)

            WAIT: begin
                // Delay mechanism using wait counter
                wait_counter <= wait_counter - 1;
                if (wait_counter == 0) begin
                    wait_counter    <= 16'hFFFF;            // Reset wait counter
                    STATE           <= NEXT_STATE;          // Transition to next state
                end
            end

            IDLE: begin
                // If button is pressed, start the program
                if (bbutton == 0 && one_punch == 0) begin
                    COMMAND     <= 8'h8D;                   // Load the command to send (CHARGE PUMP SETTING)
                    NEXT_STATE  <= INST_0;                  // Set next state to instruction execution
                    STATE       <= WAIT;                    // Transition to wait state
                    one_punch   <= 1;
                end
            end

            INST_0: begin
                // Execute I2C operation if not already done
                if (op_done == 0) op_start <= 1;            // Start operation
                if (op_done == 1 && op_start == 1) begin
                    op_start    <= 0;                       // Reset operation start signal
                    COMMAND     <= 8'h14;                   // Load the command to send (ENABLE CHARGE PUMP)
                    NEXT_STATE  <= INST_1;                  // Transition to idle after completion
                    STATE       <= WAIT;
                end
            end

            INST_1: begin
                // Execute I2C operation if not already done
                if (op_done == 0) op_start <= 1;            // Start operation
                if (op_done == 1 && op_start == 1) begin
                    op_start    <= 0;                       // Reset operation start signal
                    COMMAND     <= 8'hAF;                   // Load the command to send (DISPLAY ON)
                    NEXT_STATE  <= INST_2;                  // Transition to idle after completion
                    STATE       <= WAIT;
                end
            end

            INST_2: begin
                // Execute I2C operation if not already done
                if (op_done == 0) op_start <= 1;            // Start operation
                if (op_done == 1 && op_start == 1) begin
                    op_start    <= 0;                       // Reset operation start signal
                    COMMAND     <= 0;                       // Load the command to send (DISPLAY ON)
                    NEXT_STATE  <= IDLE;                    // Transition to idle after completion
                    STATE       <= IDLE;
                end
            end

            STOP: begin
                // Stop state placeholder (currently unused)
            end
        endcase
    end

    // Instantiate the clock divider module
    enable enable (
        .clk(clk),                                          // System clock input
        .sck_scl(sck_scl_wire),                             // Output clock for I2C SCL
        .sck_scl_split(sck_scl_split_wire),                 // Split clock signal
        .sck_sda(sck_sda_wire)                              // Clock signal for SDA timing
    );

    // Instantiate the I2C module
    i2c_module i2c (
        .clk_scl(sck_scl_wire),                             // Clock signal for SCL
        .clk_scl_split(sck_scl_split_wire),                 // Split clock signal
        .clk_sda(sck_sda_wire),                             // Clock signal for SDA
        .address(ADDRESS),                                  // Device address for I2C
        .control(CONTROL),                                  // Control register value
        .data(COMMAND),                                     // Command data to send
        .op_start(op_start),                                // Start signal for I2C operation
        .op_done(op_done),                                  // Operation done signal
        .sck(sck),                                          // Output serial clock
        .sda(sda)                                           // Inout serial data line
    );

endmodule
