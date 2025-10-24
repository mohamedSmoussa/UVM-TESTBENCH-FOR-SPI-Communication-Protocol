
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_test_pkg::*;
module top();
    bit clk;

    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end
    Gold_RAM_if gold_RAMif(clk);
    RAM_if RAMif (clk);
    RAM dut (
        .din(RAMif.din), .clk(clk) ,.rst_n(RAMif.rst_n), .rx_valid( RAMif.rx_valid), .dout(RAMif.dout) , .tx_valid(RAMif.tx_valid)

    );

    Single_Port_RAM golden_model(.din(gold_RAMif.din),.rx_valid(gold_RAMif.rx_valid),.clk(gold_RAMif.clk),
      .rst_n(gold_RAMif.rst_n),.dout(gold_RAMif.dout),.tx_valid(gold_RAMif.tx_valid));
    // --- Bind the Assertions ---
    bind RAM RAM_sva RAM_assertions_inst (
    .clk(RAMif.clk),
    .rst_n(RAMif.rst_n),
    .rx_valid(RAMif.rx_valid),
    .din(RAMif.din),
    .dout(RAMif.dout),
    .tx_valid(RAMif.tx_valid)
);


    initial begin
        uvm_config_db#(virtual RAM_if)::set(null, "uvm_test_top", "RAM_IF", RAMif);
        uvm_config_db#(virtual Gold_RAM_if)::set(null,"uvm_test_top","GOLD_RAM_IF",gold_RAMif);
        run_test("RAM_test");
    end

endmodule
