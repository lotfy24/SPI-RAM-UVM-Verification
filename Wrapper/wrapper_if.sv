interface wrapper_if(input clk);

    // Input signals to DUT
    logic MOSI, SS_n, rst_n;

    // Output signals from DUT
    logic MISO;
    logic MISO_gld;

    // DUT modport (how DUT sees directions)
    modport Wrapper_dut (
        input  MOSI, SS_n, rst_n, clk,
        output MISO
    );
    modport Wrapper_gld (
        input  MOSI, SS_n, rst_n, clk,
        output MISO_gld
    );
    modport wrapper_sva (
        input  clk, rst_n, MISO, SS_n
    );
endinterface
