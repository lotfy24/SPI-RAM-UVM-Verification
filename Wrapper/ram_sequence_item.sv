package ram_sequence_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class ram_sequence_item extends uvm_sequence_item;
    // register the class ram_sequence_item to the factory
    `uvm_object_utils(ram_sequence_item)
    // randomize the input data
    rand bit rst_n,rx_valid;
    rand bit [9:0] din;

    logic  tx_valid;
    logic  [7:0] dout;

    logic [7:0] dout_golden;
    logic tx_valid_golden;


    // constructor
    function new(string name = "ram_sequence_item");
        super.new(name);
    endfunction
    // use built in convert2string function
    function string convert2string();
        return $sformatf("%s,rst_n=%b,rx_valid=%b,din=%d,tx_valid=%b,dout=%d,dout_golden=%d,tx_valid_golden=%b",super.convert2string(),
                         rst_n,rx_valid,din,tx_valid,dout,dout_golden,tx_valid_golden);
    endfunction
    // create convert2string_stimlus function
    function string convert2string_stimlus();
        return $sformatf("%s,rst_n=%b,rx_valid=%b,din=%d",super.convert2string(),rst_n,rx_valid,din);
    endfunction
    // constraint
    bit [1:0] prev_din;

    constraint write_only_c{
        // reset constraint
        rst_n dist{0:/5,1:/95};
        // rx_valid constraint
        rx_valid dist{0:/5,1:/95};
        // write constraint
        if (prev_din == 2'b00){
            din[9:8] inside {2'b00, 2'b01};
        }
        else if(prev_din == 2'b01){
             din[9:8] == 2'b00;
        }
    }
    constraint read_only_c{
        // reset constraint
        rst_n dist{0:/5,1:/95};
        // rx_valid constraint
        rx_valid dist{0:/5,1:/95};
        // read constraint
        if (prev_din == 2'b10){
            din[9:8]  == 2'b11;
        }
        else if(prev_din == 2'b11){
            din[9:8] == 2'b10;
        }
    }
    constraint read_write_c{
        // reset constraint
        rst_n dist{0:/5,1:/95};
        // rx_valid constraint
        rx_valid dist{0:/5,1:/95};
        // write and read constraint
        if (prev_din == 2'b00){
            din[9:8] inside {2'b00, 2'b01};
        }
        else if (prev_din == 2'b01){
            din[9:8] dist {2'b10:/60, 2'b00:/40};
        }
        else if (prev_din == 2'b10){
            din[9:8] inside {2'b10, 2'b11};
        }
        else if (prev_din == 2'b11){
            din[9:8] dist {2'b00:/60, 2'b10:/40};
        }
    }
    function void post_randomize();
    prev_din = din[9:8]; // Save the current din[9:8]  for next transaction
endfunction

endclass    
endpackage