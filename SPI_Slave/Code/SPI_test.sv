package SPI_test_pkg;
import SPI_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
  import SPI_config_pkg::*;
  import SPI_shared_pkg::*;
  import SPI_sequence_item_pkg::*;
  import SPI_sequence_pkg::*;
  import SPI_config_pkg::*;
  import SPI_env_pkg::*;

class SPI_test extends uvm_test;
    `uvm_component_utils(SPI_test)
    SPI_env env ; 
    SPI_config SPI_cfg;
    SPI_main_sequence main_seq ; 
    SPI_corner_sequence corner_seq ; 
    SPI_reset_sequence reset_seq ;
    virtual SPI_if SPI_vif_cfg;


    function new(string name = "SPI_test",uvm_component parent = null);
      super.new(name,parent);
    endfunction
    function void build_phase (uvm_phase phase);
      super.build_phase(phase);
        env = SPI_env::type_id::create("env",this);
        SPI_cfg = SPI_config::type_id::create("SPI_cfg");
        main_seq = SPI_main_sequence::type_id::create("main_seq");
        corner_seq = SPI_corner_sequence::type_id::create("corner_seq");
        reset_seq = SPI_reset_sequence::type_id::create("reset_seq");
      if(!uvm_config_db #(virtual SPI_if)::get(this,"","SPI_IF",SPI_cfg.SPI_vif_cfg))
        `uvm_fatal("build_phase","Test - unable to get the virtual interface")
      uvm_config_db #(SPI_config)::set(this,"*","SPI_CFG",SPI_cfg);
        SPI_cfg.is_active = UVM_ACTIVE;
    endfunction
  
    task run_phase (uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);
        `uvm_info("run_phase","RESET_SEQ",UVM_MEDIUM)
            reset_seq.start(env.agent.sqr);
        `uvm_info("run_phase","CORNER_SEQ",UVM_MEDIUM)
            corner_seq.start(env.agent.sqr);
        `uvm_info("run_phase","MAIN_SEQ",UVM_MEDIUM)
            main_seq.start(env.agent.sqr);
      phase.drop_objection(this);
    endtask: run_phase
endclass: SPI_test
endpackage