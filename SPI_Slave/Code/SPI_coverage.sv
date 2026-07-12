package SPI_coverage_pkg;
    import uvm_pkg::*;
    import SPI_shared_pkg::*;
    import SPI_sequence_item_pkg::*;
    `include "uvm_macros.svh"
    class SPI_coverage extends uvm_component;
        `uvm_component_utils(SPI_coverage)
        
        uvm_analysis_export #(SPI_sequence_item) cov_export;
        uvm_tlm_analysis_fifo #(SPI_sequence_item) cov_fifo;
        SPI_sequence_item cov_seq_item;
        covergroup cvr_gp ;
            rx_data_msb_cp : coverpoint cov_seq_item.rx_data[9:8] {
                bins msb_00 = {2'b00};
                bins msb_01 = {2'b01};
                bins msb_10 = {2'b10};
                bins msb_11 = {2'b11};
                bins msb_transitions =  (2'b00 => 2'b01), (2'b00 => 2'b10), (2'b00 => 2'b11),
                                        (2'b01 => 2'b00), (2'b01 => 2'b10), (2'b01 => 2'b11),
                                        (2'b10 => 2'b00), (2'b10 => 2'b01), (2'b10 => 2'b11),
                                        (2'b11 => 2'b00), (2'b11 => 2'b01), (2'b11 => 2'b10);
            }
            SS_n_cp : coverpoint cov_seq_item.SS_n {
                bins SS_n_transitions_normal = (1'b1 => 0 [*12] => 1);
                bins SS_n_transitions_READ_DATA = (1'b1 => 0 [*22] => 1);
            }
            SS_ON_cp : coverpoint cov_seq_item.SS_n {
                bins SS_n_ON = (1'b1 => 1'b0 => 1'b0);
            }
            MOSI_valid_cp : coverpoint cov_seq_item.MOSI {
                bins MOSI_valid_transitions_WA = (1'b0[*3]);
                bins MOSI_valid_transitions_WD = (1'b0[*2] => 1'b1);
                bins MOSI_valid_transitions_RA = (1'b1[*2] => 1'b0);
                bins MOSI_valid_transitions_RD = (1'b1[*3]);
            }        
            MOSI_SS_cross : cross MOSI_valid_cp , SS_ON_cp ;
            // these commented line represents the Illegal and legal bins of the mix between SS_n time window and valid operations  
            //     option.cross_auto_bin_max = 0;
                
            //     // Legal operation scenarios - Write operations with normal timing (13 cycles)
            //     bins WRITE_ADDR_normal_timing = binsof(MOSI_valid_cp.MOSI_valid_transitions_WA) && 
            //                                    binsof(SS_n_cp.SS_n_transitions_normal);
            //     bins WRITE_DATA_normal_timing = binsof(MOSI_valid_cp.MOSI_valid_transitions_WD) && 
            //                                    binsof(SS_n_cp.SS_n_transitions_normal);
                
            //     // Legal operation scenarios - Read operations 
            //     bins READ_ADDR_normal_timing = binsof(MOSI_valid_cp.MOSI_valid_transitions_RA) && 
            //                                   binsof(SS_n_cp.SS_n_transitions_normal);
            //     bins READ_DATA_extended_timing = binsof(MOSI_valid_cp.MOSI_valid_transitions_RD) && 
            //                                     binsof(SS_n_cp.SS_n_transitions_READ_DATA);
                
            //     // Exclude irrelevant/illegal combinations
            //     ignore_bins WRITE_ADDR_wrong_timing = binsof(MOSI_valid_cp.MOSI_valid_transitions_WA) && 
            //                                          binsof(SS_n_cp.SS_n_transitions_READ_DATA);
            //     ignore_bins WRITE_DATA_wrong_timing = binsof(MOSI_valid_cp.MOSI_valid_transitions_WD) && 
            //                                          binsof(SS_n_cp.SS_n_transitions_READ_DATA);
            //     ignore_bins READ_ADDR_wrong_timing = binsof(MOSI_valid_cp.MOSI_valid_transitions_RA) && 
            //                                         binsof(SS_n_cp.SS_n_transitions_READ_DATA);
            //     ignore_bins READ_DATA_wrong_timing = binsof(MOSI_valid_cp.MOSI_valid_transitions_RD) && 
            //                                         binsof(SS_n_cp.SS_n_transitions_normal);
            //}
        endgroup

        function new(string name = "SPI_coverage",uvm_component parent = null);
            super.new(name , parent);
            cvr_gp = new();
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase (phase);
            cov_export = new("cov_export",this);
            cov_fifo = new("cov_fifo",this);
        endfunction
        function void  connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction
        task run_phase (uvm_phase phase);
            super.run_phase (phase);
            forever begin
                cov_fifo.get(cov_seq_item);
                cvr_gp.sample();
            end
        endtask
    endclass 
endpackage