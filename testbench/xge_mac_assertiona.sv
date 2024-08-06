`ifndef XGE_MAC_ASSERTIONS__SV
`define XGE_MAC_ASSERTIONS__SV

module xge_mac_assertions (
   input clk,
   input rst_n,
   input [63:0] xgmii_rxd,
   input [7:0] xgmii_rxc,
   input [63:0] xgmii_txd,
   input [7:0] xgmii_txc
);

   // Check for valid start of frame
   property valid_sof;
      @(posedge clk) disable iff (!rst_n)
      $rose(xgmii_rxc[0]) |-> xgmii_rxd[7:0] == 8'hFB;
   endproperty
   assert property (valid_sof) else $error("Invalid start of frame detected");

   // Check for valid end of frame
   property valid_eof;
      @(posedge clk) disable iff (!rst_n)
      $rose(xgmii_rxc[0]) |-> xgmii_rxd[7:0] inside {8'hFD, 8'hFE};
   endproperty
   assert property (valid_eof) else $error("Invalid end of frame detected");

   // Check for minimum inter-frame gap (IFG)
   sequence min_ifg;
      (!xgmii_rxc[0])[*5];
   endsequence
   property valid_ifg;
      @(posedge clk) disable iff (!rst_n)
      $fell(xgmii_rxc[0]) |-> min_ifg;
   endproperty
   assert property (valid_ifg) else $error("Minimum IFG violation detected");

   // Add more assertions as needed

endmodule

`endif //XGE_MAC_ASSERTIONS__SV