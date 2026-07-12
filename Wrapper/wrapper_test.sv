package wrapper_test_pkg;
import wrapper_env_pkg        ::*;
import wrapper_agent_pkg      ::*;
import wrapper_config_obj_pkg ::*;
import SPI_config_pkg         ::*;
import ram_config_pkg         ::*;

import SPI_env_pkg            ::*;
import ram_env_pkg            ::*;

import wrapper_seq_item_pkg   ::*;
import wrapper_seq_pkg        ::*;
import uvm_pkg                ::*;

`include "uvm_macros.svh"

class wrapper_test extends uvm_test;
  `uvm_component_utils(wrapper_test)

  wrapper_env         env             ;
  wrapper_reset_seq   reset_seq_inst  ;
  wrapper_rd_only_seq rd_only_seq_inst;
  wrapper_wr_only_seq wr_only_seq_inst;
  wrapper_wr_rd_seq   wr_rd_seq_inst  ;

  wrapper_object      object_inst    ;
  ram_config          ram_object_inst;
  SPI_config          spi_object_inst;

  SPI_env spi_env_inst;
  ram_env ram_env_inst;

  function new(string name="wrapper_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create sequences
    reset_seq_inst   = wrapper_reset_seq   ::type_id::create("reset_seq_inst"  );
    rd_only_seq_inst = wrapper_rd_only_seq ::type_id::create("rd_only_seq_inst");
    wr_only_seq_inst = wrapper_wr_only_seq ::type_id::create("wr_only_seq_inst");
    wr_rd_seq_inst   = wrapper_wr_rd_seq   ::type_id::create("wr_rd_seq_inst"  );

    // Create environments
    env          = wrapper_env ::type_id::create("env"         , this);
    spi_env_inst = SPI_env     ::type_id::create("spi_env_inst", this);
    ram_env_inst = ram_env     ::type_id::create("ram_env_inst", this);

    // Create config objects
    object_inst     = wrapper_object::type_id::create("object_inst"    );
    spi_object_inst = SPI_config    ::type_id::create("spi_object_inst");
    ram_object_inst = ram_config    ::type_id::create("ram_object_inst");

    // Get VIFs
    if (!uvm_config_db#(virtual wrapper_if)::get(this, "", "wr_vif", object_inst.wrapper_vif))
      `uvm_error("build_phase", "can't get the virtual interface")

    if (!uvm_config_db#(virtual SPI_if)::get(this, "", "spi_vif", spi_object_inst.SPI_vif_cfg))
      `uvm_error("build_phase", "can't get the virtual interface")

    if (!uvm_config_db#(virtual ram_if)::get(this, "", "ram_vif", ram_object_inst.ram_vif))//ram_vif = ram_vif
      `uvm_error("build_phase", "can't get the virtual interface")

    // Set active/passive
    ram_object_inst.is_active = UVM_PASSIVE;
    spi_object_inst.is_active = UVM_PASSIVE;
    object_inst.is_active     = UVM_ACTIVE ;

    // Push configs to DB
    uvm_config_db#(wrapper_object)::set(this, "*", "wrapper_CFG", object_inst);//wrapper_CFG = object_inst
    uvm_config_db#(ram_config)    ::set(this, "*", "RAM_CFG", ram_object_inst);//RAM_CFG = ram_object_inst
    uvm_config_db#(SPI_config)    ::set(this, "*", "SPI_CFG", spi_object_inst);//SPI_CFG = spi_object_inst
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);

    `uvm_info("run_phase", "Start reset", UVM_LOW)
    reset_seq_inst.start(env.agent.sqr);
    `uvm_info("run_phase", "End reset", UVM_LOW)

    `uvm_info("run_phase", "Start write only seq", UVM_LOW)
    wr_only_seq_inst.start(env.agent.sqr);
    `uvm_info("run_phase", "End write only seq", UVM_LOW)

    `uvm_info("run_phase", "Start read only seq", UVM_LOW)
    rd_only_seq_inst.start(env.agent.sqr);
    `uvm_info("run_phase", "End read only seq", UVM_LOW)

    `uvm_info("run_phase", "Start write+read seq", UVM_LOW)
    wr_rd_seq_inst.start(env.agent.sqr);
    `uvm_info("run_phase", "End write+read seq", UVM_LOW)

    phase.drop_objection(this);
  endtask
endclass
endpackage
