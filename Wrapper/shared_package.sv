package shared_pkg;
//ram_shared_pkg
    parameter ADDR_SIZE = 8;
    parameter MEM_DEPTH = 256;

    //spi_shared_pkg
    `define DEBUG
    typedef enum {IDLE,WRITE,CHK_CMD,READ_ADD,READ_DATA} state_e;     
    typedef enum {OP_WRITE_ADDR,OP_WRITE_DATA,OP_READ_ADDR,OP_READ_DATA} op_e;
    //   sequence item 
    typedef enum  {WRITE_ADDR_seq =3'b000,WRITE_DATA_seq =3'b001,READ_ADDR_seq = 3'b110,READ_DATA_seq = 3'b111} operation_e;
    operation_e prev_operation;
     int flag;
     int counter_SS_N_SHARED;
     logic f_read_addr_shared , f_read_data_shared ; 
     bit [2:0] cmd_shared; 

endpackage