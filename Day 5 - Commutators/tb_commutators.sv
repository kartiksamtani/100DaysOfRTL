module commutator_tb;

    parameter WIDTH = 16;
    logic clk;
    logic rst;
    logic [WIDTH-1:0] data_in;
    logic [WIDTH-1:0] data_out [3:0];

    // Instantiate the commutator
    commutator #(WIDTH) uut (
        .clk(clk),
        .rst_n(rst),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period

    initial begin
        // Initialize signals
      $dumpfile("commutator.vcd");
      $dumpvars(0,commutator_tb);
        clk = 0;
        rst = 0;
        data_in = 0;

        // Reset the commutator
        #10 rst = 1;

        // Apply test stimulus
        repeat (16) begin
            #10 data_in = $random % 256; // Random 8-bit values
            $display("Time=%0t | data_in=%0d | data_out[0]=%0d data_out[1]=%0d data_out[2]=%0d data_out[3]=%0d",
                $time, data_in, data_out[0], data_out[1], data_out[2], data_out[3]);
        end

        // End simulation
        #50 $finish;
    end

endmodule
