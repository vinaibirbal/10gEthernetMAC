`ifndef WISHBONE_SEQUENCE_SV
`define WISHBONE_SEQUENCE_SV
`include "wishbone_item.sv"



class wishbone_sequence extends uvm_sequence #(wishbone_item);

   `uvm_object_utils(wishbone_sequence)

   int num_packets = 1;

   function new(input string name = "wishbone_sequence");
      super.new(name);
      `uvm_info("Wishbone_Sequence Class", $sformatf("Hierarchy:%m"),UVM_HIGH);
   endfunction

    //method 2 if not using seq.start()
   virtual task pre_start();
      super.pre_start();
   // if ( starting_phase != null )
   //   starting_phase.raise_objection( this );
    uvm_config_db #(int)::get(null, get_full_name(), "num_packets", num_packets);
  endtask 

   virtual task body();
      // Write to the Configuration register TX Enable to enable transmission of frames
    //`uvm_do_with(req, { wb_addr==8'h00; wb_data==32'h1;write_en ==1'b1; } );
    // Write to the Interrupt Mark register to enable all the interrupts
    //`uvm_do_with(req, {  wb_addr==8'h10; wb_data==32'hFFFF_FFFF;write_en ==1'b1; } );
    repeat(num_packets)`uvm_do(req); //do read or write

   endtask

   virtual task post_start();
      super.post_start();
   // if  ( starting_phase != null )
   //   starting_phase.drop_objection( this );
  endtask 


endclass
`endif //wishbone_sequence_SV
