interface ram_if(clk);
// interface input
input  clk;
// Design input ports
bit [9:0] din;
bit rst_n, rx_valid;
// Design output ports
logic [7:0] dout;
logic tx_valid;

// Golden model output ports
logic [7:0] dout_golden;
logic tx_valid_golden;

modport DUT (input clk,rst_n,rx_valid,din,output tx_valid,dout);

modport GOLDEN (input clk,rst_n,rx_valid,din,output tx_valid_golden,dout_golden);

endinterface