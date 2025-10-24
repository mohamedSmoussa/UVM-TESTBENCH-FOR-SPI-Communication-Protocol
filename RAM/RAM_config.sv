package RAM_config_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
class RAM_config extends uvm_object;
  `uvm_object_utils(RAM_config)

  virtual RAM_if RAM_vif;
  virtual Gold_RAM_if gold_RAM_vif;
  function new(string name = "RAM_config");
    super.new(name);
  endfunction
endclass
endpackage


