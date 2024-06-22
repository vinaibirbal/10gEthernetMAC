`ifndef TEST_LARGE_PACKET__SV
`define TEST_LARGE_PACKET__SV
//`include "packet_sequence.sv"
//`include "env.sv"


class test_large_packet extends test_base;

    `uvm_component_utils(test_large_packet)

    function new(input string name ="Large Packet", input uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(input uvm_phase phase);

        super.build_phase(phase);
        `uvm_info("TEST Large packet", $sformatf("HIERARCHY:%m"),UVM_HIGH);
        set_inst_override_by_type("envo.tx_agent.tx_seqr.*",packet::get_type(), packet_large::get_type()); //replace one instance
        
        //set_inst_override_by_type("envo.agent_in.mon.*",packet::get_type(), packet_small::get_type()); //replace imonitor
        //set_inst_override_by_type("envo.agent_out.mon.*",packet::get_type(), packet_small::get_type()); //replace omonitor
        //set_type_override_by_type(packet::get_type(), packet_small::get_type()); //replace everywhere
    
    endfunction
endclass

`endif//large_packet
