`ifndef RESET_ITEM__SV
`define RESET_ITEM__SV

class reset_item extends uvm_sequence_item;

   rand bit reset_n;
   rand bit cycles;

   `uvm_object_utils_begin(reset_item)
      `uvm_field_int(reset_n, UVM_ALL_ON)
      `uvm_field_int(cycles, UVM_ALL_ON)
   `uvm_object_utils_end

   constraint valid_size {
      cycles inside {[10:40]};
   }

   function new(input string name = "reset_item");
      super.new(name);
      `uvm_info("RESET ITEM", $sformatf("Hierarchy:%m"),UVM_HIGH);
   endfunction

endclass

`endif //RESET_ITEM__SV
