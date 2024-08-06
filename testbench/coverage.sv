`ifndef	COVERAGE__SV
`define	COVERAGE__SV
`include "packet.sv"


class coverage extends uvm_subcriber#(packet);
    `uvm_component_utils(coverage)
    
    uvm_analysis_export #(packet) analysis_export;

    packet covpacket;

    covergroup pkt_cov;

        pkt_size: coverpoint covpacket.pkt_data.size(){
            bins small_packet = {[46:62]};
            bins regular_packet = {[63:300]};;
            bins large_packet = {[301:1500]};;
        }

         // Add coverpoints here
        cp_packet_type: coverpoint packet.type {
           bins ethernet = {ETHERNET};
           bins ipv4 = {IPV4};
           bins ipv6 = {IPV6};
      }
        cp_packet_length: coverpoint packet.length {
           bins small = {[0:63]};
           bins medium = {[64:1000]};
           bins large = {[1001:1518]};
           bins jumbo = {[1519:$]};
      }
      // Add more coverpoints as needed
    endgroup

    function new (input string name="coverage", input uvm_component parent);
        super.new(name,parent);
        pkt_cov =new();
    endfunction

    function void build_phase(input uvm_phase phase);
        super.build_phase(phase);
        covpacket = new();
    endfunction

    function void write(input packet pkt_from_agent_out);
        collect_packet(pkt_from_agent_out);
    endfunction

    task collect_packet(input packet pkt);
        static int pktcount;
        pktcount++;

        this.covpacket=pkt;
        pkt_cov.sample();
        $display("COVERAGE: Current Packet Count =%od, Current Coverage = %f%%", pktcount, $get_coverage());
    endtask
endclass

`endif //COVERAGE
