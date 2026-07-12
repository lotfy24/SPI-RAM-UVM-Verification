import SPI_shared_pkg::*;

module SPI_assertions(SPI_if SPIIF);
    // always_comb begin 
    //         if(!SPIIF.rst_n) begin
    //             a_reset_count: assert final(SPIIF.MISO == 1'b0);  
    //             a_reset_max: assert final(SPIIF.rx_data == 10'b0);  
    //             a_reset_zero: assert final(SPIIF.rx_valid == 1'b0);  
    //         end
    // end
    // property p_rst_n;
    //     @(posedge SPIIF.clk) !rst_n |-> 
    //     ##1 (SPIIF.MISO == 1'b0 && (SPIIF.rx_data == 10'b0) && (SPIIF.rx_valid == 1'b0));
    // endproperty
    // a_rst_n: assert property(p_rst_n) else $error("ASSERTION FAILED:a_rst_n");
    // c_rst_n: cover property(p_rst_n);
// property p_OR;
//         @(posedge SPIIF.clk) disable iff(SPIIF.rst)
//         (SPIIF.opcode == OR && !SPIIF.red_op_A && !SPIIF.red_op_B && !SPIIF.bypass_A && !SPIIF.bypass_B) |-> 
//         ##2 (SPIIF.out == $past(SPIIF.A,2) | $past(SPIIF.B,2));
//     endproperty
// a_OR: assert property(p_OR) else $error("ASSERTION FAILED:a_OR");
// c_OR: cover property(p_OR);

// Reset
property P1;
    (@(posedge SPIIF.clk) !SPIIF.rst_n |=> ((SPIIF.MISO == 1'b0) && (SPIIF.rx_valid == 1'b0) && (SPIIF.rx_data == 1'b0) ));
endproperty
reset: assert property(P1);
cover property(P1);
/* check that after any valid command sequence the rx_valid signal must assert exactly after 10 cycles 
and the SS_n should eventually after the 10 cycles to close communication*/

property P2;
    disable iff (!SPIIF.rst_n)
    (@(posedge SPIIF.clk) 
    ((SPIIF.SS_n == 1'b0) ##1 (SPIIF.MOSI == 1'b0) ##1 (SPIIF.MOSI == 1'b0) ##1 (SPIIF.MOSI == 1'b0))
    |-> ##10 (SPIIF.rx_valid == 1'b1) |-> (SPIIF.SS_n == 1'b1)[->1]);
endproperty

valid_command: assert property (P2);
cover property (P2);

property P3;
    disable iff (!SPIIF.rst_n)
    (@(posedge SPIIF.clk) 
    ((SPIIF.SS_n == 1'b0) ##1 (SPIIF.MOSI == 1'b0) ##1 (SPIIF.MOSI == 1'b0) ##1 (SPIIF.MOSI == 1'b1))
    |-> ##10 (SPIIF.rx_valid == 1'b1)|->(SPIIF.SS_n == 1'b1)[->1]);
endproperty

valid_command_1: assert property (P3);
cover property (P3);

property P4;
    disable iff (!SPIIF.rst_n)  
    (@(posedge SPIIF.clk) ((SPIIF.SS_n == 1'b0) ##1 (SPIIF.MOSI == 1'b1) ##1 (SPIIF.MOSI == 1'b1) ##1 (SPIIF.MOSI == 1'b0))
    |-> ##10 (SPIIF.rx_valid == 1'b1) |-> (SPIIF.SS_n == 1'b1)[->1]);
endproperty

valid_command_2: assert property (P4);
cover property (P4);

property P5;
    disable iff (!SPIIF.rst_n)
    (@(posedge SPIIF.clk) ((SPIIF.SS_n == 1'b0) ##1 (SPIIF.MOSI == 1'b1) ##1 (SPIIF.MOSI == 1'b1) ##1 (SPIIF.MOSI == 1'b1))
    |-> ##10 (SPIIF.rx_valid == 1'b1) |-> (SPIIF.SS_n == 1'b1)[->1]);
endproperty

valid_command_3: assert property (P5);
cover property (P5);


endmodule