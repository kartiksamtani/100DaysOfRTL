module accumulator #(
  parameter DATA_WD = 32,
  parameter ACC_WD = 64
) (
  input logic i_clk, // input clock signal
  input logic i_rstn, // input active low reset
  input logic i_enable, // accumulation enable
  input logic [DATA_WD-1:0] i_data, // input data to be accumulated
  output logic [ACC_WD-1:0] o_data // accumulator output
);
  
  logic [ACC_WD-1:0] acc_reg;
  logic [ACC_WD-1:0] acc_nxt;
  
  assign acc_nxt = acc_reg + i_data;
  assign o_data = acc_reg;
  
  always_ff @(posedge i_clk or negedge i_rstn) begin
     
    if (!i_rstn) begin // active low reset
      acc_reg <= '0;
    end else if (i_enable) begin // enable controlled accumulation
      acc_reg <= acc_nxt;
    end
    
  end
  
endmodule
