package SPI_sequence_item_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    `include "uvm_macros.svh"
    `define WRITE_ADDR_ins 3'b000
    `define WRITE_DATA_ins 3'b001
    `define READ_ADDR_ins  3'b110
    `define READ_DATA_ins  3'b111
    
    class SPI_sequence_item extends uvm_sequence_item;
        `uvm_object_utils(SPI_sequence_item)
        
        rand bit  rst_n;
        rand bit [7:0] tx_data;
        rand bit MOSI_arr [11];
        
        // Non-randomized signals
        bit SS_n, tx_valid;
        logic MOSI;
        logic rx_valid, MISO;
        logic rx_valid_gld, MISO_gld;
        logic [9:0] rx_data, rx_data_gld;
        
        // Control variables
        int counter_SS_n;
        bit f_read_data; 
        bit f_read_addr; 
        int MOSI_arr_index;
        bit [2:0] cmd;
        
        function new(string name = "SPI_sequence_item");
            super.new(name);
            counter_SS_n = 0;
            MOSI_arr_index = 0;
            SS_n = 1;
            tx_valid = 0;
            f_read_data = 0;
            f_read_addr = 0;
        endfunction
    
        // Constraint 1: Reset deasserted most of the time (90%)
        constraint c_rst_n {
            rst_n dist {0:/10, 1:/90};
            // if (SS_n == 0){
            //     rst_n == 1 ;
            // }
        }
        
        // Constraint 3: First 3 bits of MOSI_arr must be valid command
        constraint c_MOSI {
            {MOSI_arr[0], MOSI_arr[1], MOSI_arr[2]} inside {3'b000, 3'b001, 3'b110, 3'b111};
        }

        
        // Post-randomize handles constraints 2, 3, and 4
        function void post_randomize();
            
            
            // Handle reset
            if (~rst_n) begin
                counter_SS_n = 0;
                MOSI_arr_index = 0;
                SS_n = 1;       // why it should be zero when reset is asserted?
                tx_valid = 0;
                f_read_data = 0;
                f_read_addr = 0;
                MOSI = 0;       // why it should be zero when reset is asserted?
                return;
            end
            
            // Constraint 2: SS_n control based on counter  
            // Check command type first to determine cycle count
            cmd = {MOSI_arr[0], MOSI_arr[1], MOSI_arr[2]};
            
            // Update flags based on command
            if (cmd == `READ_ADDR_ins) begin
                f_read_addr = 1;
                f_read_data = 0;
            end
            else if (cmd == `READ_DATA_ins && f_read_addr) begin
                f_read_addr = 0;
                f_read_data = 1;
            end
            else if (cmd == `WRITE_ADDR_ins || cmd == `WRITE_DATA_ins) begin
                f_read_addr = 0;
                f_read_data = 0;
            end
            // SS_n generation: high for 1 cycle every 13 cycles (normal) or 23 cycles (read data)
            if (f_read_data) begin
                // Read data case: 23 cycles total (22 low, 1 high)
                if (counter_SS_n >= 22) begin
                    MOSI_arr.rand_mode(1);
                    rst_n.rand_mode(1);
                    tx_data.rand_mode(1);
                    c_rst_n.constraint_mode(1);
                    SS_n = 1;
                    counter_SS_n = 0;
                    MOSI_arr_index = 0;
                end
                else begin
                    MOSI_arr.rand_mode(0);
                    rst_n.rand_mode(0);
                    tx_data.rand_mode(0);
                    c_rst_n.constraint_mode(0);

                    SS_n = 0;
                    counter_SS_n++;
                    MOSI_arr_index++;
                end
            end
            else begin
                // All other cases: 13 cycles total (12 low, 1 high)
                if (counter_SS_n >= 12) begin
                    MOSI_arr.rand_mode(1);
                    rst_n.rand_mode(1);
                    tx_data.rand_mode(1);
                    c_rst_n.constraint_mode(1);
                    SS_n = 1;
                    counter_SS_n = 0;
                    MOSI_arr_index = 0;
                end
                else begin
                    MOSI_arr.rand_mode(0);
                    rst_n.rand_mode(0);
                    tx_data.rand_mode(0);
                    c_rst_n.constraint_mode(0);
                    SS_n = 0;
                    counter_SS_n++;
                    MOSI_arr_index++;
                end
            end
            
            
            // Update MOSI from array
            if (MOSI_arr_index < 11)
                MOSI = MOSI_arr[MOSI_arr_index];
            else
                MOSI = 0;
            
            // Constraint 4: tx_valid is high only for read data
            tx_valid = f_read_data;
            
        endfunction

        function string convert2string();
            string s;
            string cmd_str;
            case ({MOSI_arr[0], MOSI_arr[1], MOSI_arr[2]})
                `WRITE_ADDR_ins: cmd_str = "WRITE_ADDR";
                `WRITE_DATA_ins: cmd_str = "WRITE_DATA";
                `READ_ADDR_ins:  cmd_str = "READ_ADDR";
                `READ_DATA_ins:  cmd_str = "READ_DATA";
                default: cmd_str = "UNKNOWN";
            endcase
            s = "\n----------- SLAVE Sequence Item -----------\n";
            s = {s, $sformatf("MOSI              : %0b\n", MOSI)};
            s = {s, $sformatf("rst_n             : %0b\n", rst_n)};
            s = {s, $sformatf("SS_n              : %0b\n", SS_n)};
            s = {s, $sformatf("tx_valid          : %0b\n", tx_valid)};
            s = {s, $sformatf("tx_data           : 0x%0h\n", tx_data)};
            s = {s, $sformatf("rx_data           : 0x%0h\n", rx_data)};
            s = {s, $sformatf("rx_data_golden    : 0x%0h\n", rx_data_gld)};
            s = {s, $sformatf("rx_valid          : %0b\n", rx_valid)};
            s = {s, $sformatf("rx_valid_golden   : %0b\n", rx_valid_gld)};
            s = {s, $sformatf("MISO              : %0b\n", MISO)};
            s = {s, $sformatf("MISO_golden       : %0b\n", MISO_gld)};
            s = {s, $sformatf("command           : %s\n", cmd_str)};
            s = {s, $sformatf("f_read_data       : %0b\n", f_read_data)};
            s = {s, $sformatf("f_read_addr       : %0b\n", f_read_addr)};
            s = {s, $sformatf("counter_SS_n      : %0d\n", counter_SS_n)};
            s = {s, $sformatf("MOSI_arr_index    : %0d\n", MOSI_arr_index)};
            s = {s, "---------------------------------------\n"};
            return s;
        endfunction
 

        function string convert2string_stimulus();
            string cmd_str;
            case ({MOSI_arr[0], MOSI_arr[1], MOSI_arr[2]})
                `WRITE_ADDR_ins: cmd_str = "WRITE_ADDR";
                `WRITE_DATA_ins: cmd_str = "WRITE_DATA";
                `READ_ADDR_ins:  cmd_str = "READ_ADDR";
                `READ_DATA_ins:  cmd_str = "READ_DATA";
                default: cmd_str = "UNKNOWN";
            endcase
            return $sformatf("@%0t: rst_n=%b MOSI=%b SS_n=%b tx_valid=%b tx_data=%0h cmd=%s f_read_data=%b f_read_addr=%b counter_SS_n=%0d MOSI_arr_index=%0d",
                            $time, rst_n, MOSI, SS_n, tx_valid, tx_data, cmd_str, f_read_data, f_read_addr, counter_SS_n, MOSI_arr_index);
        endfunction        
    endclass
endpackage
