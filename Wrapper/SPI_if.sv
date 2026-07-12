interface SPI_if (clk);
    input bit clk ; 
    logic MOSI, rst_n, SS_n, tx_valid;
    logic [7:0] tx_data;
    logic [9:0] rx_data , rx_data_gld;
    logic rx_valid, MISO;
    logic rx_valid_gld , MISO_gld ;
    modport DUT (
        input MOSI, clk, rst_n, SS_n, tx_valid,tx_data,
        output rx_data,rx_valid,MISO
    );
    modport gld (
        input MOSI, clk, rst_n, SS_n, tx_valid,tx_data,
        output rx_valid_gld,rx_data_gld,MISO_gld
    );
endinterface : SPI_if