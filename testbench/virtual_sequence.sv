`ifndef VIRTUAL_SEQUENCE_SV
`define VIRTUAL_SEQUENCE_SV
`include "virtual_sequencer.sv"
`include "reset_sequence.sv"
`include "packet_sequence.sv"
`include "wishbone_sequence.sv"


class virtual_sequence extends uvm_sequence;
    `uvm_object_utils(virtual_sequence)

    `uvm_declare_p_sequencer(virtual_sequencer)
    reset_sequence     seq_rst;
    packet_sequence    seq_pkt;
    wishbone_sequence  seq_wb;

    function new(input string name);
        super.new(name);
    endfunction

    virtual task pre_start();
        super.prestart();
        `uvm_info("VIRTUAL_SEQUENCE CLASS pre_start()",
        $sformat("HIERACY:%m"),UVM_HIGH);

        if((get_parent_sequence()==null)&&(starting_phase != null))
        begin
            starting_phase.raise_objection(this);
        end
    endtask

    virtual task body();
    fork
        `uvm_do_on(seq_rst, p_sequencer.seqr_rst);
        `uvm_do_on(seq_pkt, p_sequencer.seqr_pkt); 
        `uvm_do_on(seq_wb, p_sequencer.seqr_wb);       
    join
    endtask

    virtual task post_start();
        super.post_start();
        `uvm_info("VIRTUAL_SEQUENCE CLASS post_start()",
        $sformat("HIERACY:%m"),UVM_HIGH);

        if((get_parent_sequence()==null)&&(starting_phase != null))
        begin
            starting_phase.drop_objection(this);
        end
    endtask

endclass

`endif//virtual sequence
