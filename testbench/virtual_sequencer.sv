`ifndef VIRTUAL_SEQUENCER_SV
`define VIRTUAL_SEQUENCER_SV
//`include "env.sv"
//`include "reset_agent.sv"
//`include "tx_agent.sv"
//`include "wishbone_agent.sv"

class virtual_sequencer extends uvm_sequencer;
    `uvm_component_utils(virtual_sequencer);

    reset_sequencer     seqr_rst;
    packet_sequencer    seqr_pkt;
    wishbone_sequencer  seqr_wb;

    function new(input string name, input uvm_component parent);
        super.new(name,parent);
    endfunction

endclass

`endif//virtual sequencer
