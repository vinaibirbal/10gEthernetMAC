`ifndef	TX_AGENT__SV
`define	TX_AGENT__SV
`include "tx_driver.sv"
`include "tx_monitor.sv"


typedef	uvm_sequencer #(packet)	packet_sequencer;

class tx_agent extends uvm_agent;

   `uvm_component_utils(tx_agent)

   packet_sequencer tx_seqr;
   tx_driver tx_drv;
   tx_monitor tx_mon;
   uvm_analysis_port#(packet) tx_agent_ap;

   function new(input string name="TX Agent", input uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase (input uvm_phase phase);
      super.build_phase(phase);
      tx_seqr = packet_sequencer::type_id::create("tx_seqr",this);
      tx_drv = tx_driver::type_id::create("tx_drv",this);
      tx_mon = tx_monitor::type_id::create("tx_mon",this);
      tx_agent_ap = new("tx_agent_ap",this);
   endfunction

   virtual function void connect_phase(input uvm_phase phase);
      super.connect_phase(phase);

      if(is_active == UVM_ACTIVE)begin
       tx_drv.seq_item_port.connect(tx_seqr.seq_item_export);
      end

      tx_mon.tx_mon_ap.connect(this.tx_agent_ap);
     
   endfunction;

endclass

`endif //tx_agent__SV
