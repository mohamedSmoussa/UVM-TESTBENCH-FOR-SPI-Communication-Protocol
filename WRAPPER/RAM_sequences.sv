package RAM_sequences_pkg;
import uvm_pkg::*;
import RAM_seq_item_pkg::*;
`include "uvm_macros.svh"
class RAM_reset_sequence extends uvm_sequence #(RAM_seq_item);
    `uvm_object_utils(RAM_reset_sequence)
    RAM_seq_item seq_item;

    function new(string name = "RAM_reset_sequence");
        super.new(name);
    endfunction

    task body;
        seq_item = RAM_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.din = 0;
        seq_item.rx_valid = 0;
        seq_item.rst_n= 0;
        finish_item(seq_item);
    endtask
endclass
class RAM_write_sequence extends uvm_sequence #(RAM_seq_item);
    `uvm_object_utils(RAM_write_sequence)
    RAM_seq_item seq_item;

    function new(string name="RAM_write_sequence");
        super.new(name);
    endfunction

    task body();
        seq_item = RAM_seq_item::type_id::create("seq_item");
        seq_item.read_only.constraint_mode(0);
        seq_item.read_write.constraint_mode(0);
        seq_item.write_only.constraint_mode(1);
        repeat(2000) begin
        start_item(seq_item);
        assert(seq_item.randomize());
        finish_item(seq_item);
        end
    endtask
endclass
class RAM_read_sequence extends uvm_sequence #(RAM_seq_item);
    `uvm_object_utils(RAM_read_sequence)
    RAM_seq_item seq_item;

    function new(string name="RAM_read_sequence");
        super.new(name);
    endfunction

    task body();
        seq_item = RAM_seq_item::type_id::create("seq_item");
        seq_item.read_only.constraint_mode(1);
        seq_item.read_write.constraint_mode(0);
        seq_item.write_only.constraint_mode(0);
        repeat(2000) begin
        start_item(seq_item);
        assert(seq_item.randomize());
        finish_item(seq_item);
        end
    endtask
endclass
class RAM_read_write_sequence extends uvm_sequence #(RAM_seq_item);
    `uvm_object_utils(RAM_read_write_sequence)
    RAM_seq_item seq_item;

    function new(string name="RAM_read_write_sequence");
        super.new(name);
    endfunction

    task body();
        seq_item = RAM_seq_item::type_id::create("seq_item");
         seq_item.read_only.constraint_mode(0);
         seq_item.read_write.constraint_mode(1);
         seq_item.write_only.constraint_mode(0);
        repeat(2000) begin
        start_item(seq_item);
        assert(seq_item.randomize());
        finish_item(seq_item);
        end
    endtask
endclass
endpackage