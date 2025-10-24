package sequences;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_seq_item_pkg::*;
import spi_shared::*;
class reset_sequence extends uvm_sequence #(spi_seq_item);
`uvm_object_utils(reset_sequence)

 function new (string name = "reset_sequence");
 super.new(name);
 endfunction

task body();
spi_seq_item req;
req = spi_seq_item::type_id::create("req");
start_item(req);
req.SS_n=1;
req.rst_n=0;
req.MOSI=0;
req.tx_data=0;
req.tx_valid=0;
finish_item(req);
endtask 
endclass
////////////////////////////
class main_sequence extends  uvm_sequence #(spi_seq_item);
 `uvm_object_utils(main_sequence);
 spi_seq_item req;
 function new(string name= "main_sequence");
     super.new(name);
 endfunction
 task body ;
 req= spi_seq_item :: type_id :: create("req");
 repeat(10000) begin
 start_item(req);
 assert (req.randomize() );
 finish_item(req);
 end
 endtask

 endclass


endpackage































































