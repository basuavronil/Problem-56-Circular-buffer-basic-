`timescale 1ns / 1ps

module circular_buffer (
    input  wire       clk,
    input  wire       rst,
    
    // Control Signals
    input  wire       wr,
    input  wire       rd,
    
    // Data Interfaces (Fixed 8-bit width)
    input  wire [7:0] w_data,
    output reg  [7:0] r_data,
    
    // Status Flags
    output wire       full,
    output wire       empty
);

    // Fixed 8-entry x 8-bit RAM array
    reg [7:0] mem [0:7];
    
    // 4-bit Pointers (Bits [2:0] = address, Bit [3] = MSB wrap bit)
    reg [3:0] wr_ptr;
    reg [3:0] rd_ptr;

    // 1. Status Flags
    assign empty = (rd_ptr == wr_ptr);
    assign full  = (rd_ptr[3] != wr_ptr[3]) && (rd_ptr[2:0] == wr_ptr[2:0]);

    // 2. Synchronous Write and Read Operations
    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 4'd0;
            rd_ptr <= 4'd0;
            r_data <= 8'd0;
        end else begin
            // Synchronous Write Logic
            if (wr && !full) begin
                mem[wr_ptr[2:0]] <= w_data;
                wr_ptr           <= wr_ptr + 1'b1;
            end

            // Synchronous Read Logic
            if (rd && !empty) begin
                r_data <= mem[rd_ptr[2:0]];
                rd_ptr <= rd_ptr + 1'b1;
            end
        end
    end

endmodule
