import SPI_shared_pkg::*;

module SPI_assertions(SPI_if SPIIF);
 

// Reset
property P1;
    (@(posedge SPIIF.clk) !SPIIF.rst_n |=> ((SPIIF.MISO == 1'b0) && (SPIIF.rx_valid == 1'b0) && (SPIIF.rx_data == 1'b0) ));
endproperty
reset: assert property(P1);
cover property(P1);


property P2;
    @(posedge SPIIF.clk) disable iff (!SPIIF.rst_n)
    ((SPIIF.SS_n == 1'b0) ##1 (SPIIF.MOSI == 1'b0) ##1 (SPIIF.MOSI == 1'b0) ##1 (SPIIF.MOSI == 1'b0))
    |-> ##10 (SPIIF.rx_valid == 1'b1) |=> (SPIIF.SS_n == 1'b1)[->1];
endproperty

valid_command: assert property (P2);
cover property (P2);

property P3;
    disable iff (!SPIIF.rst_n)
    (@(posedge SPIIF.clk) 
    ((SPIIF.SS_n == 1'b0) ##1 (SPIIF.MOSI == 1'b0) ##1 (SPIIF.MOSI == 1'b0) ##1 (SPIIF.MOSI == 1'b1))
    |-> ##10 (SPIIF.rx_valid == 1'b1)|=> (SPIIF.SS_n == 1'b1)[->1]);
endproperty

valid_command_1: assert property (P3);
cover property (P3);

property P4;
    disable iff (!SPIIF.rst_n)  
  (@(posedge SPIIF.clk) ((SPIIF.SS_n == 1'b0) ##1 (SPIIF.MOSI == 1'b1) ##1 (SPIIF.MOSI == 1'b1) ##1 (SPIIF.MOSI == 1'b0))
    |-> ##10 (SPIIF.rx_valid == 1'b1)|=> (SPIIF.SS_n == 1'b1)[->1]);
endproperty

valid_command_2: assert property (P4);
cover property (P4);

property P5;
    disable iff (!SPIIF.rst_n)
  (@(posedge SPIIF.clk) ((SPIIF.SS_n == 1'b0) ##1 (SPIIF.MOSI == 1'b1) ##1 (SPIIF.MOSI == 1'b1) ##1 (SPIIF.MOSI == 1'b1))
    |-> ##10 (SPIIF.rx_valid == 1'b1) |=> (SPIIF.SS_n == 1'b1)[->1]);
endproperty

valid_command_3: assert property (P5);
cover property (P5);


endmodule