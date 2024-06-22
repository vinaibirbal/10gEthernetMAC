`ifndef	WISHBONE_AGENT__SV
`define	WISHBONE_AGENT__SV
`include "wishbone_driver.sv"
//`include "wishbone_monitor.sv"


typedef	uvm_sequencer #(wishbone_item)	wishbone_sequencer;

class wishbone_agent extends uvm_agent;
   `uvm_component_utils(wishbone_agent)

   wishbone_sequencer wb_seqr;
   wishbone_driver wb_drv;
   uvm_analysis_port#(wishbone_item) wb_agent_ap;

   function new(input string name="WishboneAgent", input uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase (input uvm_phase phase);
      super.build_phase(phase);

      wishbone_seqr = wishbone_sequencer::type_id::create("wb_seqr",this);
      wb_drv = wishbone_driver::type_id::create("wb_drv",this);
      wb_agent_ap = new("wb_agent_ap",this);

   endfunction

   virtual function void connect_phase(input uvm_phase phase);
      super.connect_phase(phase);

      if(is_active == UVM_ACTIVE)begin
         wb_drv.seq_item_port.connect(wb_seqr.seq_item_export);
      end

      wb_mon.wb_mon_ap.connect(this.wb_agent_ap);    

   endfunction

endclass

`endif //INPUT_AGENT__SV
