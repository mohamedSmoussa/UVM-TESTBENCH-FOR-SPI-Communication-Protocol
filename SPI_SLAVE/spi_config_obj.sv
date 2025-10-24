package spi_config_obj; 
import uvm_pkg::*;
`include "uvm_macros.svh"
class spi_config extends uvm_object;
`uvm_object_utils(spi_config)
virtual spi_if spi_config_vif;
virtual spi_gold_if spi_gold_config_vif;
function new(string name="spi_config");
super.new(name);
endfunction
endclass 
endpackage 