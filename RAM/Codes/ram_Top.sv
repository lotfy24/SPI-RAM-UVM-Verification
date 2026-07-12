import uvm_pkg::*;
`include "uvm_macros.svh"
import ram_test_pkg::*;
module TOP();
// clk generation
bit clk;
initial begin
    clk=0;
    forever begin
        #1 clk = ~ clk;
    end
end
// instantations
ram_if r_if(clk);

RAM DUT (r_if.clk,r_if.rst_n,r_if.din,r_if.rx_valid,r_if.tx_valid,r_if.dout);

Single_port_SYNC_RAM GOLDEN (r_if.clk,r_if.rst_n,r_if.din,r_if.rx_valid,r_if.tx_valid_golden,r_if.dout_golden);
// Binding
bind RAM ram_SVA ram_assertions(r_if.clk,r_if.rst_n,r_if.din,r_if.rx_valid,r_if.tx_valid,r_if.dout);
// run test enviroment
initial begin
    uvm_config_db#(virtual ram_if)::set(null,"uvm_test_top","ram_if",r_if);
    run_test("ram_test");
end
endmodule