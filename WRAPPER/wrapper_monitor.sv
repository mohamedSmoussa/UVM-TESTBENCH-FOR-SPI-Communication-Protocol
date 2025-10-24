package wrapper_monitor_pkg;
import wrapper_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class wrapper_monitor extends uvm_monitor;
`uvm_component_utils(wrapper_monitor)

virtual wrapper_if w_if;
virtual gold_wrapper_if gw_if; 
uvm_analysis_port#(wrapper_seq_item) mon_ap;
wrapper_seq_item rsp_seq_item;

function new(string name = "wrapper_monitor",uvm_component parent = null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
mon_ap=new("mon_ap",this);
endfunction : build_phase 

task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
 rsp_seq_item=wrapper_seq_item::type_id::create("rsp_seq_item");
 @(negedge w_if.clk);
 rsp_seq_item.rst_n = w_if.rst_n;
 rsp_seq_item.MOSI = w_if.MOSI;
 rsp_seq_item.MISO = w_if.MISO;
 rsp_seq_item.SS_n = w_if.SS_n;
 // gold 
 rsp_seq_item.MISO_ref=gw_if.MISO;
 mon_ap.write(rsp_seq_item);
 `uvm_info("run_phase",rsp_seq_item.convert2string(),UVM_HIGH);
end
endtask
endclass
endpackage


