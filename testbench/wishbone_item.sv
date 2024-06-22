`ifndef WISHBONE_ITEM__SV
`define WISHBONE_ITEM__SV

class wishbone_item extends uvm_sequence_item;

   rand bit [7:0] wb_addr;
   rand bit [31:0] wb_data;
   rand bit write_en ; // 0 = read, 1 = writw


   `uvm_object_utils_begin(wishbone_item)
      `uvm_field_int( wb_addr, UVM_ALL_ON|UVM_NOPACK)
      `uvm_field_int(wb_data, UVM_ALL_ON|UVM_NOPACK)
      `uvm_field_int(write_en, UVM_ALL_ON|UVM_NOPACK)
   `uvm_object_utils_end

   //constraint valid size {
    //  wb_data.size() inside {[1:256]};
   //}
   constraint valid_addr {
      wb_addr == 8'h00 ||   // Configuration register 0   
      wb_addr == 8'h08 ||   // Interrupt Pending Register 
      wb_addr == 8'h0C ||   // Interrupt Status Register  
      wb_addr == 8'h10;     // Interrupt Mask Register    
    
   }

   function new(input string name = "WB_ITEMr");
      super.new(name);
      `uvm_info("WB_ITEM CLASS", $sformatf("Hierarchy:%m"),UVM_HIGH);
   endfunction

endclass

`endif  //WISHBONE_ITEM__SV
