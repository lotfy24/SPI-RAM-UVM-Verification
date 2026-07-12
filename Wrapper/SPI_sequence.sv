package SPI_sequence_pkg;
    import uvm_pkg::*;
    import SPI_shared_pkg::*;
    import SPI_sequence_item_pkg::*;
    `include "uvm_macros.svh"

    class SPI_main_sequence extends uvm_sequence #(SPI_sequence_item);
        `uvm_object_utils(SPI_main_sequence)
        
        SPI_sequence_item seq_item ; 
        
        function new(string name = "SPI_main_sequence");
            super.new(name);
        endfunction //new()
        
        task body ();
            seq_item = SPI_sequence_item::type_id::create("seq_item");
            repeat(50000) begin
                start_item(seq_item);
                    assert (seq_item.randomize());
                finish_item(seq_item);
            end        
        endtask 
    endclass //SPI_main_sequence extends uvm_sequence
    
    class SPI_corner_sequence extends uvm_sequence #(SPI_sequence_item);
        `uvm_object_utils(SPI_corner_sequence)
        
        SPI_sequence_item seq_item ; 
        
        function new(string name = "SPI_corner_sequence");
            super.new(name);
        endfunction //new()
        
        task body ();
            seq_item = SPI_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
                seq_item.rst_n = 1; 
            finish_item(seq_item);
            seq_item = SPI_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
                seq_item.rst_n = 0;
                seq_item.SS_n = 0 ;
            finish_item(seq_item);
            seq_item = SPI_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
                seq_item.SS_n = 1 ;
            finish_item(seq_item);
            seq_item = SPI_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
                seq_item.SS_n = 0;
            finish_item(seq_item);
        endtask 
    endclass

    class SPI_reset_sequence extends uvm_sequence #(SPI_sequence_item);
        `uvm_object_utils(SPI_reset_sequence)

        SPI_sequence_item seq_item ; 

        function new(string name = "SPI_reset_sequence");
            super.new(name);
        endfunction //new()

        task body ();
            // First transaction - assert reset
            seq_item = SPI_sequence_item::type_id::create("seq_item");
            start_item(seq_item);  
                seq_item.rst_n = 1; 
            finish_item(seq_item);
            
            // Second transaction - deassert reset  
            seq_item = SPI_sequence_item::type_id::create("seq_item");
            start_item(seq_item);  
                seq_item.rst_n = 0; 
            finish_item(seq_item);
            
            // Third transaction - assert reset again
            seq_item = SPI_sequence_item::type_id::create("seq_item");
            start_item(seq_item);  
                seq_item.rst_n = 1; 
            finish_item(seq_item);
        endtask
    endclass //SPI_reset_sequence extends uvm_sequence

endpackage