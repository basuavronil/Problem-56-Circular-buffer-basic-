`timescale 1ns / 1ps

module circular_buffer_tb;

    reg        clk;
    reg        rst;
    reg        wr;
    reg        rd;
    reg  [7:0] w_data;
    wire [7:0] r_data;
    wire       full;
    wire       empty;

    // Instantiate UUT
    circular_buffer uut (
        .clk(clk),
        .rst(rst),
        .wr(wr),
        .rd(rd),
        .w_data(w_data),
        .r_data(r_data),
        .full(full),
        .empty(empty)
    );

    // Waveform dump configuration
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, circular_buffer_tb);
    end

    // Signal Monitor for Terminal Output
    initial begin
        $monitor("[%0t ns] rst=%b | wr=%b w_data=%h | rd=%b r_data=%h | empty=%b full=%b",
                 $time, rst, wr, w_data, rd, r_data, empty, full);
    end

    // Clock generation: 100MHz (10ns Period)
    always #5 clk = ~clk;

    initial begin
        // 1. Initialize and assert Reset
        clk    = 0;
        rst    = 1;
        wr     = 0;
        rd     = 0;
        w_data = 0;

        @(posedge clk);
        #1;
        rst = 0;

        // 2. Write until Buffer is Full (8 Entries)
        repeat (8) begin
            @(posedge clk);
            wr = 1;
            w_data = w_data + 8'h11;
        end

        @(posedge clk);
        wr = 0; // Stop writing, full should be 1

        // 3. Read back all 8 entries
        repeat (8) begin
            @(posedge clk);
            rd = 1;
        end

        @(posedge clk);
        rd = 0; // Stop reading, empty should be 1

        // 4. Wrap-around Test: Concurrent Writes and Reads
        @(posedge clk);
        wr = 1; w_data = 8'hA5;
        @(posedge clk);
        wr = 1; w_data = 8'h5A; rd = 1;
        
        @(posedge clk);
        wr = 0; rd = 0;

        #20;
        $finish;
    end

endmodule
