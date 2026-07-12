module SPI_gld (
    input MOSI, clk, rst_n, SS_n, tx_valid,
    input [7:0] tx_data,
    output reg [9:0] rx_data_gld,
    output reg rx_valid_gld, MISO_gld
);
import shared_pkg::*;

// localparam IDLE      = 3'b000;
// localparam WRITE     = 3'b001;
// localparam CHK_CMD   = 3'b010;
// localparam READ_ADD  = 3'b011;
// localparam READ_DATA = 3'b100;


reg [3:0] counter;
reg Recieved_address;

state_e  cs, ns;

// State Memory
always @(posedge clk) begin
    if (~rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

// Next State Logic
always @(*) begin
    case (cs)
        IDLE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        WRITE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        CHK_CMD : begin
            if (SS_n)
                ns = IDLE;
            else begin
                if (~MOSI)
                    ns = WRITE;
                else begin
                    if (Recieved_address)
                        ns = READ_DATA;
                    else
                        ns = READ_ADD;
                end
            end
        end
        READ_ADD : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
    endcase
end

// Ouput Logic
always @(posedge clk) begin
    if (~rst_n) begin
        rx_data_gld <= 0;
        rx_valid_gld <= 0;
        Recieved_address <= 0;
        MISO_gld <= 0;
        counter <= 0;
    end
    else begin
        case (cs)
            IDLE : begin
                rx_valid_gld <= 0;
            end
            CHK_CMD : begin
                counter <= 10;
            end
            WRITE : begin
                // Data is Ready to be Sent
                if (counter > 0) begin
                    rx_data_gld[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid_gld <= 1;
                end
            end
            READ_ADD : begin
                // Send Read Address
                if (counter > 0) begin
                    rx_data_gld[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid_gld <= 1;
                    // Next Time a Read Command will be Sent
                    Recieved_address <= 1;
                end
            end
            READ_DATA : begin
                if (tx_valid) begin
                    rx_valid_gld <= 0;
                    // Read Data
                    if (counter == 0)
                        Recieved_address <= 0;
                    else begin
                        MISO_gld <= tx_data[counter-1];
                        counter <= counter - 1;
                    end
                end
                // Ask to read the Data
                else begin
                    // Send Data Read Request to RAM
                    if (counter > 0) begin
                        rx_data_gld[counter-1] <= MOSI;
                        counter <= counter - 1;
                    end
                    // Read the Data From the RAM
                    else begin
                        rx_valid_gld <= 1;
                        counter <= 9;
                    end
                end
            end
        endcase
    end
end

endmodule