`ifndef PACKET_SEQUENCE__SV
`define PACKET_SEQUENCE__SV
`include "packet.sv"



class packet_sequence extends uvm_sequence #(packet);
   

   `uvm_object_utils(packet_sequence)
   
   int num_packets = 1;

   function new(input string name = "packet_sequence");
      super.new(name);
      `uvm_info("PACKET_SEQUENCE CLASS", $sformatf("Hierarchy:%m"),UVM_HIGH);
   endfunction

   //method 2 if not using seq.start()
   virtual task pre_start();
      super.pre_start();
   // if ( starting_phase != null )
   //   starting_phase.raise_objection( this );
      uvm_config_db #(int)::get(null, get_full_name(), "num_packets", num_packets);
  endtask 

   virtual task body();
      repeat(num_packets)`uvm_do(req);
   endtask

   virtual task post_start();
      super.post_start();
   // if  ( starting_phase != null )
   //   starting_phase.drop_objection( this );
  endtask 


endclass
`endif //PACKET_SEQUENCE__SV
