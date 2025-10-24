module GOLDEN_WRAPPER (MOSI,MISO,SS_n,clk,rst_n);
input  MOSI, SS_n, clk, rst_n;
output MISO;
wire [9:0] rx_data;
wire       rx_valid;
wire       tx_valid;
wire [7:0] tx_data;

Single_Port_RAM RRM(rx_data,rx_valid,clk,rst_n,tx_data,tx_valid);
SPI_Slave SSV(MOSI,SS_n,clk,rst_n,rx_data,tx_valid,tx_data,MISO,rx_valid);
endmodule