package wrapper_config_obj; 
import uvm_pkg::*;
`include "uvm_macros.svh"
class wrapper_config extends uvm_object;
`uvm_object_utils(wrapper_config)
virtual wrapper_if wrapper_config_vif;
virtual gold_wrapper_if wrapper_gold_config_vif;
uvm_active_passive_enum is_active;
function new(string name="wrapper_config");
super.new(name);
endfunction
endclass 
endpackage 