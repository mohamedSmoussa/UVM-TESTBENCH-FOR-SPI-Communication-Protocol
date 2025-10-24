package RAM_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_env_pkg::*;
import RAM_config_pkg::*;
import RAM_sequences_pkg::*;
class RAM_test extends uvm_test;
    `uvm_component_utils(RAM_test)

    RAM_env env;
    RAM_config RAM_cfg;
    RAM_config RAM_gold_cfg;
    virtual RAM_if RAM_vif;
    RAM_write_sequence write_seq;
    RAM_read_sequence read_seq;
    RAM_read_write_sequence read_write_seq;
    RAM_reset_sequence reset_seq;

    function new(string name = "RAM_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = RAM_env::type_id::create("env", this);
        RAM_cfg = RAM_config::type_id::create("RAM_cfg", this);
        RAM_gold_cfg = RAM_config::type_id::create("RAM_gold_cfg", this);
        write_seq = RAM_write_sequence::type_id::create("write_seq", this);
        reset_seq = RAM_reset_sequence::type_id::create("reset_seq", this);
        read_seq=RAM_read_sequence::type_id::create("read_seq", this);
        read_write_seq=RAM_read_write_sequence::type_id::create("read_write_seq", this);

        if (!uvm_config_db #(virtual RAM_if)::get(this, "", "RAM_IF", RAM_cfg.RAM_vif))
            `uvm_fatal("build_phase", "Test - Unable to get the virtual interface of the RAM from the uvm_config_db");
            if (!uvm_config_db #(virtual Gold_RAM_if)::get(this, "", "GOLD_RAM_IF", RAM_gold_cfg.gold_RAM_vif))
           `uvm_fatal("build_phase", "Test - Unable to get the virtual interface of the RAM from the uvm_config_db");

        uvm_config_db #(RAM_config)::set(this, "*", "CFG", RAM_cfg);
        uvm_config_db #(RAM_config)::set(this, "*", "GOLD_CFG",RAM_gold_cfg );
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        //uvm_top.print_topology();
        //factory.print();
        
        //reset sequence
        `uvm_info("run_phase", "Reset Asserted", UVM_MEDIUM)
        reset_seq.start(env.agt.sqr);
        `uvm_info("run_phase", "Reset Deasserted", UVM_MEDIUM)

        //main sequence
        `uvm_info("run_phase", "Stimulus Generation Started", UVM_MEDIUM)
        write_seq.start(env.agt.sqr);
        `uvm_info("run_phase", "Stimulus Generation Ended", UVM_MEDIUM)
        read_seq.start(env.agt.sqr);
        read_write_seq.start(env.agt.sqr);
        phase.drop_objection(this);
    endtask
endclass
endpackage