package spi_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_seq_item_pkg::*;
import spi_config_obj::*;
import spi_driver::*;
import spi_sequencer_pkg::*;
import spi_monitor_pkg::*;
class spi_agent extends uvm_agent;
`uvm_component_utils(spi_agent)

spi_sequencer sqr;
spi_driver drv;
spi_monitor mon;
spi_config spi_cfg;
spi_config spi_gold_cfg;
uvm_analysis_port #(spi_seq_item) agt_ap;

function new(string name = "spi_agent",uvm_component parent = null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(spi_config)::get(this,"","S_CFG",spi_cfg))begin
`uvm_fatal("build_phase","unable to get CFG object")
end

if(!uvm_config_db #(spi_config)::get(this,"","S_CFG_GOLD",spi_gold_cfg))begin
`uvm_fatal("build_phase","unable to get CFG_GOLD object")
end
if (spi_cfg.is_active==UVM_ACTIVE) begin
sqr = spi_sequencer::type_id::create("sqr",this);
drv = spi_driver::type_id::create("drv",this);
end
mon = spi_monitor::type_id::create("mon",this);
agt_ap = new("agt_ap",this);
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
if(spi_cfg.is_active==UVM_ACTIVE) begin
drv.spi_vif = spi_cfg.spi_config_vif;
drv.spi_gold_vif = spi_gold_cfg.spi_gold_config_vif;
drv.seq_item_port.connect(sqr.seq_item_export);
end
mon.spi_vif = spi_cfg.spi_config_vif;
mon.spi_gold_vif = spi_gold_cfg.spi_gold_config_vif;
mon.mon_ap.connect(agt_ap);
endfunction
endclass
endpackage 

