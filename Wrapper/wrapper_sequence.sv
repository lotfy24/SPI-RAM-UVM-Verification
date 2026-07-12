package wrapper_seq_pkg;
import wrapper_seq_item_pkg::*;
import uvm_pkg             ::*;
`include "uvm_macros.svh"

// reset sequence
class wrapper_reset_seq extends uvm_sequence#(wrapper_sequence_item);
        `uvm_object_utils(wrapper_reset_seq)
        wrapper_sequence_item seq_item;

        function new(string name ="wrapper_reset_seq");
            super.new(name);
        endfunction

        task body();
            seq_item = wrapper_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
                seq_item.rst_n = 0;
                seq_item.MOSI  = 0;
                seq_item.SS_n  = 1;
                seq_item.MISO  = 0;
            finish_item(seq_item) ;

        endtask
    endclass

// write only sequence

class wrapper_wr_only_seq extends uvm_sequence#(wrapper_sequence_item);
    `uvm_object_utils(wrapper_wr_only_seq)
    wrapper_sequence_item seq_item;
    function new(string name ="wrapper_wr_only_seq");
        super.new(name);
    endfunction

    task body();
        seq_item = wrapper_sequence_item::type_id::create("seq_item");
        repeat(3000)begin
        start_item(seq_item);
            seq_item.operation_flag = 0;
            // seq_item.seq.constraint_mode(1);
            assert(seq_item.randomize());
        finish_item(seq_item);
        end
    endtask
endclass

// read and write  sequence
class wrapper_wr_rd_seq extends uvm_sequence#(wrapper_sequence_item);
        `uvm_object_utils(wrapper_wr_rd_seq)
        wrapper_sequence_item seq_item;

        function new(string name ="wrapper_wr_rd_seq");
            super.new(name);
        endfunction

        task body();
            seq_item =wrapper_sequence_item::type_id::create("seq_item");
            repeat(3000)begin
            start_item(seq_item);
                seq_item.operation_flag = 2;
            // seq_item.seq.constraint_mode(1);

                assert(seq_item.randomize());
            finish_item(seq_item);
            end
        endtask
endclass
// read only
class wrapper_rd_only_seq extends uvm_sequence#(wrapper_sequence_item);
        `uvm_object_utils(wrapper_rd_only_seq)
        wrapper_sequence_item seq_item;

        function new(string name ="wrapper_rd_only_seq");
            super.new(name);
        endfunction

        task body();
            seq_item = wrapper_sequence_item ::type_id::create("seq_item");
            repeat(3000)begin
                start_item(seq_item);
                    seq_item.operation_flag = 1;
            // seq_item.seq.constraint_mode(1);

                    assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask
endclass
endpackage 
