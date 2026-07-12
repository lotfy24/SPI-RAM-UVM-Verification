package wrapper_scoreboard_pkg;
import uvm_pkg             ::*;
import wrapper_seq_item_pkg::*;

`include "uvm_macros.svh"


    class wrapper_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(wrapper_scoreboard)

        uvm_analysis_export   #(wrapper_sequence_item) sb_export;
        uvm_tlm_analysis_fifo #(wrapper_sequence_item) sb_fifo  ;
        wrapper_sequence_item sb_seq_item;

        function new (string name = "wrapper_scoreboard",uvm_component parent = null);
            super.new(name,parent);
        endfunction

        int error_count , correct_count ;
        
        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export",this);
            sb_fifo   = new("sb_fifo"  ,this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction


    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(sb_seq_item);

            if(sb_seq_item.MISO != sb_seq_item.MISO_gld ) begin
                `uvm_error("run_phase",$sformatf("!!!!!!!!!!!!!!!!!!!At time %0t: ERROR!! transaction data is : %s",$realtime,sb_seq_item.convert2string_stimlus))
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
        
    endclass
endpackage