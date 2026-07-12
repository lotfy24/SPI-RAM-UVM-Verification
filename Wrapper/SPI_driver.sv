package SPI_driver_pkg ;
    import uvm_pkg::*;
    import shared_pkg::*;
    import SPI_sequence_item_pkg::*;
    `include "uvm_macros.svh"
    class SPI_driver extends uvm_driver #(SPI_sequence_item);
      `uvm_component_utils(SPI_driver)
        virtual SPI_if vif_cfg;
        SPI_sequence_item stim_seq_item;

        function new (string name = "SPI_driver",uvm_component parent = null);
            super.new(name,parent);            
        endfunction        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin 
                seq_item_port.get_next_item(stim_seq_item);
                    vif_cfg.rst_n = stim_seq_item.rst_n;
                    vif_cfg.MOSI =  stim_seq_item.MOSI;
                    vif_cfg.SS_n =  stim_seq_item.SS_n;
                    vif_cfg.tx_valid =  stim_seq_item.tx_valid;
                    vif_cfg.tx_data =  stim_seq_item.tx_data;
                    @(negedge vif_cfg.clk);
                seq_item_port.item_done();
                `uvm_info("run_phase",stim_seq_item.convert2string_stimulus(),UVM_MEDIUM)
            end
        endtask
    endclass
endpackage