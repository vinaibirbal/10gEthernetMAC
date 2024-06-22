`ifndef	RSET_AGENT__SV
`define	RESET_AGENT__SV
`include "reset_driver.sv"


typedef	uvm_sequencer #(reset_item)	reset_sequencer;

class reset_agent extends uvm_agent;
   `uvm_component_utils(reset_agent)
   reset_sequencer rst_seqr;
   reset_driver rst_drv;

   function new(input string name="ResetAgent", input uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase (input uvm_phase phase);
      super.build_phase(phase);
      if(is_active==UVM_ACTIVE)begin
         rst_seqr = reset_sequencer::type_id::create("seqr",this);
         rst_drv = reset_driver::type_id::create("drv",this);
      end
   endfunction

   virtual function void connect_phase(input uvm_phase phase);
      super.connect_phase(phase);
      rst_drv.seq_item_port.connect(rst_seqr.seq_item_export);
   endfunction;

endclass

`endif //RESET_AGENT__SV
