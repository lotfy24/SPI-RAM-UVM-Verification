module top();
import uvm_pkg         ::*;
import wrapper_test_pkg::*;
`include "uvm_macros.svh"
    
    bit clk ;
    // clk_generation
    initial forever #1 clk =~clk;
    
    // Insentiation of interfaces
    wrapper_if wrapper_vif (clk);
    SPI_if     SPIIF       (clk); 
    ram_if     r_if        (clk);

    WRAPPER wrapper_inst(.wrapper_vif(wrapper_vif));
    bind wrapper_inst wrapper_sva assertions_inst (
    .wrapper_vif(wrapper_vif),
    .rx_valid(rx_valid),
    .din(din),
    .tx_valid(tx_valid)
);
SPI_assertions assertions_inst_spi (.SPIIF(SPIIF));
ram_SVA          assertions_inst_ram (.r_if(r_if));

                                                  
    WRAPPER_golden wrapper_inst_golden(.wrapper_vif(wrapper_vif));
    
    always_comb begin 

        SPIIF.MOSI  = wrapper_vif.MOSI ;
        SPIIF.rst_n = wrapper_vif.rst_n;
        SPIIF.SS_n  = wrapper_vif.SS_n ;
        SPIIF.MISO  = wrapper_vif.MISO ;
        
        SPIIF.MISO_gld = wrapper_vif.MISO_gld;
        // Assiging Values from the Wrapper_instance to the SPI_IF to monitor the data
        
        SPIIF.tx_data  = wrapper_inst.dout    ;
        SPIIF.tx_valid = wrapper_inst.tx_valid;
        SPIIF.rx_data  = wrapper_inst.din     ;
        SPIIF.rx_valid = wrapper_inst.rx_valid;

        SPIIF.rx_valid_gld = wrapper_inst_golden.rx_valid_gld;
        SPIIF.rx_data_gld  = wrapper_inst_golden.din_gld     ;
        /***************************Setting the IF of memory ***************************/
        // Assiging Values from the WrapperIF to the ram_IF to monitor the data
        
        r_if.rst_n = wrapper_vif.rst_n;
        
        // Assiging Values from the Wrapper_instance to the ram_IF to monitor the data

        r_if.dout     = wrapper_inst.dout    ;
        r_if.tx_valid = wrapper_inst.tx_valid;
        // updated
        if(SPIIF.rx_valid)begin
            r_if.din      = wrapper_inst.din     ;
        end
        
        r_if.rx_valid = wrapper_inst.rx_valid;

        r_if.tx_valid_golden = wrapper_inst_golden.tx_valid_golden;
        r_if.dout_golden     = wrapper_inst_golden.dout_golden    ;
    end

    initial begin
        uvm_config_db #(virtual wrapper_if) :: set(null,"uvm_test_top","wr_vif" ,wrapper_vif);
        uvm_config_db #(virtual SPI_if)     :: set(null,"uvm_test_top","spi_vif",SPIIF      );
        uvm_config_db #(virtual ram_if)     :: set(null,"uvm_test_top","ram_vif",r_if       );
        run_test("wrapper_test");
    end
endmodule : top