package wrapper_driver_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
import wrapper_seq_item_pkg::*;
class wrapper_driver extends uvm_driver #(wrapper_seq_item);
`uvm_component_utils(wrapper_driver)
wrapper_seq_item stim_seq_item;
virtual wrapper_if w_if;
virtual gold_wrapper_if gw_if;


function new(string name = "wrapper_driver",uvm_component parent =null);
super.new(name,parent);
endfunction

task run_phase (uvm_phase phase);
 super.run_phase(phase);
 forever begin 
 stim_seq_item=wrapper_seq_item::type_id::create("stim_seq_item");
 seq_item_port.get_next_item(stim_seq_item);
 w_if.MOSI = stim_seq_item.MOSI;
 w_if.SS_n = stim_seq_item.SS_n;
 w_if.rst_n = stim_seq_item.rst_n;
 //for gold
 gw_if.MOSI = stim_seq_item.MOSI;
 gw_if.SS_n = stim_seq_item.SS_n;
 gw_if.rst_n = stim_seq_item.rst_n;
 @(negedge w_if.clk); 
 seq_item_port.item_done();
 `uvm_info("run_phase",stim_seq_item.convert2string_stimulus(),UVM_HIGH);
 end
 endtask
 endclass 
 endpackage