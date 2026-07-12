module wrapper_sva(
    wrapper_if wrapper_vif,
    input logic [9:0] din,
    input logic rx_valid,
    input logic tx_valid
);

    // Reset property: when reset asserted, outputs inactive
    property reset_active;
        @(posedge wrapper_vif.clk)
        (wrapper_vif.rst_n == 0) |=> 
        (wrapper_vif.MISO == 0 && rx_valid == 0 && din == '0);
    endproperty

    // MISO must be stable when SS_n is low
    property stable_MISO;
        @(posedge wrapper_vif.clk)
        disable iff(!wrapper_vif.rst_n)
            (!wrapper_vif.SS_n && !tx_valid) |=> $stable(wrapper_vif.MISO);
    endproperty

    a_reset_active  : assert property (reset_active);
    c_reset_active  : cover  property (reset_active);

    a_stable_MISO   : assert property (stable_MISO);
    c_stable_MISO   : cover  property (stable_MISO);

endmodule
