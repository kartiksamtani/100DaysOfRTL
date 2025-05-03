module commutator #(parameter WIDTH = 16) (
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic [WIDTH-1:0]      data_in,
    output logic [WIDTH-1:0]      data_out [3:0]
);

    logic [1:0] counter;  // 2-bit counter to switch between channels



    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out[0] <= 0;
            data_out[1] <= 0;
            data_out[2] <= 0;
            data_out[3] <= 0;
      		counter <= 2'b00;
        end
        else begin
            data_out[counter] <= data_in; // Route input to the correct output channel
          	counter <= counter + 2'b01;
        end
    end

endmodule
