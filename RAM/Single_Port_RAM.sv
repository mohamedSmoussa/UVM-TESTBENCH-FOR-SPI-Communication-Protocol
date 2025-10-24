module Single_Port_RAM (din,rx_valid,clk,rst_n,dout,tx_valid);
parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8 ;
input [9:0] din;
input rx_valid,clk,rst_n ;
output reg [7:0] dout ;
output reg tx_valid;
bit [7:0] mem [MEM_DEPTH-1:0]; // memory
reg [ADDR_SIZE-1:0] wr_Addr,rd_Addr; //Separated two addresses for write and read operations
always @(posedge clk) begin
    if(~rst_n) begin 
        dout<=0;
        wr_Addr<=0;
        rd_Addr<=0;
        tx_valid<=0;
    end 
    else 
     if(rx_valid) begin 
    case(din[9:8])
    2'b00:  begin
         wr_Addr<=din[7:0];
         tx_valid<=0;
    end
    2'b01:  begin 
        mem[wr_Addr]<=din[7:0];
        tx_valid<=0;
    end
    2'b10:  begin
         rd_Addr<=din[7:0];
         tx_valid<=0;
    end
    2'b11: begin /// forced to  wait rx_data after 10 clk   
           dout<=mem[rd_Addr]; /// tx_data 
           tx_valid<=1;
           end 
    endcase
    end 
end
endmodule

