package spi_test_pkg;
import uvm_pkg::*;
import spi_env_pkg::*;
import spi_config_obj::*;
import sequences::*;
`include "uvm_macros.svh"
class spi_test extends uvm_test;
`uvm_component_utils(spi_test)
spi_env env;
spi_config spi_cfg;
spi_config spi_gold_cfg;
main_sequence spi_main_seq;
reset_sequence spi_reset_seq;

function new(string name="spi_test",uvm_component parent = null);
super.new (name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
env =spi_env::type_id::create("env",this);
spi_main_seq =main_sequence::type_id::create("spi_main_seq",this);
spi_reset_seq= reset_sequence::type_id::create("spi_reset_seq",this);
spi_cfg =spi_config::type_id::create("spi_cfg");
spi_gold_cfg = spi_config::type_id::create("spi_gold_cfg");
if (!uvm_config_db#(virtual spi_if)::get(this,"","spi_if",spi_cfg.spi_config_vif))begin
    `uvm_fatal("build_phase","test - unable to get VIF")
end
if (!uvm_config_db#(virtual spi_gold_if)::get(this,"","spi_gold_if",spi_gold_cfg.spi_gold_config_vif))begin
    `uvm_fatal("build_phase","test - unable to get gold VIF")
end
 uvm_config_db #(spi_config)::set(this,"*","CFG",spi_cfg); /// change from get to set 
 uvm_config_db #(spi_config)::set(this,"*","CFG_GOLD",spi_gold_cfg);
endfunction 

task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);
 `uvm_info("run_phase","reset asserted",UVM_LOW);
spi_reset_seq.start(env.agt.sqr);
`uvm_info("run_phase","reset de asserted ",UVM_LOW);
spi_main_seq.start(env.agt.sqr);
`uvm_info("run_phase","main_sequence started",UVM_LOW);
phase.drop_objection(this);
`uvm_info("run_phase","main sequence finished",UVM_LOW);
endtask:run_phase 
endclass
endpackage









