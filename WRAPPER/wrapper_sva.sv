import wrapper_shared::*;
module wrapper_sva(MISO,MOSI,rst_n,SS_n,clk);
input MISO,MOSI,rst_n,SS_n,clk;


property p_reset_outputs_inactive;
  @(posedge clk)
  (!rst_n) |=> (MISO == 0 && rx_valid == 0 && rx_data == 0);
endproperty

assert property (p_reset_outputs_inactive);
cover property (p_reset_outputs_inactive);

property stable_miso;
@(posedge clk) disable iff (!rst_n) (cs_s!=READ_DATA) |=> $stable(MISO);
endproperty

assert property (stable_miso);
cover property (stable_miso);
endmodule