package wrapper_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import wrapper_env_pkg::*;
import wrapper_config_obj::*;
import wrapper_sequences_pkg::*;
import RAM_config_pkg::*;
import spi_config_obj::*;
import spi_env_pkg::*;
import RAM_env_pkg::*;
class wrapper_test extends uvm_test;
    `uvm_component_utils(wrapper_test)

    wrapper_env wr_env;
    spi_env sp_env;
    RAM_env R_env;
    wrapper_config wrapper_cfg;
    wrapper_config wrapper_gold_cfg;
    RAM_config RAM_cfg;
    RAM_config RAM_gold_cfg;
    spi_config spi_cfg;
    spi_config spi_gold_cfg;
    ///////////////////////////////
    wrapper_write_sequence write_seq;
    wrapper_read_sequence read_seq;
    wrapper_read_write_sequence read_write_seq;
    wrapper_reset_sequence reset_seq;

    function new(string name = "wrapper_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        wr_env=wrapper_env::type_id::create("wr_env",this);
       sp_env =spi_env::type_id::create("sp_env",this);
       R_env = RAM_env::type_id::create("R_env", this);
      wrapper_cfg       = wrapper_config::type_id::create("wrapper_cfg");
      wrapper_gold_cfg  = wrapper_config::type_id::create("wrapper_gold_cfg");
      spi_cfg           = spi_config::type_id::create("spi_cfg");
      spi_gold_cfg      = spi_config::type_id::create("spi_gold_cfg");
      RAM_cfg           = RAM_config::type_id::create("RAM_cfg");
      RAM_gold_cfg      = RAM_config::type_id::create("RAM_gold_cfg");
      write_seq         = wrapper_write_sequence::type_id::create("write_seq",this);
      read_seq          = wrapper_read_sequence::type_id::create("read_seq",this);
      read_write_seq    = wrapper_read_write_sequence::type_id::create("read_write_seq",this);
      reset_seq         = wrapper_reset_sequence::type_id::create("reset_seq",this);
        if (!uvm_config_db #(virtual wrapper_if)::get(this, "", "WRAPPER_IF", wrapper_cfg.wrapper_config_vif))
            `uvm_fatal("build_phase", "Test - Unable to get the virtual interface of the wrap from the uvm_config_db");
            if (!uvm_config_db #(virtual gold_wrapper_if)::get(this, "", "GOLD_WRAPPER_IF",wrapper_gold_cfg.wrapper_gold_config_vif))
           `uvm_fatal("build_phase", "Test - Unable to get the virtual interface of the wrap from the uvm_config_db");
        if (!uvm_config_db#(virtual spi_if)::get(this,"","spi_if",spi_cfg.spi_config_vif))begin
           `uvm_fatal("build_phase","test - unable to get VIF")
         end
        if (!uvm_config_db#(virtual spi_gold_if)::get(this,"","spi_gold_if",spi_gold_cfg.spi_gold_config_vif))begin
            `uvm_fatal("build_phase","test - unable to get gold VIF")
        end
               if (!uvm_config_db #(virtual RAM_if)::get(this, "", "RAM_IF", RAM_cfg.RAM_vif))
          `uvm_fatal("build_phase", "Test - Unable to get the virtual interface of the RAM from the uvm_config_db");
          if (!uvm_config_db #(virtual Gold_RAM_if)::get(this, "", "GOLD_RAM_IF", RAM_gold_cfg.gold_RAM_vif))
         `uvm_fatal("build_phase", "Test - Unable to get the virtual interface of the RAM from the uvm_config_db");

             uvm_config_db #(wrapper_config)::set(this, "*", "WR_CFG", wrapper_cfg);
             uvm_config_db #(wrapper_config)::set(this, "*", "WR_GOLD_CFG",wrapper_gold_cfg );
             uvm_config_db #(spi_config)::set(this,"*","S_CFG",spi_cfg); /// change from get to set 
             uvm_config_db #(spi_config)::set(this,"*","S_CFG_GOLD",spi_gold_cfg);
             uvm_config_db #(RAM_config)::set(this, "*", "R_CFG", RAM_cfg);
             uvm_config_db #(RAM_config)::set(this, "*", "R_GOLD_CFG",RAM_gold_cfg );
             RAM_cfg.is_active=UVM_PASSIVE;
             //RAM_gold_cfg.is_active=UVM_PASSIVE;
             spi_cfg.is_active=UVM_PASSIVE;
             //spi_gold_cfg.is_active=UVM_PASSIVE;
             wrapper_cfg.is_active=UVM_ACTIVE;
             //wrapper_gold_cfg.is_active=UVM_ACTIVE;
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        //reset sequence
        `uvm_info("run_phase", "Reset Asserted", UVM_MEDIUM)
        reset_seq.start(wr_env.agt.sqr);
        `uvm_info("run_phase", "Reset Deasserted", UVM_MEDIUM)

        //main sequence
        `uvm_info("run_phase", "Stimulus Generation Started", UVM_MEDIUM)
        write_seq.start(wr_env.agt.sqr);
        `uvm_info("run_phase", "Stimulus Generation Ended", UVM_MEDIUM)
        read_seq.start(wr_env.agt.sqr);
        read_write_seq.start(wr_env.agt.sqr);
        phase.drop_objection(this);
    endtask
endclass
endpackage