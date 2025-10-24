package wrapper_coverage_pkg;
import uvm_pkg::*;
import wrapper_seq_item_pkg::*;
import wrapper_shared::*;
`include "uvm_macros.svh"
class wrapper_coverage extends uvm_component;

`uvm_component_utils(wrapper_coverage)
uvm_analysis_export #(wrapper_seq_item) cov_export;
uvm_tlm_analysis_fifo #(wrapper_seq_item) cov_fifo;
wrapper_seq_item cov_txn;

covergroup CovCode;
c1:coverpoint rx_data[9:8]{   // come from shared
bins all_values [] = {2'b00,2'b01,2'b10,2'b11};
bins rx_data_trans[] = ( 0 => 1) , ( 1=> 3) , (1 => 0) , ( 2 => 3) , ( 2=> 0) , (3 => 1), ( 3 => 2);
}

SS_n_c3:coverpoint cov_txn.SS_n {
    bins ssn_13_wr = (1 => 0[*13] => 1) ;
    bins ssn_23_wr = (1 => 0[*23] => 1) ;  
}
MOSI_c4:coverpoint cov_txn.MOSI {
    bins write_address = (0 => 0 => 0) ;
    bins write_data = (0 => 0 => 1) ;
    bins read_address = (1 => 1 => 0) ;
    bins read_data = (1 => 1 => 1) ;
}
//cross coverage between SS_n and MOSI(only legal scenarios) 
 SS_n_MOSI_cross:cross SS_n_c3 , MOSI_c4 {
    option.cross_auto_bin_max=0;
    bins legal_write_address = binsof(SS_n_c3.ssn_13_wr) && binsof(MOSI_c4.write_address);
    bins legal_write_data = binsof(SS_n_c3.ssn_13_wr) && binsof(MOSI_c4.write_data) ;
    bins legal_read_address = binsof(SS_n_c3.ssn_13_wr) && binsof(MOSI_c4.read_address) ;
    bins legal_read_data = binsof(SS_n_c3.ssn_23_wr) && binsof(MOSI_c4.read_data) ;
    ignore_bins wrong_normal_read_data =binsof(SS_n_c3.ssn_13_wr) && binsof(MOSI_c4.read_data) ;
    ignore_bins wrong_extended_write = binsof(SS_n_c3.ssn_23_wr) && binsof(MOSI_c4.write_address) ;
    ignore_bins wrong_extended_write_data = binsof(SS_n_c3.ssn_23_wr) && binsof(MOSI_c4.write_data);
    ignore_bins wrong_extended_read_add=binsof(SS_n_c3.ssn_23_wr) && binsof(MOSI_c4.read_address);
      }
       din_cov: coverpoint rx_data[9:8]{
       bins Bin_Write_Addr = {write_addr};
       bins Bin_Write_Data = {write_data};
       bins Bin_Read_Addr = {read_addr};
       bins Bin_Read_data = {read_data};
       bins Bin_Write = (write_addr=> write_data);
       bins Bin_Read = (read_addr => read_data);
       bins read_write_bin = (0 => 1) , (1 => 3) , ( 1 => 0),(0 => 2),
                         (2 => 3) , ( 2 => 0) , (3 => 1) , ( 3 => 2);
 }
    rx_valid_cov : coverpoint rx_valid {
    bins HIGH_rx = {1'b1};
    bins LOW_rx = {1'b0};
    }
   cross_rx_valid_din: cross din_cov , rx_valid_cov {
      option.cross_auto_bin_max=0;
      bins wr_din_rx_high =  binsof(rx_valid_cov.HIGH_rx) && binsof(din_cov. Bin_Write_Addr);
      bins wrd_din_rx_high =  binsof(rx_valid_cov.HIGH_rx) && binsof(din_cov.Bin_Write_Data);
      bins rd_din_rx_high =  binsof(rx_valid_cov.HIGH_rx) && binsof(din_cov.Bin_Read_Addr);
      bins rdd_din_rx_high =  binsof(rx_valid_cov.HIGH_rx) && binsof(din_cov.Bin_Read_data);
  }
  
 tx_valid_cov : coverpoint tx_valid {
    bins HIGH_tx = {1'b1};
    bins LOW_tx = {1'b0};
  }
  
 cross_tx_valid_din: cross din_cov , tx_valid_cov {
     option.cross_auto_bin_max=0;
      bins din_rt = binsof(din_cov.Bin_Read_data) && binsof(tx_valid_cov.HIGH_tx);
  }
endgroup


function new(string name = "wrapper_coverage",uvm_component parent = null);
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