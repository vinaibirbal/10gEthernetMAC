`ifndef	PACKET_RX_MONITOR__SV
`define	PACKET_RX_MONITOR__SV
//`include "packet_sequence.sv"
//`include "xge_mac_interface.sv"
`include "packet.sv"



class rx_monitor extends uvm_monitor;

  `uvm_component_utils(rx_monitor)

  virtual xge_mac_interface    rx_mon_mi;
  uvm_analysis_port#(packet)  rx_mon_ap;
  int unsigned                 num_pkt;
  //packet rcvpkt;
 
  function new(input string name="rx_monitor", input uvm_component parent);
      super.new(name, parent);
  endfunction

  virtual function void build_phase(input uvm_phase phase);
    //`uvm_info("rx_monitor", "HIERACY:%m", UVM_HIGH);
    super.build_phase(phase);

    rx_mon_ap = new("rx_mon_ap",this);
    uvm_config_db#(virtual xge_mac_interface)::get(this,"","rx_mon_mi",rx_mon_mi);
    num_pkt = 0;

    if(rx_mon_mi==null)begin
      `uvm_fatal("CFGERR", "Virtual Interface for rx monitor not set");
    end

  endfunction

  virtual task run_phase(input uvm_phase phase);
    //`uvm_info("rx_monitor run phase", "HIERARCHY: %m", UVM_HIGH);

    packet rcvpkt;
    bit pkt_in_progress = 0;
    bit pkt_caputured = 0;
    int index = 0;
 

    rx_mon_mi.mon_cb.pkt_rx_ren <= 1'b0;

  
    forever begin
      @(rx_mon_mi.mon_cb)
      begin
        if(rx_mon_mi.mon_cb.pkt_rx_avail)begin
          rx_mon_mi.mon_cb.pkt_rx_ren <= 1'b1;
        end

        if(rx_mon_mi.mon_cb.pkt_rx_val)begin

          //sop asserted
          if( rx_mon_mi.mon_cb.pkt_rx_sop && !rx_mon_mi.mon_cb.pkt_rx_eop && pkt_in_progress==0 )begin
            rcvpkt = packet::type_id::create("rcvpkt", this);
            pkt_in_progress = 1;
            rx_mon_mi.mon_cb.pkt_rx_ren <= 1'b1;

            rcv_pkt.pkt_data[0]         = mon_vi.mon_cb.pkt_rx_data;

          end
          //sop deasserted
          if( !rx_mon_mi.mon_cb.pkt_rx_sop && !rx_mon_mi.mon_cb.pkt_rx_eop && pkt_in_progress==1 )begin
            rcvpkt=packet::type_id::create("rcvpkt", this);
            pkt_in_progress = 1;
            index ++;
            rx_mon_mi.mon_cb.pkt_rx_ren <= 1'b1;

            rcv_pkt.pkt_data[index]     = mon_vi.mon_cb.pkt_rx_data;

         end
            ///eop asserted
          if( !rx_mon_mi.mon_cb.pkt_rx_sop && rx_mon_mi.mon_cb.pkt_rx_eop && pkt_in_progress==1 )begin
            rcvpkt=packet::type_id::create("rcvpkt", this);
            pkt_in_progress = 0;
            index++;
            rx_mon_mi.mon_cb.pkt_rx_ren <= 1'b0;

            rcv_pkt.pkt_data[index]     = mon_vi.mon_cb.pkt_rx_data;

            pkt_caputured = 1;
          end

          //packet with one trans
          if( rx_mon_mi.mon_cb.pkt_rx_sop && rx_mon_mi.mon_cb.pkt_rx_eop && pkt_in_progress==0 )begin
            rcvpkt=packet::type_id::create("rcvpkt", this);

            rx_mon_mi.mon_cb.pkt_rx_ren <= 1'b1;

            rcv_pkt.pkt_data[0]     = mon_vi.mon_cb.pkt_rx_data;

            pkt_caputured = 1;

          end

          if( pkt_captured )begin
            `uvm_info("Content of rcvpkt is", rcvpkt.sprint(), UVM_HIGH);
            //Display # of packets received
            `uvm_info("Got_Output_Packet", {"\n", rcvpkt.sprint()}, UVM_MEDIUM);
            if ( !rcv_pkt.pkt_status[5] && rcv_pkt.pkt_status[7] && rcv_pkt.pkt_status[6] ) begin
              ap_rx_mon.write( rcv_pkt );
              num_pkt++;
            end
            pkt_captured = 0;
          end
        end
      end
    end
  endtask

  function void report_phase( uvm_phase phase );
    `uvm_info( get_name( ), $sformatf( "RX Monitor Captured: %0d packets",num_pkt ), UVM_LOW )
  endfunction

endclass

`endif //rx monitor

