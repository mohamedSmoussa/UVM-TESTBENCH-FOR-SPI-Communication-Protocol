package spi_shared;
typedef enum  {IDLE,CHK_CMD ,WRITE,READ_ADD , READ_DATA } state_e;
 state_e cs_s,ns_s;
 bit received_address;
endpackage