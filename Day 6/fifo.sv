module fifo #(
    parameter DATA_WIDTH = 8,    // Data width (e.g., 8 bits)
    parameter FIFO_DEPTH = 16    // FIFO depth (number of entries)
) (
    input logic clk,               // Clock signal
    input logic rst_n,             // Active-low reset
    input logic wr_en,             // Write enable
    input logic rd_en,             // Read enable
    input logic [DATA_WIDTH-1:0] data_in,  // Data input
    output logic [DATA_WIDTH-1:0] data_out, // Data output
    output logic full,             // FIFO full flag
    output logic empty             // FIFO empty flag
);

    // FIFO memory array
    logic [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];

    // Write and read pointers
    logic [31:0] wr_ptr, rd_ptr;

    // Full and empty flags
    assign full = (wr_ptr == rd_ptr - 1);
    assign empty = (wr_ptr == rd_ptr);

    // Write operation
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            fifo_mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // Read operation
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 0;
        end else if (rd_en && !empty) begin
            data_out <= fifo_mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end

endmodule
