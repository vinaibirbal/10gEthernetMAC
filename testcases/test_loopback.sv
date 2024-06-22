`ifndef TEST_LOOPBACK_SV
`define TEST_LOOPBACK_SV


class test_loopback extends test_base;

    `uvm_component_utils(test_loopback)

    function new(input string name ="Loop Back Test", input uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(input uvm_phase phase);

        super.build_phase(phase);
        `uvm_info("TEST Loop Back", $sformatf("HIERARCHY:%m"),UVM_HIGH);
        //set_inst_override_by_type("envo.agent_in.seqr.*",packet::get_type(), packet_small::get_type())
    endfunction

endclass

`endif//TEST_LOOPBACK_SV
