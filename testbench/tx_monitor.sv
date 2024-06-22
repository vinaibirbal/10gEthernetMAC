`ifndef	TX_MONITOR_SV
`define	TX_MONITOR_SV
`include "packet_sequence.sv"



class tx_monitor extends uvm_monitor;

    `uvm_component_utils(tx_monitor)

    virtual xge_mac_interface    tx_mon_mi;
    uvm_analysis_port#(packet)  tx_mon_ap;
    int unsigned                num_pkt;

    function new(input string name="tx_monitor", input uvm_component parent);
        super.new(name, parent);
    endfunction

   virtual function void build_phase(input uvm_phase phase);
      //`uvm_info("tx_monitor", "HIERACY:%m", UVM_HIGH);
      super.build_phase(phase);

      num_pkt = 0;
      tx_mon_ap = new("tx_mon_ap",this);
      uvm_config_db#(virtual router_interface)::get(this,"","tx_mon_mi",tx_mon_mi);

      if(tx_mon_mi==null)begin
         `uvm_fatal("CFGERR", "Virtual Interface for mi not set");
      end

   endfunction

   virtual task run_phase(input uvm_phase phase);
     // `uvm_info("tx_monitor run phase", "HIERARCHY: %m", UVM_HIGH);

    packet rcvpkt;
    bit pkt_in_progress = 0;
    bit pkt_caputured = 0;
    int index = 0;
 

    tx_mon_mi.mon_cb.pkt_tx_ren <= 1'b0;

  
    forever begin
      @(tx_mon_mi.mon_cb)
      begin
        if(tx_mon_mi.mon_cb.pkt_tx_avail)begin
         tx.mon_cb.pkt_tx_ren <= 1'b1;
        end

        if(tx_mon_mi.mon_cb.pkt_tx_val)begin

          //sop asserted
          if(tx.mon_cb.pkt_tx_sop && !tx_mon_mi.mon_cb.pkt_tx_eop && pkt_in_progress==0 )begin
            rcvpkt=packet::type_id::create("rcvpkt", this);
            pkt_in_progress = 1;
           tx.mon_cb.pkt_rx_ren <= 1'b1;

            rcv_pkt.pkt_status[7]       = mon_vi.mon_cb.pkt_tx_sop;
            rcv_pkt.pkt_status[4]       = mon_vi.mon_cb.pkt_tx_avail;
            rcv_pkt.pkt_status[3]       = mon_vi.mon_cb.pkt_tx_val;
            rcv_pkt.pkt_status[2:0]     = mon_vi.mon_cb.pkt_tx_mod;
            rcv_pkt.pkt_data[0]         = mon_vi.mon_cb.pkt_tx_data;
          end
          //sop deasserted
          if( !tx_mon_mi.mon_cb.pkt_tx_sop && !tx_mon_mi.mon_cb.pkt_tx_eop && pkt_in_progress==1 )begin
            rcvpkt=packet::type_id::create("rcvpkt", this);
            pkt_in_progress = 1;
            index ++;
            tx.mon_cb.pkt_tx_ren <= 1'b1;
            rcv_pkt.pkt_status[2:0]     = mon_vi.mon_cb.pkt_tx_mod;
            rcv_pkt.pkt_data[index]     = mon_vi.mon_cb.pkt_tx_data;
         end
            ///eop asserted
          if( !tx_mon_mi.mon_cb.pkt_tx_sop &&tx_mon_cb.pkt_tx_eop && pkt_in_progress==1 )begin
            rcvpkt=packet::type_id::create("rcvpkt", this);
            pkt_in_progress = 0;
            index++;
            tx.mon_cb.pkt_tx_ren <= 1'b0;

            rcv_pkt.pkt_status[6]       = mon_vi.mon_cb.pkt_tx_eop;
            rcv_pkt.pkt_status[5]       = mon_vi.mon_cb.pkt_tx_err;
            rcv_pkt.pkt_status[2:0]     = mon_vi.mon_cb.pkt_tx_mod;
            rcv_pkt.pkt_data[index]     = mon_vi.mon_cb.pkt_tx_data;

            pkt_caputured = 1;
          end

          //packet with one trans
          if(tx_mon_cb.pkt_tx_sop &&tx_mon_cb.pkt_tx_eop && pkt_in_progress==0 )begin
            rcvpkt=packet::type_id::create("rcvpkt", this);

           tx.mon_cb.pkt_tx_ren <= 1'b1;

            rcv_pkt.pkt_status[7]       = mon_vi.mon_cb.pkt_tx_sop;
            rcv_pkt.pkt_status[6]       = mon_vi.mon_cb.pkt_tx_eop;
            rcv_pkt.pkt_status[5]       = mon_vi.mon_cb.pkt_tx_err;
            rcv_pkt.pkt_status[4]       = mon_vi.mon_cb.pkt_tx_avail;
            rcv_pkt.pkt_status[3]       = mon_vi.mon_cb.pkt_tx_val;
            rcv_pkt.pkt_status[2:0]     = mon_vi.mon_cb.pkt_tx_mod;
            rcv_pkt.pkt_data[0]         = mon_vi.mon_cb.pkt_tx_data;

            pkt_caputured = 1;

          end

          if( packet_captured )begin
            `uvm_info("Content of rcvpkt is", rcvpkt.sprint(), UVM_HIGH);
            //Display # of packets received
            `uvm_info("Got_Output_Packet", {"\n", rcvpkt.sprint()}, UVM_MEDIUM);
            if ( !rcv_pkt.pkt_status[5] && rrcv_pkt.pkt_status[7] && rcv_pkt.pkt_status[6] ) begin
              ap_rx_mon.write( rcv_pkt );
              num_pkt++;
            end
            packet_captured = 0;
          end
        end
      end
    end
  endtask

  function void report_phase( uvm_phase phase );

    `uvm_info( get_name( ), $sformatf( "TX Monitor Captured: %0d packets",num_pkt ), UVM_LOW )

  endfunction : report_phase

endclass

`endif //tx monitor

