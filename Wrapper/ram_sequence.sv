package ram_sequence_pkg;
import ram_sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
// reset_sequence
class ram_reset_sequence extends uvm_sequence #(ram_sequence_item);
// register ram_reset_sequence class to the factory
`uvm_object_utils(ram_reset_sequence)
// create a handel form ram_sequence_item class
ram_sequence_item seq_item;
// constructor
function new(string name ="ram_reset_sequence");
    super.new(name);
endfunction
// body task
task body();
        // create object from ram_sequence_item class
        seq_item = ram_sequence_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.rst_n = 0;
        seq_item.din =0;
        seq_item.rx_valid =0;
        finish_item(seq_item);
endtask
endclass

// write_only_sequence
class ram_write_only_sequence extends uvm_sequence #(ram_sequence_item);
// register ram_write_only_sequence class to the factory
`uvm_object_utils(ram_write_only_sequence)
// create a handel form ram_sequence_item class
ram_sequence_item seq_item;
// constructor
function new(string name ="ram_write_only_sequence");
    super.new(name);
endfunction
// body task
task body();
    // create object from ram_sequence_item class
    seq_item = ram_sequence_item::type_id::create("seq_item");
    repeat(10000)begin
        start_item(seq_item);
        seq_item.constraint_mode(0);                // disable all constraints
        seq_item.write_only_c.constraint_mode(1);   // enable write constraint
        assert(seq_item.randomize());
        finish_item(seq_item);
    end   
endtask
endclass

// read_only_sequence
class ram_read_only_sequence extends uvm_sequence #(ram_sequence_item);
// register ram_read_only_sequence class to the factory
`uvm_object_utils(ram_read_only_sequence)
// create a handel form ram_sequence_item class
ram_sequence_item seq_item;
// constructor
function new(string name ="ram_read_only_sequence");
    super.new(name);
endfunction
// body task
task body();
    // create object from ram_sequence_item class
    seq_item = ram_sequence_item::type_id::create("seq_item");
    repeat(10000)begin
        start_item(seq_item);
        seq_item.constraint_mode(0);                // disable all constraints
        seq_item.read_only_c.constraint_mode(1);   // enable read constraint
        assert(seq_item.randomize());
        finish_item(seq_item);
    end   
endtask
endclass

// write_read_sequence
class ram_write_read_sequence extends uvm_sequence #(ram_sequence_item);
// register ram_write_read_sequence class to the factory
`uvm_object_utils(ram_write_read_sequence)
// create a handel form ram_sequence_item class
ram_sequence_item seq_item;
// constructor
function new(string name ="ram_write_read_sequence");
    super.new(name);
endfunction
// body task
task body();
    // create object from ram_sequence_item class
    seq_item = ram_sequence_item::type_id::create("seq_item");
    repeat(50000)begin
        start_item(seq_item);
        seq_item.constraint_mode(0);                // disable all constraints
        seq_item.read_write_c.constraint_mode(1);   // enable read and write  constraint
        assert(seq_item.randomize());
        finish_item(seq_item);
    end   
endtask
endclass
endpackage