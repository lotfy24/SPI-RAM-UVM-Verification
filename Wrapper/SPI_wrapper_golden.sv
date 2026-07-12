module WRAPPER_golden (wrapper_if.Wrapper_gld wrapper_vif);
 
bit rx_valid_gld,tx_valid_golden;
bit [9:0] din_gld ; 
bit [7:0] dout_golden ;


Single_port_SYNC_RAM   RAM_instance_golden( .din(din_gld),
                                            .clk(wrapper_vif.clk),
                                            .rst_n(wrapper_vif.rst_n),  
                                            .rx_valid(rx_valid_gld),
                                            .dout_golden(dout_golden),
                                            .tx_valid_golden(tx_valid_golden)
                                        );

SPI_gld SLAVE_instance_golden (  .MOSI(wrapper_vif.MOSI)
                                ,.MISO_gld(wrapper_vif.MISO_gld)
                                ,.SS_n(wrapper_vif.SS_n)
                                ,.clk(wrapper_vif.clk)
                                ,.rst_n(wrapper_vif.rst_n)
                                ,.rx_data_gld(din_gld)
                                ,.rx_valid_gld(rx_valid_gld)
                                ,.tx_data(dout_golden)
                                ,.tx_valid(tx_valid_golden)
                            );
endmodule