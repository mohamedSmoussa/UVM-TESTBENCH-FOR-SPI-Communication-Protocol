module RAM_sva( input logic clk,
    input logic rst_n,
    input logic rx_valid,
    input logic [9:0] din,
    input logic [7:0] dout,
    input logic tx_valid );

 property reset_low_check ;
 (@(posedge clk) !rst_n |=> (tx_valid == 0 && dout == 0));
 endproperty
 property tx_valid_low;
 @(posedge clk) disable iff(!rst_n || !rx_valid)  (din[9:8] inside {2'b00, 2'b01, 2'b10}) && !tx_valid |=> (tx_valid == 0);
 endproperty
 property tx_valid_high;
@(posedge clk) disable iff(!rst_n || !rx_valid) (din[9:8] == 2'b11 && !$past(tx_valid)) |=> ($rose(tx_valid) ##1 $fell(tx_valid));
endproperty

property write_addr_followed_by_write_data;
 @(posedge clk) disable iff(!rst_n || !rx_valid ) ( din[9:8] == 2'b00) |-> ##1  ( din[9:8] == 2'b01)
endproperty
 property read_addr_followed_by_read_data ;
 @(posedge clk)  disable iff(!rst_n || !rx_valid) ( din[9:8] == 2'b10) |-> ##1 ( din[9:8] == 2'b11);
 endproperty
assert property (reset_low_check);
assert property (tx_valid_low);
assert property (tx_valid_high);
assert property ( write_addr_followed_by_write_data);
assert property (read_addr_followed_by_read_data);
cover property (reset_low_check);
cover property (tx_valid_low);
cover property (tx_valid_high);
cover property ( write_addr_followed_by_write_data);
cover property (read_addr_followed_by_read_data);
endmodule

    
