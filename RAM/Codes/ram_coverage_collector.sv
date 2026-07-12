package ram_coverage_pkg;
import uvm_pkg::*;
import shared_pkg::*;
import ram_sequence_item_pkg::*;
`include "uvm_macros.svh"
class ram_coverage extends uvm_component;

`uvm_component_utils(ram_coverage) 
uvm_analysis_export #(ram_sequence_item) cov_export;
uvm_tlm_analysis_fifo #(ram_sequence_item) cov_fifo;
ram_sequence_item seq_item_cov;

// group coverage
covergroup cvr_gp;
    // Check din[9:8] takes 4 possible values 
    din_98:coverpoint seq_item_cov.din[9:8];
    // wCheck write data after write address
    wd_wa:coverpoint seq_item_cov.din[9:8] {
        bins wd_after_wa = (2'b00 => 2'b01);
    }
    // Check read data after read address
    rd_ra:coverpoint seq_item_cov.din[9:8] {
        bins rd_after_ra = (2'b10 => 2'b11);
    }
    // Check write address => write data => read address => read data
    din_trans:coverpoint seq_item_cov.din[9:8] {
        bins din_98_trans = (2'b00 => 2'b01 => 2'b10 => 2'b11);
    }
    // rx_valid
    rx_valid_cp:coverpoint seq_item_cov.rx_valid{
        bins rx_valid_value[] = {0,1};
    }
    // tx_valid
    tx_valid_cp:coverpoint seq_item_cov.tx_valid{
        bins tx_valid_value[] = {0,1};
    }
    // cross coverage 
    cross din_98,rx_valid_cp{
        option.cross_auto_bin_max = 0;
        bins din_98_rx_valid = binsof(din_98) && binsof(rx_valid_cp) intersect {1};
    }

    cross din_98,tx_valid_cp{
        option.cross_auto_bin_max = 0;
        bins din_98_rx_valid = binsof(din_98) intersect {2'b11} && binsof(tx_valid_cp) intersect {1};
    }
endgroup

function new(string name = "ram_coverage", uvm_component parent = null);
    super.new(name,parent);
    cvr_gp = new();
endfunction
// Build phase
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export",this);
    cov_fifo = new("cov_fifo",this);
endfunction
// connect phase
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
endfunction
// run phase
task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        cov_fifo.get(seq_item_cov);
        cvr_gp.sample();
    end

endtask

endclass
endpackage