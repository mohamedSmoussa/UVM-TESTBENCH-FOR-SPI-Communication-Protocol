package wrapper_seq_item_pkg;
import uvm_pkg::*;
import wrapper_shared::*;
`include "uvm_macros.svh"

class wrapper_seq_item extends uvm_sequence_item;
    `uvm_object_utils(wrapper_seq_item);

    rand bit rst_n;
    rand bit MOSI;
    rand bit SS_n;
    bit MISO, MISO_ref;
    rand bit [10:0] mosi_bus;
    bit [1:0] prev_din ;
    int prev_count;
    bit [2:0]  prev_mosi_3;

    function new(string name = "wrapper_seq_item");
        super.new(name);
    endfunction
    /////////////////
    constraint rst_n_c {
    rst_n dist {1 := 99, 0 := 1};
    }
    ////////////////
    // Write-only operation
    constraint write_only {
        if(prev_count==1){
        mosi_bus[10]==0;
      (prev_din == write_addr) -> 
        mosi_bus[9:8] dist {write_addr := 10, write_data := 90};
        (prev_din == write_data) -> 
       mosi_bus[9:8] dist {write_addr := 90, write_data := 10};
        }
    }
    // Read-only operation
    constraint read_only {
        if(prev_count==1) {
            mosi_bus[9:8] inside {read_addr,read_data};
       mosi_bus[10]==1;
      ( received_address) -> mosi_bus[9:8] == read_data;
      (!received_address) -> mosi_bus[9:8] == read_addr;
        }
    }
    // Mixed read/write sequencing
    constraint read_write {
        if(prev_count==1){
            mosi_bus[10:8] inside {3'b000,3'b001,3'b110,3'b111};
        
      if (prev_mosi_3==3'b000) {
        mosi_bus[9:8] dist {write_addr := 10, write_data := 90};
        mosi_bus[10]==0;
      }
       else if (prev_mosi_3==3'b001){
        mosi_bus[10:8] dist {{1'b1,read_addr} := 60, {1'b0,write_addr} := 40};
       }
      else if (prev_mosi_3==3'b110) {
        if(received_address) {
        mosi_bus[9:8] ==read_data;
        mosi_bus[10]==1;
         }
         else {
            mosi_bus[9:8] ==read_addr;
            mosi_bus[10]==1;
         }
      }
      else if (prev_mosi_3==3'b111 && !received_address){
        mosi_bus[10:8] dist {{1'b0,write_addr} := 60, {1'b1,read_addr} := 40};}
    }}
    function void post_randomize();
    
    if(SS_n || !rst_n) begin
         clk_count = 0;
    end
    else clk_count++;
       prev_count=clk_count;
       prev_din = mosi_bus[9:8];
       prev_mosi_3=mosi_bus[10:8];
    endfunction
     
    //////////////////////////
    constraint SS_n_c{
    if(cs_s==READ_DATA){
        if(clk_count == 23) SS_n == 1;
        else SS_n == 0;
    }
     else if (cs_s!=READ_DATA)  {
        if(clk_count == 13) SS_n == 1;
        else SS_n == 0;
    }
   }
   //////////////////////////////
    constraint MOSI_c{
       if (clk_count > 0 && clk_count < 12 ) MOSI == mosi_bus[11 - clk_count];
    }

    function void pre_randomize();
        if(cs_s==CHK_CMD) begin
             mosi_bus.rand_mode(1);
        end
		else begin 
            mosi_bus.rand_mode(0);   
        end  
    endfunction



    function string convert2string();
        return $sformatf("rst_n=%0b SS_n=%0b MOSI=%0b  MISO=%0b MISO_ref =%0b",
            rst_n, SS_n, MOSI, MISO, MISO_ref);
    endfunction

    function string convert2string_stimulus();
        return $sformatf("rst_n=%0b SS_n=%0b MOSI=%0b",
            rst_n, SS_n, MOSI);
    endfunction

endclass
endpackage
