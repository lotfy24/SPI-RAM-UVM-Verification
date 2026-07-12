import shared_pkg::*;
module Single_port_SYNC_RAM (clk,rst_n,din,rx_valid,tx_valid_golden,dout_golden);

reg [ADDR_SIZE-1:0] MEM [MEM_DEPTH-1:0];
reg [ADDR_SIZE-1:0] Rd_Addr, Wr_Addr;
// interface input
input clk;
// Design input ports
input  [9:0] din;
input  rst_n, rx_valid;
// Design output ports
output reg [7:0] dout_golden;
output reg tx_valid_golden;
 // GENERATE MEMORY
 reg [ADDR_SIZE-1:0] RAM [MEM_DEPTH-1:0];
 // DEFINE 2 ADDRESSES ONE FOR WRITE AND ONE FOR READ
reg [ADDR_SIZE-1:0] wr_address , rd_address ;
 // DESIGN IMPLEMENTATION
 always @(posedge clk) begin
    if(~rst_n)begin
      dout_golden <= 0;
      tx_valid_golden <= 0;
      wr_address <= 0;
      rd_address <= 0;
    end
    else begin
        if(rx_valid)begin
          case (din[9:8])
            2'b00:begin
                  wr_address <= din[7:0];
                  tx_valid_golden <= 0;
            end 
            2'b01:begin
                  RAM[wr_address] <= din[7:0];
                  tx_valid_golden <= 0;
            end 
            2'b10:begin
                  rd_address <= din[7:0];
                  tx_valid_golden <= 0;
            end 
            2'b11:begin
                   dout_golden <= RAM[rd_address];
                   tx_valid_golden <= 1;
            end
            default: dout_golden <=0;
         endcase
        end     
    end    
 end    
 endmodule