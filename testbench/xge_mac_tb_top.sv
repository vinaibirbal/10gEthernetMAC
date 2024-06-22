`ifndef XGE_MAC_TB_TOP__SV
`define XGE_MAC_TB_TOP__SV

//`include "timescale.v"
//`include "defines.v"
`include "tasks.sv"
//`include"testclass.sv"

//`define GXB
//`define XIL

module xge_mac_tb_top();


/*AUTOREG*/

reg           clk_156m25;
reg           clk_312m50;
reg           clk_xgmii_rx;
reg           clk_xgmii_tx;
reg 	      wb_clk_i; 	      

reg           reset_156m25_n;
reg           reset_xgmii_rx_n;
reg           reset_xgmii_tx_n;
reg 	      wb_rst_i;

reg           pkt_rx_ren;

reg  [63:0]   pkt_tx_data;
reg           pkt_tx_val;
reg           pkt_tx_sop;
reg           pkt_tx_eop;
reg  [2:0]    pkt_tx_mod;

/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire                    pkt_rx_avail;           // From dut of xge_mac.v
wire [63:0]             pkt_rx_data;            // From dut of xge_mac.v
wire                    pkt_rx_eop;             // From dut of xge_mac.v
wire                    pkt_rx_err;             // From dut of xge_mac.v
wire [2:0]              pkt_rx_mod;             // From dut of xge_mac.v
wire                    pkt_rx_sop;             // From dut of xge_mac.v
wire                    pkt_rx_val;             // From dut of xge_mac.v
wire                    pkt_tx_full;            // From dut of xge_mac.v
wire                    wb_ack_o;               // From dut of xge_mac.v
wire [31:0]             wb_dat_o;               // From dut of xge_mac.v
wire                    wb_int_o;               // From dut of xge_mac.v
wire [7:0]              xgmii_txc;              // From dut of xge_mac.v
wire [63:0]             xgmii_txd;              // From dut of xge_mac.v
// End of automatics

wire  [7:0]   wb_adr_i;
wire  [31:0]  wb_dat_i;

wire [7:0]              xgmii_rxc;
wire [63:0]             xgmii_rxd;

wire [3:0]              tx_dataout;

wire                    xaui_tx_l0_n;
wire                    xaui_tx_l0_p;
wire                    xaui_tx_l1_n;
wire                    xaui_tx_l1_p;
wire                    xaui_tx_l2_n;
wire                    xaui_tx_l2_p;
wire                    xaui_tx_l3_n;
wire                    xaui_tx_l3_p;

xge_mac dut(/*AUTOINST*/
            // Outputs
            .pkt_rx_avail               (xge_mac_if.pkt_rx_avail),
            .pkt_rx_data                (xge_mac_if.pkt_rx_data[63:0]),
            .pkt_rx_eop                 (xge_mac_if.pkt_rx_eop),
            .pkt_rx_err                 (xge_mac_if.pkt_rx_err),
            .pkt_rx_mod                 (xge_mac_if.pkt_rx_mod[2:0]),
            .pkt_rx_sop                 (xge_mac_if.pkt_rx_sop),
            .pkt_rx_val                 (xge_mac_if.pkt_rx_val),
            .pkt_tx_full                (xge_mac_if.pkt_tx_full),
            .wb_ack_o                   (xge_mac_if.wb_ack_o),
            .wb_dat_o                   (xge_mac_if.wb_dat_o[31:0]),
            .wb_int_o                   (xge_mac_if.wb_int_o),
            .xgmii_txc                  (xge_mac_if.xgmii_txc[7:0]),
            .xgmii_txd                  (xge_mac_if.xgmii_txd[63:0]),
            // Inputs
            .clk_156m25                 (clk_156m25),
            .clk_xgmii_rx               (clk_xgmii_rx),
            .clk_xgmii_tx               (clk_xgmii_tx),
            .pkt_rx_ren                 (xge_mac_if.pkt_rx_ren),
            .pkt_tx_data                (xge_mac_if.pkt_tx_data[63:0]),
            .pkt_tx_eop                 (xge_mac_if.pkt_tx_eop),
            .pkt_tx_mod                 (xge_mac_if.pkt_tx_mod[2:0]),
            .pkt_tx_sop                 (xge_mac_if.pkt_tx_sop),
            .pkt_tx_val                 (xge_mac_if.pkt_tx_val),
            .reset_156m25_n             (reset_156m25_n),
            .reset_xgmii_rx_n           (reset_xgmii_rx_n),
            .reset_xgmii_tx_n           (reset_xgmii_tx_n),
            .wb_adr_i                   (xge_mac_if.wb_adr_i[7:0]),
            .wb_clk_i                   (wb_clk_i),
            .wb_cyc_i                   (xge_mac_if.wb_cyc_i),
            .wb_dat_i                   (xge_mac_if.wb_dat_i[31:0]),
            .wb_rst_i                   (wb_rst_i),
            .wb_stb_i                   (xge_mac_if.wb_stb_i),
            .wb_we_i                    (xge_mac_if.wb_we_i),
            .xgmii_rxc                  (xge_mac_if.xgmii_rxc[7:0]),
            .xgmii_rxd                  (xge_mac_if.xgmii_rxd[63:0]));

// Instantiate xge_mac_interface
  xge_mac_interface     xge_mac_if  (
                                        .clk_156m25         (clk_156m25),
				        .clk_312m50         (clk_312m50),
                                        .clk_xgmii_rx       (clk_xgmii_rx),
                                        .clk_xgmii_tx       (clk_xgmii_tx),
                                        .wb_clk_i           (wb_clk_i),
                                        .reset_156m25_n     (reset_156m25_n),
                                        .reset_xgmii_rx_n   (reset_xgmii_rx_n),
                                        .reset_xgmii_tx_n   (reset_xgmii_tx_n),
                                        .wb_rst_i           (wb_rst_i)
                                    );




// Clock generation

initial begin
    clk_156m25 = 1'b0;
    clk_xgmii_rx = 1'b0;
    clk_xgmii_tx = 1'b0;
    wb_clk_i     = 1'b0;
    forever begin
        WaitPS(3200);
        clk_156m25 = ~clk_156m25;
        clk_xgmii_rx = ~clk_xgmii_rx;
        clk_xgmii_tx = ~clk_xgmii_tx;
        wb_clk_i     = ~wb_clk_i;
    end
end

initial begin
    clk_312m50 = 1'b0;
    forever begin
        WaitPS(1600);
        clk_312m50 = ~clk_312m50;
    end
end


//---
// Init signals

initial begin
    pkt_rx_ren = 1'b0;

    pkt_tx_data = 64'b0;
    pkt_tx_val = 1'b0;
    pkt_tx_sop = 1'b0;
    pkt_tx_eop = 1'b0;
    pkt_tx_mod = 3'b0;

end

   //limit simulation time
initial begin
    #10000000000
    $finish;

end


   



endmodule//xge_test_top()

`endif  // XGE_TEST_TOP__SV
