module acc_tb; 
  
  localparam TEST_VEC_SIZE = 5;
  
  // DUT I/Os
  logic clk;
  logic rstn;
  logic enable;
  logic [3:0] data;
  logic [4:0] acc_out;
  
  logic [2:0] counter;
  logic [0:TEST_VEC_SIZE-1] vec_enable = {1'b1,1'b1,1'b1,1'b1,1'b0};
  logic [0:TEST_VEC_SIZE-1][3:0] vec_data = {4'd15, 4'd15, 4'd15, 4'd15, 4'd15};
  
  // DUT instantiation
  accumulator #(
    .DATA_WD(4),
    .ACC_WD(5)
  ) u_acc (
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
      if (counter != 3'd4) begin
      	counter <= counter + 1;
      end
      data <= vec_data[counter];
      enable <= vec_enable[counter];
    end
  end
  
  // Test Sequence
  initial begin
    
    // Dump VCD
    $dumpfile("acc_tb.vcd");
    $dumpvars(0, acc_tb);
    
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
    $monitor("At time %t, counter=%d, i_data = %d, i_enable = %b, o_data = %d", $time, counter, data, enable, acc_out);
  end
  
endmodule
