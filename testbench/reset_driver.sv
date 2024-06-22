`ifndef	RESET_DRIVER__SV
`define	RESET_DRIVER__SV
//`include "packet_sequence.sv"

class reset_driver extends uvm_driver #(packet);
   `uvm_component_utils(reset_driver)

   virtual xge_mac_interface rst_drv_vi;

   function new(input string name="Reset_Driver", input uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(input uvm_phase phase);
      `uvm_info("RESET DRIVER_CLASS", "HIERACY:%m", UVM_HIGH);
      super.build_phase(phase);
      uvm_config_db#(virtual xge_mac_interface)::get(this,"","rst_drv_vi",rst_drv_vi);

      if(rst_drv_vi==null)begin
         `uvm_fatal("CFGERR", "Virtual Interface for Reset Driver not set");
      end
   endfunction

   virtual task run_phase(input uvm_phase phase);
      `uvm_info(" RESET DRIVER CLASS", "HIERARCHY: %m", UVM_HIGH);

      forever begin
         seq_item_port.get_next_item(req);
         `uvm_info("Reset DRIVER run_phase()", req.sprint(), UVM_HIGH);

         @(posedge rst_drv_vi.drv_cb);   
         rst_drv_vi.reset_156m25_n   <= req.reset_n;
         rst_drv_vi.wb_rst_i         <= !req.reset_n;
         rst_drv_vi.reset_xgmii_rx_n <= req.reset_n;
         rst_drv_vi.reset_xgmii_tx_n <= req.reset_n;
         
         repeat(req.cycles)@(rst_drv_vi.drv_cb);
         seq_item_port.item_done();
      end
      
   endtask

endclass

`endif //RESET_DRIVER__SV
