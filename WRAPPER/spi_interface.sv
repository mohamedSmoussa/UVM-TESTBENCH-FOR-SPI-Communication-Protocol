interface spi_if(clk);
localparam IDLE      = 3'b000;
localparam CHK_CMD   = 3'b001;
localparam WRITE     = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;
input  clk;
logic rst_n;
logic MISO;
logic MOSI;
logic SS_n;
logic tx_valid;
logic [7:0] tx_data;
logic [9:0] rx_data;
bit rx_valid;
endinterface