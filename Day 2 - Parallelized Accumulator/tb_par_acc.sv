module tb_par_acc;
  
  localparam TEST_VEC_SIZE = 16;
  
  // DUT I/Os
  logic clk;
  logic rstn;
  logic [0:3] enable;
  logic [0:3] [31:0] data;
  logic [63:0] acc_out;
  
  logic [4:0] counter;
  logic [0:TEST_VEC_SIZE-1] vec_enable = {1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
  logic [0:TEST_VEC_SIZE-1][31:0] vec_data = {32'd10, 32'd20, 32'd64, 32'd32, 32'd1, 32'd2, 32'd6, 32'd3, 32'd15, 32'd22, 32'd68, 32'd38, 32'd100, 32'd200, 32'd300, 32'd400};
  
  // DUT instantiation
  par_accumulator #(
    .PAR_FACT(4),
    .LOG_PAR_FACT(2),
    .DATA_WD(32),
    .ACC_WD(64)
  ) u_par_acc (
    .i_clk(clk),
    .i_rstn(rstn),
    .i_enable(enable),
    .i_data(data),
    .o_data(acc_out)
  );
  
  // Clock
  always begin
    #5 clk = ~clk;
  end
  
  // driver for data and enable inputs
  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      counter <= '0;
      data <= '0;
      enable <= '0;
    end 
    else begin
      if (counter != 4'd12) begin
      	counter <= counter + 4;
      end
      for (int i=0; i<4; i++) begin
        data[i] <= vec_data[counter+i];
        enable[i] <= vec_enable[counter+i];
      end
    end
  end
  
  // Test Sequence
  initial begin
    
    // Dump VCD
    $dumpfile("acc_tb.vcd");
    $dumpvars(0, tb_par_acc);
    
    // Initialize signals
    clk = 1'b0;
    rstn = 1'b0;
   
    // Remove Reset after 1.5 clock cycles
    #15 rstn = 1;
    
    #70;
    
    $finish;
  end
  
  // Signal monitor
  initial begin
    $monitor("At time %t, i_data = %d, i_enable = %b, o_data = %d", $time, data, enable, acc_out);
  end
endmodule
