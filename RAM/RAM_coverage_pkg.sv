package RAM_coverage_pkg;
 import uvm_pkg::*;
 import RAM_seq_item_pkg::*;
 `include "uvm_macros.svh"
class RAM_coverage extends uvm_component;
  `uvm_component_utils(RAM_coverage)

  uvm_analysis_export #(RAM_seq_item) cov_export;
  uvm_tlm_analysis_fifo #(RAM_seq_item) cov_fifo;
  RAM_seq_item seq_item_cov;

  parameter WRITE_ADDR = 2'b00;
  parameter WRITE_DATA = 2'b01;
  parameter READ_ADDR = 2'b10;
  parameter READ_DATA = 2'b11;

  covergroup cvr_grp;
   din_cov: coverpoint seq_item_cov.din[9:8]{
    bins Bin_Write_Addr = {WRITE_ADDR};
    bins Bin_Write_Data = {WRITE_DATA};
    bins Bin_Read_Addr = {READ_ADDR};
    bins Bin_Read_data = {READ_DATA};
    bins Bin_Write = (WRITE_ADDR => WRITE_DATA);
    bins Bin_Read = (READ_ADDR => READ_DATA);
    bins read_write_bin = (0 => 1) , (1 => 3) , ( 1 => 0),(0 => 2),
                           (2 => 3) , ( 2 => 0) , (3 => 1) , ( 3 => 2);
   }
      rx_valid_cov : coverpoint seq_item_cov.rx_valid {
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
  
   tx_valid_cov : coverpoint seq_item_cov.tx_valid {
      bins HIGH_tx = {1'b1};
      bins LOW_tx = {1'b0};
    }
  
   cross_tx_valid_din: cross din_cov , tx_valid_cov {
       option.cross_auto_bin_max=0;
        bins din_rt = binsof(din_cov.Bin_Read_data) && binsof(tx_valid_cov.HIGH_tx);
    }
  endgroup

  function new(string name = "RAM_coverage", uvm_component parent = null);
    super.new(name, parent);
    cvr_grp = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export", this);
    cov_fifo = new("cov_fifo", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      cov_fifo.get(seq_item_cov);
      cvr_grp.sample();
    end
  endtask

endclass
endpackage
