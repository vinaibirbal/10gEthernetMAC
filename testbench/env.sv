`ifndef	ENV__SV
`define	ENV__SV

`include "rx_agent.sv"
`include "tx_agent.sv"
`include "reset_agent.sv"
`include "wishbone_agent.sv"
`include "scoreboard.sv"
//`include "coverage.sv"

class env extends uvm_env;

   `uvm_component_utils(env)

    //packet_sequencer  seqr;
   rx_agent        pkt_rx_agent;
   tx_agent        pkt_tx_agent;
   reset_agent     rst_agent;
   wishbone_agent  wb_agent;

   scoreboard       sb;
   //coverage  cov;

   function new(input string name ="environment", input uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(input uvm_phase phase);
      super.build_phase(phase);

      pkt_rx_agent = rx_agent::type_id::create("pkt_rx_agent",this);
      pkt_tx_agent = tx_agent::type_id::create("pkt_tx_agent",this);
      rst_agent= reset_agent::type_id::create("rst_agent",this);
      wb_agent = wishbone_agent::type_id::create("wb_agent",this);

      sb = scoreboard::type_id::create("sb",this);
     //cov =coverage::type_id::create("cov",this);

   endfunction

   virtual function void connect_phase(input uvm_phase phase);

      super.connect_phase(phase);

      pkt_rx_agent.ap_rx_agent.connect(sb.from_agent_rx);
      pkt_tx_agent.ap_tx_agent.connect(sb.from_agent_tx);
      //wb_agent.ap_wb_agent.connect(sb.from_wb_agent);    

      //rx_agent.ap_rx_agent.connect(cov.analysis_export);

   endfunction 
   
endclass

`endif //ENV__SV
