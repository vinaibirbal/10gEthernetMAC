`ifndef	TX_DRIVER__SV
`define	TX_DRIVER__SV
`include "packet_sequence.sv"


class tx_driver extends uvm_driver #(packet);
   `uvm_component_utils(tx_driver)

   virtual xge_mac_interface tx_drv_vi;

   function new(input string name="TX_Driver", input uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(input uvm_phase phase);
      `uvm_info("TX_DRIVER_CLASS", "HIERACY:%m", UVM_HIGH);
      super.build_phase(phase);

      uvm_config_db#(virtual router_interface)::get(this,"","tx_drv_vi",tx_drv_vi);

      if(tx_drv_vi==null)begin
         `uvm_fatal("CFGERR", "Virtual Interface for Driver not set");
      end
   endfunction

   virtual task run_phase(input uvm_phase phase);
      //`uvm_info("TX DRIVER CLASS", "HIERARCHY: %m", UVM_HIGH);

      int unsigned len_data; //length of data arrary

      forever begin
         `uvm_info("TX DRIVER run_phase()", req.sprint(), UVM_HIGH);
         seq_item_port.try_next_item(req);
        if ( req == null ) begin
        // idle
            @(tx_drv_vi.drv_cb);
            tx_drv_vi.drv_cb.pkt_tx_val    <= 1'b0;
            tx_drv_vi.drv_cb.pkt_tx_sop    <= $urandom_range(1,0);
            tx_drv_vi.drv_cb.pkt_tx_eop    <= $urandom_range(1,0);
            tx_drv_vi.drv_cb.pkt_tx_mod    <= $urandom_range(7,0);
            tx_drv_vi.drv_cb.pkt_tx_data   <= { $urandom, $urandom};
         end
         else begin
         `uvm_info( get_name(), $psprintf("Content of TX Packet is: \n%0s", req.sprint()), UVM_HIGH);
         len_data = req.pkt_data.size();
         for ( int i=0; i<len_data; i++ ) begin
            @(tx_drv_vi.drv_cb);
            if(i ==0)begin //sop
               tx_drv_vi.drv_cb.pkt_tx_val  <= 1'b1;
               tx_drv_vi.drv_cb.pkt_tx_sop  <= 1'b1;
               tx_drv_vi.drv_cb.pkt_tx_eop  <= 1'b0;
               tx_drv_vi.drv_cb.pkt_tx_mod  <= $urandom_range(7,0);
               tx_drv_vi.drv_cb.pkt_tx_data <= req.pkt_data[i];
            end
            else if(i == len_data -1)begin //eop
               tx_drv_vi.drv_cb.pkt_tx_val  <= 1'b1;
               tx_drv_vi.drv_cb.pkt_tx_sop  <= 1'b0;
               tx_drv_vi.drv_cb.pkt_tx_eop  <= 1'b1;
               tx_drv_vi.drv_cb.pkt_tx_mod  <=$urandom_range(7,0);
               tx_drv_vi.drv_cb.pkt_tx_data <= req.pkt_data[i];
            end

            else begin //in progress
               tx_drv_vi.drv_cb.pkt_tx_val  <= 1'b1;
               tx_drv_vi.drv_cb.pkt_tx_sop  <= 1'b0;
               tx_drv_vi.drv_cb.pkt_tx_eop  <= 1'b0;
               tx_drv_vi.drv_cb.pkt_tx_mod  <= $urandom_range(7,0);
               tx_drv_vi.drv_cb.pkt_tx_data <= req.pkt_data[i];
            end
         end                   
          
         while ( tx_drv_vi.drv_cb.pkt_tx_full ) begin
          //stop transfers when tx_FIFO is full
            @(tx_drv_vi.drv_clk);
            tx_drv_vi.drv_cb.pkt_tx_val    <= 1'b0;
            tx_drv_vi.drv_cb.pkt_tx_sop    <= $urandom_range(1,0);
            tx_drv_vi.drv_cb.pkt_tx_eop    <= $urandom_range(1,0);
            tx_drv_vi.drv_cb.pkt_tx_mod    <= $urandom_range(7,0);
            tx_drv_vi.drv_cb.pkt_tx_data   <= { $urandom, $urandom };
         end
        // trans done
        seq_item_port.item_done();
      end
    end
  endtask 

endclass

`endif //TX_DRIVER__SV
