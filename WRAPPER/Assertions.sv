import spi_shared::*;
module spi_sv (
    input logic clk,
    input logic rst_n,
    input logic MISO,
    input logic rx_valid,
    input logic [9:0] rx_data);

  property reset_low_outputs;
    @(posedge clk)
      (!rst_n) |=> (MISO == 1'b0 && rx_valid == 1'b0 && rx_data == 10'b0);
  endproperty
  assert property (reset_low_outputs);
  cover property  (reset_low_outputs);

property p_rxvalid;
        @(posedge spi_vif.clk) disable iff (!spi_vif.rst_n)
        (cs_s == CHK_CMD && ({ $past(spi_vif.MOSI,2), $past(spi_vif.MOSI,1), spi_vif.MOSI } inside {3'b000, 3'b001, 3'b110, 3'b111})
         && spi_vif.SS_n == 1'b0)  |=> ##10 (spi_vif.rx_valid && $rose(spi_vif.SS_n)[->1]);
endproperty  
assert property (p_rxvalid);
cover property (p_rxvalid);
endmodule
