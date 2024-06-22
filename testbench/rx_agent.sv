`ifndef	RX_AGENT__SV
`define	RX_AGENT__SV
`include "rx_monitor.sv"
`include "reset_item.sv"


class rx_agent extends uvm_agent;

   `uvm_component_utils(rx_agent)

   rx_monitor rx_mon;
   uvm_analysis_port#(packet) rx_agent_ap;


   function new(input string name="RX_Agent", input uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase (input uvm_phase phase);
      super.build_phase(phase);

      rx_mon = rx_monitor::type_id::create("rx_mon",this);
      rx_agent_ap = new("rx_agent_ap",this);

   endfunction

   virtual function void connect_phase(input uvm_phase phase);
      super.connect_phase(phase);

      if(is_active == UVM_ACTIVE)begin
       rx_drv.seq_item_port.connect(rx_seqr.seq_item_export);
      end

      rx_mon.rx_mon_ap.connect(this.rx_agent_ap);
     
   endfunction;

endclass

`endif //rx_agent__SV
