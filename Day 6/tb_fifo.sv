module tb_fifo;

    // Parameters
    parameter DATA_WIDTH = 8;    // Data width (e.g., 8 bits)
    parameter FIFO_DEPTH = 16;    // FIFO depth (number of entries)

    // Signals for FIFO
    logic clk;
    logic rst_n;
    logic wr_en;
    logic rd_en;
    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;
    logic full;
    logic empty;

    // Instantiate the FIFO module
    fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always #5 clk = ~clk; // Clock period of 10ns

    // Test stimulus
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        // Reset the FIFO
        #10 rst_n = 1; // Release reset after 10ns
        #10 rst_n = 0; // Assert reset again to ensure initial state
        #10 rst_n = 1; // Release reset

        // Write data to FIFO
        #10 wr_en = 1;
        data_in = 8'h01; // Write 0x01 to FIFO
        #10 data_in = 8'h02; // Write 0x02
        #10 data_in = 8'h03; // Write 0x03

        // Disable write enable and enable read
        #10 wr_en = 0;
        rd_en = 1;

        // Read data from FIFO
        #10 $display("Read data: %h", data_out);
        #10 $display("Read data: %h", data_out);
        #10 $display("Read data: %h", data_out);

        // Check empty condition
        #10 if (empty) $display("FIFO is empty");

        // Test full condition by writing until full
        #10 wr_en = 1;
        data_in = 8'h04;
        #10 data_in = 8'h05;
        #10 data_in = 8'h06;
        #10 data_in = 8'h07;
        #10 data_in = 8'h08;
        #10 data_in = 8'h09;
        #10 data_in = 8'h0A;
        #10 data_in = 8'h0B;
        #10 data_in = 8'h0C;
        #10 data_in = 8'h0D;
        #10 data_in = 8'h0E;
        #10 data_in = 8'h0F;
        #10 data_in = 8'h10;
        #10 data_in = 8'h11;
        #10 data_in = 8'h12;

        // Try writing one more value when FIFO is full
        #10 data_in = 8'h13;
        if (full) $display("FIFO is full, cannot write 0x13");

        // Finish simulation
        #10 $finish;
    end

endmodule
