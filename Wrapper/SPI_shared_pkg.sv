package SPI_shared_pkg ; 
    `define DEBUG
    typedef enum {IDLE,WRITE,CHK_CMD,READ_ADD,READ_DATA} state_e;     
    typedef enum {OP_WRITE_ADDR,OP_WRITE_DATA,OP_READ_ADDR,OP_READ_DATA} op_e;     
endpackage