package spi_monitor_pkg;
import spi_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class spi_monitor extends uvm_monitor;
`uvm_component_utils(spi_monitor)

virtual spi_if spi_vif;
virtual spi_gold_if spi_gold_vif;
uvm_analysis_port#(spi_seq_item) mon_ap;
spi_seq_item rsp_seq_item;

function new(string name = "spi_monitor",uvm_component parent = null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
mon_ap=new("mon_ap",this);
endfunction : build_phase 

task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
 rsp_seq_item=spi_seq_item::type_id::create("rsp_seq_item");
 @(negedge spi_vif.clk);
 rsp_seq_item.rst_n = spi_vif.rst_n;
 rsp_seq_item.MOSI = spi_vif.MOSI;
 rsp_seq_item.MISO = spi_vif.MISO;
 rsp_seq_item.SS_n = spi_vif.SS_n;
 rsp_seq_item.rx_data = spi_vif.rx_data;
 rsp_seq_item.rx_valid = spi_vif.rx_valid;
 rsp_seq_item.tx_data = spi_vif.tx_data;
 rsp_seq_item.tx_valid = spi_vif.tx_valid;
 // gold 
 rsp_seq_item.rx_data_ref=spi_gold_vif.rx_data;
 rsp_seq_item.rx_valid_ref=spi_gold_vif.rx_valid;
 rsp_seq_item.MISO_ref=spi_gold_vif.MISO;
 mon_ap.write(rsp_seq_item);
 `uvm_info("run_phase",rsp_seq_item.convert2string(),UVM_HIGH);
end
endtask
endclass
endpackage


