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

module par_accumulator #(
  parameter PAR_FACT = 4,
  parameter LOG_PAR_FACT = 2,
  parameter DATA_WD = 32,
  parameter ACC_WD = 64
) (
  input logic i_rstn,
  input logic i_clk,
  input logic [0:PAR_FACT-1] [DATA_WD-1:0] i_data,
  input logic [0:PAR_FACT-1] i_enable,
  output logic [ACC_WD-1:0] o_data
);
  
  logic [ACC_WD-1:0] o_data_nxt;
  
  // Parallelised acc data
  logic [0:PAR_FACT-1] [ACC_WD-1:0] par_intm_data;
  
  // Parallelised accumulator
  genvar i;
   generate 
     for (i=0; i<PAR_FACT; i++) begin
       accumulator #(.DATA_WD(DATA_WD), .ACC_WD(ACC_WD)) u_acc (.*, .i_data(i_data[i]), .i_enable(i_enable[i]), .o_data(par_intm_data[i]));
     end
   endgenerate
  
  // Array adder - implementation left to synthesiser
  always_comb begin
    o_data_nxt = '0;
    for (int i=0; i<PAR_FACT; i++) begin
      o_data_nxt += par_intm_data[i];
    end
  end
  
  // Accumulator output
  always_ff @(posedge i_clk or negedge i_rstn) begin
    if (!i_rstn)
      o_data <= '0;
    else
      o_data <= o_data_nxt;
  end
  
endmodule
