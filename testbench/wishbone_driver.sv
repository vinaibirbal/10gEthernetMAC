`ifndef	WISHBONE_DRIVER__SV
`define	WISHBONE_DRIVER__SV
`include "wishbone_sequence.sv"
`include "wishbone_item.sv"

class wishbone_driver extends uvm_driver #(wishbone_item);
   `uvm_component_utils(wishbone_driver)

   virtual xge_mac_interface wb_drv_vi;

   function new(input string name="WISHBONE_DRIVER", input uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(input uvm_phase phase);
      `uvm_info("WISHBONE DRIVER CLASS", "HIERACY:%m", UVM_HIGH);
      super.build_phase(phase);
      uvm_config_db#(virtual router_interface)::get(this,"","wb_drv_vi",wb_drv_vi);

      if(wb_drv_vi==null)begin
         `uvm_fatal("CFGERR", "Virtual Interface for Driver not set");
      end
   endfunction

   virtual task run_phase(input uvm_phase phase);
      //`uvm_info("DRIVER CLASS", "HIERARCHY: %m", UVM_HIGH);

      forever begin
      seq_item_port.try_next_item(req);
      if ( req == null ) begin
        // idle
         @(wb_drv_vi.drv_cb);
         wb_drv_vi.drv_cb.wb_adr_i  <= $urandom_range(255,0);
         wb_drv_vi.drv_cb.wb_clk_i  <= 1'b0;
         wb_drv_vi.drv_cb.wb_dat_i  <= $urandom;
         wb_drv_vi.drv_cb.wb_stb_i  <= 1'b0;
         wb_drv_vi.drv_cb.wb_we_i   <= 1'b0;
      end
      else begin
        `uvm_info( get_name(), $psprintf("Content of Wishbone Trans is: \n%0s", req.sprint()), UVM_HIGH)
         @(wb_drv_vi.drv_cb);
         wb_drv_vi.drv_cb.wb_adr_i  <= req.wb_addr;
         wb_drv_vi.drv_cb.wb_clk_i  <= 1'b1;
         wb_drv_vi.drv_cb.wb_dat_i  <= 1'b1;
         wb_drv_vi.drv_cb.wb_stb_i  <= req.wb_data;
         wb_drv_vi.drv_cb.wb_we_i   <= req.write_en;

        repeat (10) begin//wait for change in reg
         @(wb_drv_vi.drv_cb);
         wb_drv_vi.drv_cb.wb_adr_i  <= $urandom_range(255,0);
         wb_drv_vi.drv_cb.wb_clk_i  <= 1'b0;
         wb_drv_vi.drv_cb.wb_dat_i  <= $urandom;
         wb_drv_vi.drv_cb.wb_stb_i  <= 1'b0;
         wb_drv_vi.drv_cb.wb_we_i   <= 1'b0;

        end
        seq_item_port.item_done();
      end
    end
  endtask
endclass

`endif //DRIVER__SV
