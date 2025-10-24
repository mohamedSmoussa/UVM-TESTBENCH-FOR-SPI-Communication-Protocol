module RAM (din,clk,rst_n,rx_valid,dout,tx_valid);

input      [9:0] din;
input            clk, rst_n, rx_valid;

output reg [7:0] dout;
output reg       tx_valid;

bit [7:0] MEM [255:0];

reg [7:0] Rd_Addr, Wr_Addr;   
                      
always @(posedge clk) begin
    if (~rst_n) begin
        dout <= 0;
        tx_valid <= 0;
        Rd_Addr <= 0;
        Wr_Addr <= 0;
    end
    else                                   
        if (rx_valid) begin
            case (din[9:8])
                2'b00 : begin 
                     Wr_Addr <= din[7:0];
                end
                2'b01 : begin
                     MEM[Wr_Addr] <= din[7:0];
                end
                2'b10 : begin Rd_Addr <= din[7:0];
                end
                2'b11 : begin
                    dout <= MEM[Rd_Addr];
                end 
                default : dout <= 0;  // defualt case i will never reach it 
            endcase
            tx_valid<=(din[9:8]==2'b11)?1:0;
        end  
        
    end     

//// i added always block to handle cycles counter 
endmodule