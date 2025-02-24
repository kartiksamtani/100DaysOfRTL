parameter ACC_WD = 64;

logic [ACC_WD:0] acc_nxt;
logic [ACC_WD-1:0] acc_nxt_sat;

// Some arithmetic on acc_nxt

assign acc_nxt = acc_reg + i_data;

// Saturation of acc_nxt - Logic 1

assign acc_nxt_sat = (acc_nxt > {ACC_WD{1'b1}})? '1: acc_nxt[ACC_WD-1:0];
  
// Saturation of acc_nxt - Logic 2
  
assign acc_nxt_sat = (acc_nxt[ACC_WD])? '1: acc_nxt[ACC_WD-1:0];
