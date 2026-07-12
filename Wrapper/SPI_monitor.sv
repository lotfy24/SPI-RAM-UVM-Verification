package SPI_monitor_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    import SPI_sequence_item_pkg::*;
    `include "uvm_macros.svh"
    class SPI_monitor extends uvm_monitor ;
        `uvm_component_utils(SPI_monitor);

        virtual SPI_if vif_cfg; 
        SPI_sequence_item mon_seq_item;

        uvm_analysis_port #(SPI_sequence_item) mon_ap;

        function new (string name = "SPI_monitor" , uvm_component parent = null);
            super.new(name,parent);            
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap",this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                mon_seq_item = SPI_sequence_item::type_id::create("mon_seq_item");
                @(negedge vif_cfg.clk);
                
                // Capture SPI input signals
                mon_seq_item.MOSI = vif_cfg.MOSI;
                mon_seq_item.rst_n = vif_cfg.rst_n;
                mon_seq_item.SS_n = vif_cfg.SS_n;
                mon_seq_item.tx_valid = vif_cfg.tx_valid;
                mon_seq_item.tx_data = vif_cfg.tx_data;
                
                // Capture SPI output signals (DUT)
                mon_seq_item.rx_valid = vif_cfg.rx_valid;
                mon_seq_item.MISO = vif_cfg.MISO;
                mon_seq_item.rx_data = vif_cfg.rx_data;
                
                // Capture SPI golden reference outputs
                mon_seq_item.rx_valid_gld = vif_cfg.rx_valid_gld;
                mon_seq_item.MISO_gld = vif_cfg.MISO_gld;
                mon_seq_item.rx_data_gld = vif_cfg.rx_data_gld;
                mon_ap.write(mon_seq_item);
                // `uvm_info("run_phase",mon_seq_item.convert2string_stimulus(),UVM_MEDIUM)
            end
        endtask   
    endclass
endpackage