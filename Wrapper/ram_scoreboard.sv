// package ram_scoreboard_pkg;
// import uvm_pkg::*;
// import shared_pkg::*;
// import ram_sequence_item_pkg::*;
// `include "uvm_macros.svh"
// int correct_count,error_count;
// class ram_scoreboard extends uvm_scoreboard;
//  // register ram_monitor class in the factory
// `uvm_component_utils(ram_scoreboard)

// uvm_analysis_export #(ram_sequence_item) sb_export;
// uvm_tlm_analysis_fifo #(ram_sequence_item) sb_fifo;
// ram_sequence_item seq_item_sb;

// //logic [7:0] dout_ref;
// //logic tx_valid_ref;
// //logic [7:0] Rd_Addr_ref, Wr_Addr_ref;
// //logic [7:0] MEM_ref [255:0];

// function new(string name = "ram_scoreboard", uvm_component parent = null);
//     super.new(name,parent);
// endfunction

// function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     sb_export = new("sb_export",this);
//     sb_fifo = new("sb_fifo",this);
// endfunction

// function void connect_phase(uvm_phase phase);
//     super.build_phase(phase);
//     sb_export.connect(sb_fifo.analysis_export);
// endfunction

// task run_phase(uvm_phase phase);
//     super.run_phase(phase);
//     forever begin
//         sb_fifo.get(seq_item_sb);
//         //ref_model(seq_item_sb);

//         if((seq_item_sb.dout !== seq_item_sb.dout_golden) || (seq_item_sb.tx_valid !== seq_item_sb.tx_valid_golden))begin
//             `uvm_error("run_phase",$sformatf("comparison failed,transaction recived by the dut:%s
//                         while the dout_golden:%d and tx_valid_golden:%b",
//                         seq_item_sb.convert2string(),seq_item_sb.dout_golden,seq_item_sb.tx_valid_golden));
//             error_count = error_count + 1;
//         end
//         else begin
//             `uvm_info("run_phase",$sformatf("correct output :%s",seq_item_sb.convert2string()),UVM_HIGH);
//             correct_count = correct_count +1;
//         end
//     end
// endtask
//  function void report_phase(uvm_phase phase);
//             super.report_phase(phase);
//             `uvm_info("report_phase", $sformatf("correct_count = %d", correct_count), UVM_LOW);
//             `uvm_info("report_phase", $sformatf("error_count = %d", error_count), UVM_LOW);
// endfunction
// // reference model task
// /*task ref_model(ram_sequence_item check_item);
//     if(!check_item.rst_n)begin
//         dout_ref         = 0;
//         tx_valid_ref     = 0;
//         Rd_Addr_ref      = 0;
//         Wr_Addr_ref      = 0;
//     end
//     else begin
//         if(check_item.rx_valid)begin
//           case (check_item.din[9:8])
//             2'b00:begin
//                 Wr_Addr_ref          = check_item.din[7:0];
//                 tx_valid_ref = 0;
//             end 
//             2'b01:begin
//                 MEM_ref[Wr_Addr_ref] = check_item.din[7:0];
//                 tx_valid_ref = 0;
//             end 
//             2'b10:begin
//                 Rd_Addr_ref          = check_item.din[7:0];
//                 tx_valid_ref = 0;
//             end 
//             2'b11:begin
//                    dout_ref     = MEM_ref[Rd_Addr_ref];
//                    tx_valid_ref = 1;
//             end
//             default: dout_ref =0;
//          endcase
//         end 
//     end
// endtask*/
// endclass 
// endpackage