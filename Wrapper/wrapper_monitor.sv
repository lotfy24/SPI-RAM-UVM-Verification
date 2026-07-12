package wrapper_monitor_pkg;
import uvm_pkg             ::*;
import wrapper_seq_item_pkg::*;
`include "uvm_macros.svh"

    class wrapper_monitor extends uvm_monitor;
        `uvm_component_utils(wrapper_monitor);

        virtual wrapper_if    wrapper_vif ;
        wrapper_sequence_item mon_seq_item;
        uvm_analysis_port #(wrapper_sequence_item) mon_ap;

        function new (string name = "wrapper_monitor" , uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap",this);
        endfunction

        task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        mon_seq_item = wrapper_sequence_item::type_id::create("mon_seq_item");
        @(negedge wrapper_vif.clk);

        mon_seq_item.rst_n    = wrapper_vif.rst_n;
        mon_seq_item.MISO     = wrapper_vif.MISO ;
        mon_seq_item.MOSI     = wrapper_vif.MOSI ;
        mon_seq_item.SS_n     = wrapper_vif.SS_n ;

        mon_seq_item.MISO_gld = wrapper_vif.MISO_gld;
        
        mon_ap.write(mon_seq_item);
        `uvm_info("run_phase",mon_seq_item.convert2string(),UVM_HIGH)
    end
endtask
    endclass
endpackage