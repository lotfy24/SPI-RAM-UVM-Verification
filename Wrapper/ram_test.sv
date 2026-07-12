package ram_test_pkg;
import ram_env_pkg::*;
import ram_config_pkg::*;
import ram_agent_pkg::*;
import ram_sequencer_pkg::*;
import ram_sequence_pkg::*;
import uvm_pkg::*;
 `include "uvm_macros.svh"
 class ram_test extends uvm_test;
 // register ram_test class to the factory
`uvm_component_utils(ram_test);
// create handels
ram_config ram_cfg;
ram_reset_sequence reset_sequence;
ram_write_only_sequence write_only_sequence;
ram_read_only_sequence read_only_sequence;
ram_write_read_sequence write_read_sequence;
ram_env env;
virtual ram_if ram_vif;
// constructor
function new(string name = "ram_test", uvm_component parent = null);
    super.new(name,parent);
endfunction
// build phase 
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = ram_env::type_id::create("env",this);
    reset_sequence = ram_reset_sequence::type_id::create("reset_sequence",this);
    write_only_sequence = ram_write_only_sequence::type_id::create("write_only_sequence",this);
    read_only_sequence = ram_read_only_sequence::type_id::create("read_only_sequence",this);
    write_read_sequence = ram_write_read_sequence::type_id::create("write_read_sequence",this);
    ram_cfg = ram_config::type_id::create("ram_cfg",this);

    if(!uvm_config_db#(virtual ram_if)::get(this,"","ram_if",ram_cfg.ram_vif))begin
      `uvm_fatal("build_phase","Error in build phase");
    end
    uvm_config_db#(ram_config)::set(this,"*","CFG",ram_cfg);
endfunction
// run phase 
task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);

    `uvm_info("run_phase","reset generation start",UVM_MEDIUM)
      reset_sequence.start(env.agt.sqr);
    `uvm_info("run_phase","reset deasserted",UVM_MEDIUM)

    `uvm_info("run_phase","WRITE generation start",UVM_MEDIUM)
      write_only_sequence.start(env.agt.sqr);
    `uvm_info("run_phase","WRITE generation END",UVM_MEDIUM)

    `uvm_info("run_phase","READ generation start",UVM_MEDIUM)
      read_only_sequence.start(env.agt.sqr);
    `uvm_info("run_phase","READ generation end",UVM_MEDIUM)

    `uvm_info("run_phase","READ AND WRITE generation start",UVM_MEDIUM)
      write_read_sequence.start(env.agt.sqr);
    `uvm_info("run_phase","READ AND WRITE generation end",UVM_MEDIUM)

    phase.drop_objection(this);
endtask
 endclass   
endpackage