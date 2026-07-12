package ram_scoreboard_pkg;
import uvm_pkg::*;
import shared_pkg::*;
import ram_sequence_item_pkg::*;
`include "uvm_macros.svh"
int correct_count,error_count;
class ram_scoreboard extends uvm_scoreboard;
 // register ram_monitor class in the factory
`uvm_component_utils(ram_scoreboard)

uvm_analysis_export #(ram_sequence_item) sb_export;
uvm_tlm_analysis_fifo #(ram_sequence_item) sb_fifo;
ram_sequence_item seq_item_sb;


function new(string name = "ram_scoreboard", uvm_component parent = null);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_export = new("sb_export",this);
    sb_fifo = new("sb_fifo",this);
endfunction

function void connect_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        sb_fifo.get(seq_item_sb);

        if((seq_item_sb.dout !== seq_item_sb.dout_golden) || (seq_item_sb.tx_valid !== seq_item_sb.tx_valid_golden))begin
            `uvm_error("run_phase",$sformatf("comparison failed,transaction recived by the dut:%s
                        while the dout_golden:%d and tx_valid_golden:%b",
                        seq_item_sb.convert2string(),seq_item_sb.dout_golden,seq_item_sb.tx_valid_golden));
            error_count = error_count + 1;
        end
        else begin
            `uvm_info("run_phase",$sformatf("correct output :%s",seq_item_sb.convert2string()),UVM_HIGH);
            correct_count = correct_count +1;
        end
    end
endtask
 function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("correct_count = %d", correct_count), UVM_LOW);
            `uvm_info("report_phase", $sformatf("error_count = %d", error_count), UVM_LOW);
endfunction
endclass 
endpackage