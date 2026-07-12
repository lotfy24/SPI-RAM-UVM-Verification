module SLAVE (
    input            MOSI, clk, rst_n, SS_n, tx_valid,
    input      [7:0] tx_data,
    output reg [9:0] rx_data,
    output reg       rx_valid, MISO
);
import shared_pkg::*;

reg [3:0] counter;
reg       received_address;

state_e  cs, ns;

`ifdef DEBUG
    op_e operation_sent ; 
`endif

always @(posedge clk) begin
    if (~rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (SS_n)
                ns = IDLE;
            else begin
                if (~MOSI)
                    ns = WRITE;
                else begin  // BUG 1 : READ_ADD && READ_DATA are exchanged
                    if (received_address) 
                        ns = READ_DATA; 
                    else
                        ns = READ_ADD;
                end
            end
        end
        WRITE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = WRITE;
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
`ifdef DEBUG
    always @(rx_data) begin
        operation_sent = {rx_data[9],rx_data[8]}
    end
`endif
//BUG2: reseting the internal counter !! 
always @(posedge clk) begin
    if (~rst_n) begin 
        rx_data <= 0;
        rx_valid <= 0;
        received_address <= 0;
        MISO <= 0;
        //counter <= 0 ;    bug 
    end
    else begin
        case (cs)
            IDLE : begin
                rx_valid <= 0;
            end
            CHK_CMD : begin
                counter <= 10;      
            end
            WRITE : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                    rx_valid <= 0;
                end
                else begin
                    rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                    rx_valid <= 0;
                    //////////
                    received_address <= 0;
                end
                else begin
                    rx_valid <= 1;
                    received_address <= 1;
                end
            end
            READ_DATA : begin
                if (tx_valid) begin
                    rx_valid <= 0;
                    if (counter > 0) begin
                        MISO <= tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        
                        received_address <= 0;
                    end
                end
                else begin
                    if (counter > 0) begin
                        rx_data[counter-1] <= MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        rx_valid <= 1;
                        //BUG3 : counter should count up top 9 cycles 
                        counter <= 9;
                    end
                end
            end
        endcase
    end
end
`ifdef SIM
    // IDLE → CHK_CMD
    property a0;
    disable iff (!rst_n)
    (@(posedge clk) (cs == IDLE && (SS_n == 1'b0)) |=> (cs == CHK_CMD)); 
    endproperty
    IDLE_CHK_CMD: assert property(a0);
    cover property(a0);
    // CHK_CMD → WRITE or READ_ADD or READ_DATA
    property a1;
    disable iff (!rst_n)
    (@(posedge clk) (cs == CHK_CMD && (SS_n == 1'b0)) |=> ((cs == WRITE) || (cs == READ_ADD) || ((cs == READ_DATA)))); 
    endproperty
    CHK_CMD_W_WA_RD: assert property(a1);
    cover property(a1);
    // WRITE → IDLE
    property a2;
    disable iff (!rst_n)
    (@(posedge clk) (cs == WRITE && (SS_n == 1'b1)) |=> (cs == IDLE)); 
    endproperty
    WRITE_IDLE: assert property(a2);
    cover property(a2);
    // READ_ADD → IDLE
    property a3;
    disable iff (!rst_n)
    (@(posedge clk) (cs == READ_ADD && (SS_n == 1'b1)) |=> (cs == IDLE)); 
    endproperty
    READ_ADD_IDLE: assert property(a3);
    cover property(a3);
    // READ_DATA → IDLE
    property a4;
    disable iff (!rst_n)
    (@(posedge clk) (cs == READ_DATA && (SS_n == 1'b1)) |=> (cs == IDLE)); 
    endproperty
    READ_DATA_IDLE: assert property(a4);
    cover property(a4);
`endif

endmodule