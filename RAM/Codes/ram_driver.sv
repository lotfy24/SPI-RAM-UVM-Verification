package ram_driver_pkg;
import ram_config_pkg::*;
import uvm_pkg::*;
import ram_sequence_item_pkg::*;
`include "uvm_macros.svh"

class ram_driver extends uvm_driver #(ram_sequence_item);
 // register ram_driver class to the factory
`uvm_component_utils(ram_driver)
// create handels
virtual ram_if ram_vif;
ram_sequence_item seq_item;
// constructor
function new(string name = "ram_driver", uvm_component parent = null);
    super.new(name,parent);
endfunction

//run phase
task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
    seq_item =ram_sequence_item::type_id::create("seq_item");
    seq_item_port.get_next_item(seq_item);

    ram_vif.rst_n       = seq_item.rst_n;
    ram_vif.rx_valid    = seq_item.rx_valid;
    ram_vif.din         = seq_item.din;
    
    @(negedge ram_vif.clk);
    seq_item_port.item_done();
    `uvm_info("run_phase",seq_item.convert2string_stimlus(),UVM_HIGH)
end
endtask
endclass
endpackage