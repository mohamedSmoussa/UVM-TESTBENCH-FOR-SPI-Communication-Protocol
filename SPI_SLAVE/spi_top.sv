import spi_test_pkg::*;
import uvm_pkg::*;
import spi_shared::*;
  `include "uvm_macros.svh"

  module spi_top();
  bit clk;
 initial begin
    clk=0;
    forever begin
        #1 clk=~clk;
    end
 end

 spi_if spi_vif(clk);
 spi_gold_if gold_vif(clk);
 SLAVE DUT(spi_vif.MOSI,spi_vif.MISO,spi_vif.SS_n,spi_vif.clk,spi_vif.rst_n,spi_vif.rx_data,
          spi_vif.rx_valid,spi_vif.tx_data,spi_vif.tx_valid);

 SPI_Slave Golden(gold_vif.MOSI,gold_vif.SS_n,gold_vif.clk,gold_vif.rst_n,gold_vif.rx_data,gold_vif.tx_valid,gold_vif.tx_data,gold_vif.MISO,
 gold_vif.rx_valid);

bind SLAVE spi_sv sva_inst (
    .clk(spi_vif.clk),
    .rst_n(spi_vif.rst_n),
    .MISO(spi_vif.MISO),
    .rx_valid(spi_vif.rx_valid),
    .rx_data(spi_vif.rx_data)
);
assign cs_s = DUT.cs;
assign ns_s=DUT.ns;
assign received_address=DUT.received_address;
initial begin
    uvm_config_db #(virtual spi_if) :: set (null ,"uvm_test_top","spi_if",spi_vif);
    uvm_config_db #(virtual spi_gold_if) :: set (null , "uvm_test_top" , "spi_gold_if" , gold_vif);
    run_test("spi_test");
end
endmodule
