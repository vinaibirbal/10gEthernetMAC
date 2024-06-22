`ifndef RESET_SEQUENCE__SV
`define RESET_SEQUENCE__SV
`include "reset_item.sv"


class reset_sequence extends uvm_sequence#(reset_item);

   `uvm_object_utils(reset_sequence)

   function new(input string name = "reset_sequence");
      super.new(name);
      `uvm_info("RESET_SEQUENCE CLASS", $sformatf("Hierarchy:%m"),UVM_HIGH);
   endfunction

   //if using method 2 db config
   //virtual task pre_start();
   //   super.pre_start();
   // if ( starting_phase != null )
   //   starting_phase.raise_objection( this );
  //endtask

   virtual task body();

      `uvm_do_with(req,{reset_n==1; cycles==1;});
      `uvm_do_with(req,{reset_n==0; cycles==1;});
      `uvm_do_with(req,{reset_n==1; cycles==1;});
   endtask

   //if using methid 2 db config
   //virtual task post_start();
   // super.post_start();
   // if  ( starting_phase != null )
   //   starting_phase.drop_objection( this );
  //endtask 

endclass
`endif //PACKET_SEQUENCE__SV
