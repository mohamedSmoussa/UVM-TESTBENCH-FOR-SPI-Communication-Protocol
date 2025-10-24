package wrapper_env_pkg;
import uvm_pkg::*;
import wrapper_agent_pkg::*;
import wrapper_scoreboard_pkg::*;
import wrapper_coverage_pkg::*;
`include "uvm_macros.svh"

class wrapper_env extends uvm_env;
`uvm_component_utils(wrapper_env)
wrapper_scoreboard sb;
wrapper_agent agt;
wrapper_coverage cov;

function new(string name="wrapper_env",uvm_component parent = null);
super.new(name,parent);
endfunction 

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  agt=wrapper_agent::type_id::create("agt",this);
  cov=wrapper_coverage::type_id::create("cov",this);
  sb=wrapper_scoreboard::type_id::create("sb",this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  agt.agt_ap.connect(sb.sb_export);
  agt.agt_ap.connect(cov.cov_export);
  endfunction 
endclass
endpackage
