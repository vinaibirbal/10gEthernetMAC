
`ifndef	INPUT_AGENT__SV
`define	INPUT_AGENT__SV
`include "driver.sv"


typedef	uvm_sequencer #(packet)	packet_sequencer;

class input_agent extends uvm_agent;
   `uvm_component_utils(input_agent)
   packet_sequencer seqr;
   driver drv;
   function new(input string name="SecretAgent", input uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase (input uvm_phase phase);
      super.build_phase(phase);
      seqr = packet_sequencer::type_id::create("seqr",this);
      drv = driver::type_id::create("drv",this);
   endfunction

   virtual function void connect_phase(input uvm_phase phase);
      super.connect_phase(phase);
      drv.seq_item_port.connect(seqr.seq_item_export);
   endfunction;

endclass

`endif //INPUT_AGENT__SV
