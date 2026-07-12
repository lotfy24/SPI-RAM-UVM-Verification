module WRAPPER (wrapper_if.Wrapper_dut wrapper_vif);

bit tx_valid,rx_valid;
bit [9:0] din ;
bit [7:0] dout ;

RAM   RAM_instance( .din(din),
                    .clk(wrapper_vif.clk),
                    .rst_n(wrapper_vif.rst_n),  
                    .rx_valid(rx_valid),
                    .dout(dout),
                    .tx_valid(tx_valid)
                    );

SLAVE SLAVE_instance (  .MOSI(wrapper_vif.MOSI)
                       ,.MISO(wrapper_vif.MISO)
                       ,.SS_n(wrapper_vif.SS_n)
                       ,.clk(wrapper_vif.clk)
                       ,.rst_n(wrapper_vif.rst_n)
                       ,.rx_data(din)
                       ,.rx_valid(rx_valid)
                       ,.tx_data(dout)
                       ,.tx_valid(tx_valid)
                       );
endmodule