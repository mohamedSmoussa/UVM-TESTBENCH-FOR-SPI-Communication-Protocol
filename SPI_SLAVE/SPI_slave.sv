module SLAVE (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

localparam IDLE      = 3'b000;
localparam CHK_CMD   = 3'b001;
localparam WRITE     = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;

input            MOSI, clk, rst_n, SS_n, tx_valid;
input      [7:0] tx_data;
output reg [9:0] rx_data;
output reg       rx_valid;
output reg MISO;

reg [3:0] counter;
reg       received_address;

reg [2:0] cs, ns;

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
                else begin
                    if (received_address) 
                        ns = READ_DATA; 
                    else
                        ns = READ_ADD; /// edit 1 replace with another
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

always @(posedge clk) begin
    if (~rst_n) begin 
        rx_data <= 0;
        rx_valid <= 0;
        counter<=0; // counter
        received_address <= 0;
        MISO <= 0;
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
                end
                else begin
                    rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                    received_address <= 1;
                end
            end
            READ_DATA : begin
                if (tx_valid) begin
                    rx_valid<=0;
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
                        rx_valid<=0;
                    end
                    else begin
                        rx_valid <= 1;
                        counter <= 9;
                    end
                end
            end
        endcase
    end
end
`ifdef SIM
 property p_IDLE_to_CHK_CMD;
     @(posedge spi_vif.clk) disable iff (!spi_vif.rst_n)
     (cs == IDLE && spi_vif.SS_n == 1'b0) |=> (cs == CHK_CMD);
 endproperty    
 
 property p_CHK_CMD_to_WRITE;
     @(posedge spi_vif.clk) disable iff (!spi_vif.rst_n)
     (cs == CHK_CMD && spi_vif.MOSI == 1'b0 && spi_vif.SS_n == 1'b0) |=> (cs == WRITE);
 endproperty
 property p_CHK_CMD_to_READ_ADD;
     @(posedge spi_vif.clk) disable iff (!spi_vif.rst_n)
     (cs == CHK_CMD && spi_vif.MOSI == 1'b1 && received_address == 1'b0 && spi_vif.SS_n == 1'b0)
     |=> (cs == READ_ADD);
 endproperty
 
 property p_CHK_CMD_to_READ_DATA;
     @(posedge spi_vif.clk) disable iff (!spi_vif.rst_n)
     (cs == CHK_CMD && spi_vif.MOSI == 1'b1 && received_address == 1'b1 && spi_vif.SS_n == 1'b0)
     |=> (cs == READ_DATA);
 endproperty
 property p_WRITE_to_IDLE;
     @(posedge spi_vif.clk) disable iff (!spi_vif.rst_n)
     (cs == WRITE && spi_vif.SS_n == 1'b1) |=> (cs == IDLE);
 endproperty
 
 property p_READ_ADD_to_IDLE;
     @(posedge spi_vif.clk) disable iff (!spi_vif.rst_n)
     (cs == READ_ADD && spi_vif.SS_n == 1'b1) |=> (cs == IDLE);
 endproperty
 property p_READ_DATA_to_IDLE;
     @(posedge spi_vif.clk)
     disable iff (!spi_vif.rst_n) (cs == READ_DATA && spi_vif.SS_n == 1'b1) |=> (cs == IDLE);
 endproperty
 property p_counter_decrement;
     @(posedge spi_vif.clk) disable iff (!spi_vif.rst_n)
     ((cs == WRITE || cs == READ_ADD|| cs==READ_DATA) && counter > 0)
     |=> (counter == $past(counter) - 1);
 endproperty
 
 assert property (p_IDLE_to_CHK_CMD);
 assert property (p_CHK_CMD_to_WRITE);
 assert property (p_CHK_CMD_to_READ_ADD);
 assert property (p_CHK_CMD_to_READ_DATA);
 assert property (p_WRITE_to_IDLE);
 assert property (p_READ_ADD_to_IDLE);
 assert property (p_READ_DATA_to_IDLE);
 assert property (p_counter_decrement);
 cover property (p_IDLE_to_CHK_CMD);
 cover property (p_CHK_CMD_to_WRITE);
 cover property (p_CHK_CMD_to_READ_ADD);
 cover property (p_CHK_CMD_to_READ_DATA);
 cover property (p_WRITE_to_IDLE);
 cover property (p_READ_ADD_to_IDLE);
 cover property (p_READ_DATA_to_IDLE);
 cover property (p_counter_decrement);
`endif

endmodule