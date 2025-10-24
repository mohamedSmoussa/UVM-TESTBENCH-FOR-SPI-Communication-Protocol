package wrapper_shared;
   parameter  write_addr = 2'b00;
   parameter  write_data = 2'b01;
   parameter  read_addr  = 2'b10;
   parameter  read_data  = 2'b11;  
   typedef enum  {IDLE,CHK_CMD ,WRITE,READ_ADD , READ_DATA } state_e;
   state_e cs_s,ns_s;
   bit received_address;
   int  clk_count = 0;
   bit rx_valid;
   bit [9:0] rx_data;
   bit tx_valid;
endpackage