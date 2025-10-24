interface Gold_RAM_if (input  clk);
    logic rst_n;
    logic rx_valid;
    logic [9:0] din;
    logic [7:0] dout;
    logic tx_valid;

    modport DRV (
        input clk,
        output rst_n, rx_valid, din
    );

    // ------------ Monitor side ------------
    modport MON (
        input clk, rst_n, rx_valid, din, dout, tx_valid
    );

endinterface
