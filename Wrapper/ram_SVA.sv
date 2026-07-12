module ram_SVA(ram_if.DUT r_if);

// Reset
property P1;
    (@(posedge r_if.clk) !r_if.rst_n |=> ((r_if.dout == 8'b0) && (r_if.tx_valid == 1'b0)));
endproperty
reset: assert property(P1);
cover property(P1);

// tx_valid deasserted during address/data phases
property P2;
    disable iff (!r_if.rst_n)
    (@(posedge r_if.clk)
    (r_if.rx_valid && ((r_if.din[9:8] == 2'b00) || (r_if.din[9:8] == 2'b01) || (r_if.din[9:8] == 2'b10)))
    |=> (r_if.tx_valid == 1'b0)); 
endproperty
tx_valid_low: assert property(P2);
cover property(P2);

// tx_valid rises after read_data and falls after 1 cycle
property P3;
    disable iff (!r_if.rst_n)
    (@(posedge r_if.clk)
    (r_if.rx_valid && (r_if.din[9:8] == 2'b11))
    |=> (r_if.tx_valid == 1'b1) ##1 $fell(r_if.tx_valid)[->1]);
endproperty
tx_valid_rise_fall: assert property(P3);
cover property(P3);

// Write Address eventually followed by Write Data
property P4;
    @(posedge r_if.clk) disable iff (!r_if.rst_n)
    (r_if.rx_valid && (r_if.din[9:8] == 2'b00))
    |=>(r_if.rx_valid && (r_if.din[9:8] == 2'b01))[->1];  
endproperty
wa_wd: assert property(P4);
cover property(P4);

// Read Address eventually followed by Read Data
property P5;
  @(posedge r_if.clk) disable iff (!r_if.rst_n)
    (r_if.rx_valid && (r_if.din[9:8] == 2'b10))
    |=>(r_if.rx_valid && (r_if.din[9:8] == 2'b11))[->1];
endproperty

ra_rd: assert property (P5);
cover property (P5);
endmodule