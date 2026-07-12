// module SLAVE (SPI_if.DUT SPIIF);
// import SPI_shared_pkg::*;
// // localparam IDLE      = 3'b000;
// // localparam WRITE     = 3'b001;
// // localparam CHK_CMD   = 3'b010;
// // localparam READ_ADD  = 3'b011;
// // localparam READ_DATA = 3'b100;

// // input            MOSI, clk, rst_n, SS_n, tx_valid;
// // input      [7:0] tx_data;
// // output reg [9:0] rx_data;
// // output reg       rx_valid, MISO;
// `define DEBUG
// reg [3:0] counter;
// reg       received_address;

// state_e  cs, ns;

// `ifdef DEBUG
//     op_e operation_sent ; 
// `endif

// always @(posedge SPIIF.clk) begin
//     if (~SPIIF.rst_n) begin
//         cs <= IDLE;
//     end
//     else begin
//         cs <= ns;
//     end
// end

// always @(*) begin
//     case (cs)
//         IDLE : begin
//             if (SPIIF.SS_n)
//                 ns = IDLE;
//             else
//                 ns = CHK_CMD;
//         end
//         CHK_CMD : begin
//             if (SPIIF.SS_n)
//                 ns = IDLE;
//             else begin
//                 if (~SPIIF.MOSI)
//                     ns = WRITE;
//                 else begin  // BUG 1 : READ_ADD && READ_DATA are exchanged
//                     if (received_address) 
//                         ns = READ_DATA; 
//                     else
//                         ns = READ_ADD;
//                 end
//             end
//         end
//         WRITE : begin
//             if (SPIIF.SS_n)
//                 ns = IDLE;
//             else
//                 ns = WRITE;
//         end
//         READ_ADD : begin
//             if (SPIIF.SS_n)
//                 ns = IDLE;
//             else
//                 ns = READ_ADD;
//         end
//         READ_DATA : begin
//             if (SPIIF.SS_n)
//                 ns = IDLE;
//             else
//                 ns = READ_DATA;
//         end
//     endcase
// end
// `ifdef DEBUG
//     always @(SPIIF.rx_data) begin
//         operation_sent = op_e'({SPIIF.rx_data[9],SPIIF.rx_data[8]});
//     end
// `endif
// //BUG2: reseting the internal counter !! 
// always @(posedge SPIIF.clk) begin
//     if (~SPIIF.rst_n) begin 
//         SPIIF.rx_data <= 0;
//         SPIIF.rx_valid <= 0;
//         received_address <= 0;
//         SPIIF.MISO <= 0;
//         counter <= 0 ;
//     end
//     else begin
//         case (cs)
//             IDLE : begin
//                 SPIIF.rx_valid <= 0;
//             end
//             CHK_CMD : begin
//                 counter <= 10;      
//             end
//             WRITE : begin
//                 if (counter > 0) begin
//                     SPIIF.rx_data[counter-1] <= SPIIF.MOSI;
//                     counter <= counter - 1;
//                 end
//                 else begin
//                     SPIIF.rx_valid <= 1;
//                 end
//             end
//             READ_ADD : begin
//                 if (counter > 0) begin
//                     SPIIF.rx_data[counter-1] <= SPIIF.MOSI;
//                     counter <= counter - 1;
//                 end
//                 else begin
//                     SPIIF.rx_valid <= 1;
//                     received_address <= 1;
//                 end
//             end
//             READ_DATA : begin
//                 if (SPIIF.tx_valid) begin
//                     SPIIF.rx_valid <= 0;
//                     if (counter > 0) begin
//                         SPIIF.MISO <= SPIIF.tx_data[counter-1];
//                         counter <= counter - 1;
//                     end
//                     else begin
//                         received_address <= 0;
//                     end
//                 end
//                 else begin
//                     if (counter > 0) begin
//                         SPIIF.rx_data[counter-1] <= SPIIF.MOSI;
//                         counter <= counter - 1;
//                     end
//                     else begin
//                         SPIIF.rx_valid <= 1;
//                         counter <= 8;
//                     end
//                 end
//             end
//         endcase
//     end
// end

// endmodule

module SLAVE (SPI_if.DUT SPIIF);
import SPI_shared_pkg::*;

reg [3:0] counter;
reg       received_address;

state_e  cs, ns;

`ifdef DEBUG
    op_e operation_sent ; 
`endif

always @(posedge SPIIF.clk) begin
    if (~SPIIF.rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (SPIIF.SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (SPIIF.SS_n)
                ns = IDLE;
            else begin
                if (~SPIIF.MOSI)
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
            if (SPIIF.SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (SPIIF.SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (SPIIF.SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
    endcase
end
`ifdef DEBUG
    always @(SPIIF.rx_data) begin
        operation_sent = {SPIIF.rx_data[9],SPIIF.rx_data[8]}
    end
`endif
//BUG2: reseting the internal counter !! 
always @(posedge SPIIF.clk) begin
    if (~SPIIF.rst_n) begin 
        SPIIF.rx_data <= 0;
        SPIIF.rx_valid <= 0;
        received_address <= 0;
        SPIIF.MISO <= 0;
        counter <= 0 ;
    end
    else begin
        case (cs)
            IDLE : begin
                SPIIF.rx_valid <= 0;
            end
            CHK_CMD : begin
                counter <= 10;      
            end
            WRITE : begin
                if (counter > 0) begin
                    SPIIF.rx_data[counter-1] <= SPIIF.MOSI;
                    counter <= counter - 1;
                    SPIIF.rx_valid <= 0;
                end
                else begin
                    SPIIF.rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    SPIIF.rx_data[counter-1] <= SPIIF.MOSI;
                    counter <= counter - 1;
                    SPIIF.rx_valid <= 0;
                    //////////
                    received_address <= 0;
                end
                else begin
                    SPIIF.rx_valid <= 1;
                    received_address <= 1;
                end
            end
            READ_DATA : begin
                if (SPIIF.tx_valid) begin
                    SPIIF.rx_valid <= 0;
                    if (counter > 0) begin
                        SPIIF.MISO <= SPIIF.tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        
                        received_address <= 0;
                    end
                end
                else begin
                    if (counter > 0) begin
                        SPIIF.rx_data[counter-1] <= SPIIF.MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        SPIIF.rx_valid <= 1;
                        // Bug 3 Counter should be up to 9 counts 
                        counter <= 8;
                    end
                end
            end
        endcase
    end
end
`ifdef SIM
    // IDLE → CHK_CMD
    property a0;
    disable iff (!SPIIF.rst_n)
    (@(posedge SPIIF.clk) (cs == IDLE && (SPIIF.SS_n == 1'b0)) |=> (cs == CHK_CMD)); 
    endproperty
    IDLE_CHK_CMD: assert property(a0);
    cover property(a0);
    // CHK_CMD → WRITE or READ_ADD or READ_DATA
    property a1;
    disable iff (!SPIIF.rst_n)
    (@(posedge SPIIF.clk) (cs == CHK_CMD && (SPIIF.SS_n == 1'b0)) |=> ((cs == WRITE) || (cs == READ_ADD) || ((cs == READ_DATA)))); 
    endproperty
    CHK_CMD_W_WA_RD: assert property(a1);
    cover property(a1);
    // WRITE → IDLE
    property a2;
    disable iff (!SPIIF.rst_n)
    (@(posedge SPIIF.clk) (cs == WRITE && (SPIIF.SS_n == 1'b1)) |=> (cs == IDLE)); 
    endproperty
    WRITE_IDLE: assert property(a2);
    cover property(a2);
    // READ_ADD → IDLE
    property a3;
    disable iff (!SPIIF.rst_n)
    (@(posedge SPIIF.clk) (cs == READ_ADD && (SPIIF.SS_n == 1'b1)) |=> (cs == IDLE)); 
    endproperty
    READ_ADD_IDLE: assert property(a3);
    cover property(a3);
    // READ_DATA → IDLE
    property a4;
    disable iff (!SPIIF.rst_n)
    (@(posedge SPIIF.clk) (cs == READ_DATA && (SPIIF.SS_n == 1'b1)) |=> (cs == IDLE)); 
    endproperty
    READ_DATA_IDLE: assert property(a4);
    cover property(a4);
`endif

endmodule