package SPI_agent_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    import SPI_sequence_item_pkg::*;
    import SPI_sequencer_pkg::*;
    import SPI_driver_pkg::*;
    import SPI_config_pkg::*;
    import SPI_monitor_pkg::*;

    `include "uvm_macros.svh"
    class SPI_agent extends uvm_agent;
        `uvm_component_utils(SPI_agent)

        SPI_config SPI_cfg;
        SPI_driver drv ; 
        SPI_monitor mon;
        SPI_sequencer sqr ; 
        uvm_analysis_port #(SPI_sequence_item) agt_ap ; 

        function new (string name = "SPI_agent" , uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db#(SPI_config)::get(this,"","SPI_CFG",SPI_cfg)) begin
                `uvm_fatal("build_phase","unable to get confg object")
            end
            if(SPI_cfg.is_active == UVM_ACTIVE) begin
                drv =  SPI_driver::type_id::create("drv",this);          
                sqr =  SPI_sequencer::type_id::create("sqr",this);                    
            end
            mon =  SPI_monitor::type_id::create("mon",this);          
            agt_ap = new ("agt_ap",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            if(SPI_cfg.is_active == UVM_ACTIVE) begin
                drv.seq_item_port.connect(sqr.seq_item_export);
                drv.vif_cfg = SPI_cfg.SPI_vif_cfg;
            end
            mon.vif_cfg = SPI_cfg.SPI_vif_cfg;
            mon.mon_ap.connect(agt_ap);
        endfunction
    endclass //SPI_agent extends uvm_agent
endpackage