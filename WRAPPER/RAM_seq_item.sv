package RAM_seq_item_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class RAM_seq_item extends uvm_sequence_item;
    `uvm_object_utils(RAM_seq_item)

    rand bit clk, rst_n, rx_valid;
    rand bit [9:0] din;
    bit [7:0] dout, dout_golden;
    bit tx_valid, tx_valid_golden;
    bit [9:0] prev_din = 2'b10;

    parameter write_addr = 2'b00;
    parameter write_data = 2'b01;
    parameter read_addr  = 2'b10;
    parameter read_data  = 2'b11;

    function new(string name = "RAM_seq_item");
      super.new(name);
    endfunction

    function string convert2string();
      return $sformatf("%s rst_n=%0b, din=%0d, rx_valid=%0b, dout=%0d, tx_valid=%0b",
                       super.convert2string(), rst_n, din, rx_valid, dout, tx_valid);
    endfunction

    function string convert2string_stimulus();
      return $sformatf("%s rst_n=%0b, din=%0d, rx_valid=%0b",
                       super.convert2string(), rst_n, din, rx_valid);
    endfunction

    // ---- Constraints ----
    constraint rst_n_c {
      rst_n dist {1 := 95, 0 := 5};
    }

    constraint rx_valid_c {
      rx_valid dist {1 := 80, 0 := 20};
    }

    // Write-only operation
    constraint write_only {
      (prev_din[9:8] == write_addr) -> 
        din[9:8] dist {write_addr := 10, write_data := 90};
    }

    // Read-only operation
    constraint read_only {
      (prev_din[9:8] == read_addr) -> din[9:8] == read_data;
      (prev_din[9:8] == read_data) -> din[9:8] == read_addr;
    }

    // Mixed read/write sequencing
    constraint read_write {
      (prev_din[9:8] == write_addr) -> 
        din[9:8] dist {write_addr := 10, write_data := 90};

      (prev_din[9:8] == read_addr) -> 
        din[9:8] dist {read_addr := 10, read_data := 90};

      if (prev_din[9:8] == write_data)
        din[9:8] dist {read_addr := 60, write_addr := 40};

      if (prev_din[9:8] == read_data)
        din[9:8] dist {write_addr := 60, read_addr := 40};
    }

    function void post_randomize();
      prev_din = din;
    endfunction

  endclass
endpackage
