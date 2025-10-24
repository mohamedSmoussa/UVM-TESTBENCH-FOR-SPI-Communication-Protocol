package wrapper_sequences_pkg;
import uvm_pkg::*;
import wrapper_seq_item_pkg::*;
`include "uvm_macros.svh"
class wrapper_reset_sequence extends uvm_sequence #(wrapper_seq_item);
    `uvm_object_utils(wrapper_reset_sequence)
    wrapper_seq_item seq_item;

    function new(string name = "wrapper_reset_sequence");
        super.new(name);
    endfunction

    task body;
        seq_item = wrapper_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.SS_n = 0;
        seq_item.MOSI = 0;
        seq_item.rst_n= 0;
        finish_item(seq_item);
    endtask
endclass
class wrapper_write_sequence extends uvm_sequence #(wrapper_seq_item);
    `uvm_object_utils(wrapper_write_sequence)
    wrapper_seq_item seq_item;

    function new(string name="wrapper_write_sequence");
        super.new(name);
    endfunction

    task body();
        seq_item = wrapper_seq_item::type_id::create("seq_item");
        seq_item.read_only.constraint_mode(0);
        seq_item.read_write.constraint_mode(0);
        seq_item.write_only.constraint_mode(1);
        repeat(10000) begin
        start_item(seq_item);
        assert(seq_item.randomize());
        finish_item(seq_item);
        end
    endtask
endclass
class wrapper_read_sequence extends uvm_sequence #(wrapper_seq_item);
    `uvm_object_utils(wrapper_read_sequence)
    wrapper_seq_item seq_item;

    function new(string name="wrapper_read_sequence");
        super.new(name);
    endfunction

    task body();
        seq_item = wrapper_seq_item::type_id::create("seq_item");
        seq_item.read_only.constraint_mode(1);
        seq_item.read_write.constraint_mode(0);
        seq_item.write_only.constraint_mode(0);
        repeat(10000) begin
        start_item(seq_item);
        assert(seq_item.randomize());
        finish_item(seq_item);
        end
    endtask
endclass
class wrapper_read_write_sequence extends uvm_sequence #(wrapper_seq_item);
    `uvm_object_utils(wrapper_read_write_sequence)
    wrapper_seq_item seq_item;

    function new(string name="wrapper_read_write_sequence");
        super.new(name);
    endfunction

    task body();
        seq_item = wrapper_seq_item::type_id::create("seq_item");
         seq_item.read_only.constraint_mode(0);
         seq_item.read_write.constraint_mode(1);
         seq_item.write_only.constraint_mode(0);
        repeat(10000) begin
        start_item(seq_item);
        assert(seq_item.randomize());
        finish_item(seq_item);
        end
    endtask
endclass
endpackage