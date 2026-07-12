package wrapper_seq_item_pkg;
import uvm_pkg     ::*;
import shared_pkg  ::*;
`include "uvm_macros.svh"

    class wrapper_sequence_item extends uvm_sequence_item ;
        `uvm_object_utils(wrapper_sequence_item)

        rand bit        rst_n   ;
        rand bit [10:0] MOSI_arr;
        
        // Non-randomized signals
        bit SS_n      ;
        logic MOSI    ;
        logic MISO    ;   
        logic MISO_gld;
        
        // Control variables
        int counter_SS_n  ;
        bit f_read_data   ; 
        bit f_read_addr   ; 
        int MOSI_arr_index;
        
        // Store previous command for constraints
        operation_e prev_cmd;
        
        function new(string name = "wrapper_sequence_item");
            super.new(name);
            counter_SS_n   = 0;
            MOSI_arr_index = 0;
            SS_n           = 1;
            f_read_data    = 0;
            f_read_addr    = 0;
            prev_cmd       = WRITE_ADDR_seq;  // Initial value
        endfunction

        operation_e cmd;
        int operation_flag;
    
        // Constraint 1: Reset deasserted most of the time (90%)
        constraint c_rst_n {
            rst_n dist {0:/10, 1:/90};
        }

        // Constraint for proper command sequencing
        constraint seq{
            // Write-only mode
            if(operation_flag == 0)
            {
                if (prev_cmd == WRITE_ADDR_seq){
                    MOSI_arr[2:0] inside {WRITE_ADDR_seq, WRITE_DATA_seq};
                }
                else if (prev_cmd == WRITE_DATA_seq){
                    MOSI_arr[2:0] == WRITE_ADDR_seq;
                }
            }
            // Read-only mode
            else if(operation_flag == 1)
            {
                if (prev_cmd == READ_ADDR_seq){
                    MOSI_arr[2:0] == READ_DATA_seq;
                }
                else if (prev_cmd == READ_DATA_seq){
                    MOSI_arr[2:0] == READ_ADDR_seq;
                }
            }
            // Mixed read/write mode
            else
            {
                if (prev_cmd == WRITE_ADDR_seq){
                    MOSI_arr[2:0] inside {WRITE_ADDR_seq, WRITE_DATA_seq};
                }
                else if (prev_cmd == WRITE_DATA_seq){
                    MOSI_arr[2:0] dist {READ_ADDR_seq:/60, WRITE_ADDR_seq:/40};
                }
                else if (prev_cmd == READ_ADDR_seq){
                    MOSI_arr[2:0] == READ_DATA_seq;  // Must follow with READ_DATA
                }
                else if (prev_cmd == READ_DATA_seq){
                    MOSI_arr[2:0] dist {WRITE_ADDR_seq:/60, READ_ADDR_seq:/40};
                }   
            }    
        }

        // Post-randomize handles SS_n control and flag management
        function void post_randomize();
            // Extract current command from randomized MOSI_arr
            cmd = operation_e'({MOSI_arr[2], MOSI_arr[1], MOSI_arr[0]});
            
            // Update shared variables
            prev_operation = cmd;
            flag = operation_flag;
               
            // Handle reset
            if (~rst_n) begin
                counter_SS_n   = 0;
                MOSI_arr_index = 0;
                SS_n           = 1;       
                f_read_data    = 0;
                f_read_addr    = 0;
                MOSI           = 0;
                prev_cmd       = WRITE_ADDR_seq;       
                return;
            end
            
            // Determine if this is a READ_DATA following READ_ADDR
            if (prev_cmd == READ_ADDR_seq && cmd == READ_DATA_seq) begin
                f_read_data = 1;
                f_read_addr = 0;
            end
            else begin
                f_read_data = 0;
                // Set f_read_addr if current command is READ_ADDR
                if (cmd == READ_ADDR_seq) begin
                    f_read_addr = 1;
                end
                else begin
                    f_read_addr = 0;
                end
            end
            
            // SS_n generation logic
            if (f_read_data) begin
                // READ_DATA case: 23 cycles total (22 low, 1 high)
                if (counter_SS_n >= 22) begin
                    MOSI_arr.rand_mode(1);
                    rst_n.rand_mode(1);
                    seq.constraint_mode(1);
                    c_rst_n.constraint_mode(1);

                    SS_n           = 1;
                    counter_SS_n   = 0;
                    MOSI_arr_index = 0;
                    prev_cmd       = cmd;  // Update previous command for next cycle
                end
                else begin
                    MOSI_arr.rand_mode(0);
                    rst_n.rand_mode(0);
                    seq.constraint_mode(0);
                    c_rst_n.constraint_mode(0);

                    SS_n = 0;
                    counter_SS_n++;
                    MOSI_arr_index++;
                end
            end
            else begin
                // All other commands: 13 cycles total (12 low, 1 high)
                if (counter_SS_n >= 12) begin
                    MOSI_arr.rand_mode(1);
                    rst_n.rand_mode(1);
                    seq.constraint_mode(1);
                    c_rst_n.constraint_mode(1);

                    SS_n           = 1;
                    counter_SS_n   = 0;
                    MOSI_arr_index = 0;
                    prev_cmd       = cmd;  // Update previous command for next cycle
                end
                else begin
                    MOSI_arr.rand_mode(0);
                    rst_n.rand_mode(0);
                    seq.constraint_mode(0);
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
            
            // Update shared variables
            counter_SS_N_SHARED = counter_SS_n;
            f_read_addr_shared  = f_read_addr;
            f_read_data_shared  = f_read_data;
            cmd_shared          = cmd;
        endfunction

        function string convert2string();
            string s;
            string cmd_str;
            case ({MOSI_arr[2], MOSI_arr[1], MOSI_arr[0]})
                WRITE_ADDR_seq: cmd_str = "WRITE_ADDR";
                WRITE_DATA_seq: cmd_str = "WRITE_DATA";
                READ_ADDR_seq : cmd_str = "READ_ADDR";
                READ_DATA_seq : cmd_str = "READ_DATA";
                default: cmd_str = "UNKNOWN";
            endcase
            s = "\n----------- SLAVE Sequence Item -----------\n";
            s = {s, $sformatf("MOSI              : %0b\n", MOSI)};
            s = {s, $sformatf("rst_n             : %0b\n", rst_n)};
            s = {s, $sformatf("SS_n              : %0b\n", SS_n)};
            s = {s, $sformatf("MISO              : %0b\n", MISO)};
            s = {s, $sformatf("MISO_golden       : %0b\n", MISO_gld)};
            s = {s, $sformatf("command           : %s\n" , cmd_str)};
            s = {s, $sformatf("prev_cmd          : %s\n" , prev_cmd.name())};
            s = {s, $sformatf("f_read_data       : %0b\n", f_read_data)};
            s = {s, $sformatf("f_read_addr       : %0b\n", f_read_addr)};
            s = {s, $sformatf("counter_SS_n      : %0d\n", counter_SS_n)};
            s = {s, $sformatf("MOSI_arr_index    : %0d\n", MOSI_arr_index)};
            s = {s, "---------------------------------------\n"};
            return s;
        endfunction
 

        function string convert2string_stimlus();
            string cmd_str;
            case ({MOSI_arr[2], MOSI_arr[1], MOSI_arr[0]})
                WRITE_ADDR_seq: cmd_str = "WRITE_ADDR";
                WRITE_DATA_seq: cmd_str = "WRITE_DATA";
                READ_ADDR_seq : cmd_str = "READ_ADDR";
                READ_DATA_seq : cmd_str = "READ_DATA";
                default: cmd_str = "UNKNOWN";
            endcase
            return $sformatf("@%0t: rst_n=%b MOSI=%b SS_n=%b cmd=%s prev_cmd=%s f_read_data=%b f_read_addr=%b counter_SS_n=%0d MOSI_arr_index=%0d",
                            $time, rst_n, MOSI, SS_n, cmd_str, prev_cmd.name(), f_read_data, f_read_addr, counter_SS_n, MOSI_arr_index);
        endfunction    
    
    endclass
    
endpackage