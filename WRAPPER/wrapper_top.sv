`include "uvm_macros.svh"
import uvm_pkg::*;
module wrapper_top;
import wrapper_test_pkg::*;
import wrapper_shared::*;
bit clk;
initial begin
    clk=0;
    forever #1 clk=~clk;
end

wrapper_if w_if(clk);
gold_wrapper_if gw_if(clk);
spi_gold_if gold_vif(clk);
spi_if spi_vif(clk);
Gold_RAM_if gold_RAMif(clk);
RAM_if RAMif (clk);
WRAPPER DUT(w_if.MOSI,w_if.MISO,w_if.SS_n,w_if.clk,w_if.rst_n);
GOLDEN_WRAPPER Golden(gw_if.MOSI,gw_if.MISO,gw_if.SS_n,gw_if.clk,gw_if.rst_n);
/*logic rst_n;
logic rx_valid;
logic [9:0] din;
logic [7:0] dout;
logic tx_valid;*/

assign RAMif.rst_n=w_if.rst_n;
assign RAMif.rx_valid=DUT.rx_valid;
assign RAMif.din=DUT.rx_data_din;
assign RAMif.dout=DUT.tx_data_dout;
assign RAMif.tx_valid=DUT.tx_valid;

assign gold_RAMif.rst_n=gw_if.rst_n;
assign gold_RAMif.rx_valid=Golden.rx_valid;
assign gold_RAMif.din=Golden.rx_data;
assign gold_RAMif.dout=Golden.tx_data;
assign gold_RAMif.tx_valid=Golden.tx_valid;

/*logic rst_n;
logic MISO;
logic MOSI;
logic SS_n;
logic tx_valid;
logic [7:0] tx_data;
logic [9:0] rx_data;
bit rx_valid;*/

assign spi_vif.rst_n=w_if.rst_n;
assign spi_vif.MISO=w_if.MISO;
assign spi_vif.MOSI=w_if.MOSI;
assign spi_vif.SS_n=w_if.SS_n;
assign spi_vif.tx_valid=DUT.tx_valid;
assign spi_vif.tx_data=DUT.tx_data_dout;
assign spi_vif.rx_data=DUT.rx_data_din;
assign spi_vif.rx_valid=DUT.rx_valid;

assign gold_vif.rst_n=gw_if.rst_n;
assign gold_vif.MISO=gw_if.MISO;
assign gold_vif.MOSI=gw_if.MOSI;
assign gold_vif.SS_n=gw_if.SS_n;
assign gold_vif.tx_valid=Golden.tx_valid;
assign gold_vif.tx_data=Golden.tx_data;
assign gold_vif.rx_data=Golden.rx_data;
assign gold_vif.rx_valid=Golden.rx_valid;

assign cs_s=state_e'(DUT.SLAVE_instance.cs);
assign ns_s=state_e'(DUT.SLAVE_instance.ns);
assign received_address=DUT.SLAVE_instance.received_address;
assign rx_valid=DUT.rx_valid;
assign rx_data=DUT.rx_data_din;
assign tx_valid=DUT.tx_valid;

bind WRAPPER wrapper_sva sva_inst(.MISO(w_if.MISO),.MOSI(w_if.MOSI),.rst_n(w_if.rst_n),.clk(w_if.clk),.SS_n(w_if.SS_n));

initial begin
    uvm_config_db#(virtual spi_if) :: set (null ,"uvm_test_top","spi_if",spi_vif);
    uvm_config_db#(virtual spi_gold_if) :: set (null , "uvm_test_top" , "spi_gold_if" , gold_vif);
    uvm_config_db#(virtual RAM_if)::set(null, "uvm_test_top", "RAM_IF", RAMif);
    uvm_config_db#(virtual Gold_RAM_if)::set(null,"uvm_test_top","GOLD_RAM_IF",gold_RAMif);
    uvm_config_db#(virtual wrapper_if)::set(null, "uvm_test_top", "WRAPPER_IF", w_if);
    uvm_config_db#(virtual gold_wrapper_if)::set(null,"uvm_test_top","GOLD_WRAPPER_IF",gw_if);
    run_test("wrapper_test");
end
endmodule