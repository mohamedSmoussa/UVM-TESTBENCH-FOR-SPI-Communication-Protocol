package spi_seq_item_pkg;
import uvm_pkg::*;
 `include "uvm_macros.svh"
import spi_shared::*;
class spi_seq_item extends uvm_sequence_item;
    `uvm_object_utils(spi_seq_item);
    rand logic rst_n;
    rand logic MOSI;
    rand logic SS_n;
    rand logic tx_valid;
    rand logic [7:0] tx_data;
    logic [9:0] rx_data, rx_data_ref;
    logic rx_valid, rx_valid_ref, MISO, MISO_ref; 

    rand bit [10:0] mosi_bus;
    static bit [1:0] cmd_bit = 2'b00;
    int clk_count;

    function new(string name = "spi_seq_item");
        super.new(name);
        tx_data=0;
    endfunction

    constraint rst_n_c{
        rst_n dist {0:/1, 1:/99};
    }

    constraint SS_n_c{
    if(cs_s==READ_DATA){
        if(clk_count == 23) SS_n == 1;
        else SS_n == 0;
    }
    else{
        if(clk_count == 13) SS_n == 1;
        else SS_n == 0;
    }
}

    constraint tx_valid_c{
        if(cs_s==READ_DATA && clk_count > 13 && clk_count < 23) tx_valid == 1;
        else tx_valid == 0;
    }

    constraint MOSI_c{
       if (clk_count > 0 && clk_count < 12) MOSI == mosi_bus[11 - clk_count];
    }

    function void pre_randomize();
        if(clk_count==0) mosi_bus.rand_mode(1);
		else mosi_bus.rand_mode(0);     

        if(mosi_bus[10:8] == 3'b111 && clk_count == 12) tx_data.rand_mode(1);
        else tx_data.rand_mode(0);

    endfunction

    constraint mosi_bus_const{
        mosi_bus[10] == cmd_bit[1];
        mosi_bus[9:8] == cmd_bit;
    } 

    function void post_randomize();
        if(SS_n || !rst_n) clk_count = 0;
        else clk_count++;
        if(!rst_n) cmd_bit = 0;
        else if(clk_count == 0) cmd_bit++;
    endfunction
    function string convert2string();
        return $sformatf("%s rst_n = 0b%0b , MOSI = 0b%0b , SS_n = 0b%0b , tx_valid = 0b%0b , MISO = 0b%0b , tx_data = 0x%02h , rx_valid = 0b%0b , rx_data = 0x%03h",
            super.convert2string(), rst_n, MOSI, SS_n, tx_valid, tx_data, MISO, rx_valid, rx_data);
    endfunction
    function string convert2string_stimulus();
        return $sformatf("%s rst_n = 0b%0b , MOSI = 0b%0b , SS_n = 0b%0b , tx_valid = 0b%0b , tx_data = 0x%02h",
            super.convert2string(), rst_n, MOSI, SS_n, tx_valid, tx_data);
    endfunction

endclass



endpackage