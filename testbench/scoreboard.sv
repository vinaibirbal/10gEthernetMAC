`ifndef SCOREBOARD__SV
`define SCOREBOARD__SV
`include "packet.sv"

typedef uvm_in_order_class_comparator#(packet) packet_comparator;

class scoreboard extends uvm_scoreboard;
    

    packet_comparator   comparator;

    uvm_analysis_export#(packet)    from_agent_tx;
    uvm_analysis_export#(packet)    from_agent_rx;


   `uvm_component_utils(scoreboard)

    function new(input string name = "scoreboard", input uvm_component parent);
      super.new(name, parent);
    endfunction

    virtual function void build_phase(input uvm_phase phase);
    
        super.build_phase(phase);

        comparator      = packet_comparator::type_id::create("comparator",this);
        from_agent_tx  = new("from_agent_tx",this);
        from_agent_rx  = new("from_agent_rx",this);
    endfunction

    virtual function void connect_phase(input uvm_phase phase);

        super.connect_phase(phase);

        
        this.from_agent_tx.connect(comparator.before_export);
        this.from_agent_rx.connect(comparator.after_export);

    endfunction

    virtual function void report_phase(input uvm_phase phase);

        `uvm_info("SCOREBOARDCLASS report_phase", "Hierarchy:%m",UVM_HIGH);

        `uvm_info("Scoreboard Report:",
        $sformatf("Number of Packet Matches=%od, Number of Packet Mismatches=%0d",
        comparator.m_matches,comparator.m_mismatches), UVM_HIGH);

        if(comparator.m_mismatches !=0)begin
            `uvm_fatal("TEST FAIL", "PACKET MISMATCHES!");
        end
        else begin
            `uvm_info("TEST PASS", $sformatf("PACKET COMPARE SUCCESSFULL"),UVM_HIGH);
        end

    endfunction

endclass
`endif //SCOREBOARD_SV
