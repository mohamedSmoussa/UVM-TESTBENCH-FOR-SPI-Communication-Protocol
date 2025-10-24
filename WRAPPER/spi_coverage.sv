package spi_coverage_pkg;
import uvm_pkg::*;
import spi_seq_item_pkg::*;
import spi_shared::*;
class spi_coverage extends uvm_component;
`include "uvm_macros.svh"
`uvm_component_utils(spi_coverage)
uvm_analysis_export #(spi_seq_item) cov_export;
uvm_tlm_analysis_fifo #(spi_seq_item) cov_fifo;
spi_seq_item cov_txn;

covergroup CovCode;
c1:coverpoint cov_txn.rx_data[9:8]{ 
bins all_values [] = {2'b00,2'b01,2'b10,2'b11}; // 00,01,10,11
bins rx_data_trans[] = ( 0 => 1) , ( 1=> 3) , (1 => 0) , ( 2 => 3) , ( 2=> 0) , (3 => 1), ( 3 => 2);
}
 
SS_n_c2:coverpoint cov_txn.SS_n {
    bins normal_transaction = (1 => 0[*13] => 1) ;
    bins extended_bits_transaction = (1 => 0[*23] => 1) ;  
}
MOSI_c3:coverpoint cov_txn.MOSI {
    bins write_address = (0 => 0 => 0) ;//write address command(000)
    bins write_data = (0 => 0 => 1) ; //write data command(001)
    bins read_address = (1 => 1 => 0) ;//read address command(110)
    bins read_data = (1 => 1 => 1) ;//read data command(111) 
}
//cross coverage between SS_n and MOSI(only legal scenarios) 
 SS_n_MOSI_cross:cross SS_n_c2 , MOSI_c3 {
   // option.cross_auto_bin_max=0;
    ignore_bins wrong_normal_read_data =binsof(SS_n_c2.normal_transaction) && binsof(MOSI_c3.read_data) ;
    ignore_bins wrong_extended_write = binsof(SS_n_c2.extended_bits_transaction) && binsof(MOSI_c3.write_address) ;
    ignore_bins wrong_extended_write_data = binsof(SS_n_c2.extended_bits_transaction) && binsof(MOSI_c3.write_data);
    ignore_bins wrong_extended_read_add=binsof(SS_n_c2.extended_bits_transaction) && binsof(MOSI_c3.read_address);
      }
endgroup

function new(string name = "spi_coverage",uvm_component parent = null);
super.new(name,parent);
CovCode=new();
endfunction

function void build_phase (uvm_phase phase);
super.build_phase(phase);
cov_export=new("cov_export",this);
cov_fifo=new("cov_fifo",this);
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
cov_export.connect(cov_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
    cov_fifo.get(cov_txn);
    CovCode.sample();
end
endtask
endclass
endpackage