//---
// XGMII Loopback
// This test is done with loopback on XGMII or using one of the tranceiver examples
`include "tasks.sv"


program loopback();

`ifndef GXB
  `ifndef XIL
    assign xgmii_rxc = xgmii_txc;
    assign xgmii_rxd = xgmii_txd;
  `endif
`endif




initial begin
    WaitNS(5000);
    `ifdef XIL
    WaitNS(200000);
    `endif
    
    ProcessCmdFile();

    forever begin

        if (pkt_rx_avail) begin

            RxPacket();

            if (rx_count == tx_count) begin
                $display("All packets received. Sumulation done!!!\n");
            end

        end

        @(posedge clk_156m25);

    end

end

endprogram
