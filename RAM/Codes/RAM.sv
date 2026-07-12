import shared_pkg::*;
module RAM (clk,rst_n,din,rx_valid,tx_valid,dout);

// interface input
input clk;
// Design input ports
input  [9:0] din;
input  rst_n, rx_valid;
// Design output ports
output reg [7:0] dout;
output reg tx_valid;

reg [ADDR_SIZE-1:0] Rd_Addr, Wr_Addr;
reg [ADDR_SIZE-1:0] MEM [MEM_DEPTH-1:0];

always @(posedge clk) begin
    if (~rst_n) begin
        dout <= 0;
        tx_valid <= 0;
        Rd_Addr <= 0;
        Wr_Addr <= 0;
    end
    else begin                                         
        if (rx_valid) begin
            case (din[9:8])
                2'b00 :begin
                        Wr_Addr <= din[7:0];
                        tx_valid <= 0;
                end 
                2'b01 :begin
                        MEM[Wr_Addr] <= din[7:0];
                        tx_valid <=0;
                end 
                2'b10 :begin
                        Rd_Addr <= din[7:0];
                        tx_valid <=0;
                end 
                2'b11 :begin
                        dout <= MEM[Rd_Addr];      // Rd_Addr not Wr_Addr; BUG 1
                        tx_valid <=1;
                end 
                default : dout <= 0;
            endcase
        end
        //tx_valid <= (din[9] && din[8] && rx_valid)? 1'b1 : 1'b0; BUG 2
    end
end
endmodule