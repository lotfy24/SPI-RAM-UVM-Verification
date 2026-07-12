package SPI_scoreboard_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    import SPI_sequence_item_pkg::*;
    `include "uvm_macros.svh"
    
    class SPI_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(SPI_scoreboard)
        
        uvm_analysis_export #(SPI_sequence_item) sb_export;
        uvm_tlm_analysis_fifo #(SPI_sequence_item) sb_fifo;
        SPI_sequence_item sb_seq_item;
        
        int error_count , correct_count ;
        
        function new (string name = "SPI_scoreboard" , uvm_component parent = null);
            super.new(name,parent);
        endfunction
        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export",this);
            sb_fifo = new("sb_fifo",this);
        endfunction
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(sb_seq_item);
                // if(sb_seq_item.out != sb_seq_item.out_gld && sb_seq_item.leds != sb_seq_item.leds_gld ) begin
                if(sb_seq_item.rx_valid != sb_seq_item.rx_valid_gld  || sb_seq_item.MISO != sb_seq_item.MISO_gld || sb_seq_item.rx_data !=sb_seq_item.rx_data_gld  ) begin
                    // `uvm_error("run_phase",$sformatf("!!!!!!!!!!!!!!!!!!!At time %0t: ERROR!! transaction data is : %s",$realtime,sb_seq_item.convert2string_stimulus))
                    `uvm_error("run_phase",$sformatf("At time %0t: ERROR!! output data is : %s",$realtime,sb_seq_item.convert2string))
                    error_count++;
                end
                else begin
                    `uvm_info ("run_phase",$sformatf("At time %t: Correct transaction data is : %s",$realtime,sb_seq_item.convert2string),UVM_HIGH);
                    correct_count++;                    
                end
            end
        endtask
        function void report_phase (uvm_phase phase);
            super.report_phase(phase);
            `uvm_info ("report_phase",$sformatf("Correct_count = %d , Error_count = %d",correct_count,error_count),UVM_MEDIUM);
        endfunction
    endclass //SPI_scoreboard extends uvm_scoreboard
    
endpackage