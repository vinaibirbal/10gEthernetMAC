`ifndef TEST_SMALL_PACKET__SV
`define  TEST_SMALL_PACKET__SV
//`include "packet_sequence.sv"
//`include "env.sv"


class test_small_packet extends test_base;

    `uvm_component_utils(test_small_packet)

    function new(input string name ="Small Packet Test", input uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(input uvm_phase phase);

        super.build_phase(phase);
        `uvm_info("TEST SMALL PACKET", $sformatf("HIERARCHY:%m"),UVM_HIGH);
        set_inst_override_by_type("envo.tx_agent.tx_seqr.*",packet::get_type(), packet_small::get_type()); //replace one instance
        
        //set_inst_override_by_type("envo.agent_in.mon.*",packet::get_type(), packet_small::get_type()); //replace imonitor
        //set_inst_override_by_type("envo.agent_out.mon.*",packet::get_type(), packet_small::get_type()); //replace omonitor
        //set_type_override_by_type(packet::get_type(), packet_small::get_type()); //replace everywhere
    
    endfunction
endclass

`endif//small packet
