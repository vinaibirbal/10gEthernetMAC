class xgmii_packet extends uvm_sequence_item;

  
   //`uvm_object_utils(packet)
   `uvm_object_utils_begin(xgmii_packet)
      `uvm_field_int(src_addr, UVM_ALL_ON|UVM_NOPACK);
      `uvm_field_arrary_int(src_data, UVM_ALL_ON|UVM_NOPACK);
      `uvm_field_int(dst_addr, UVM_ALL_ON|UVM_NOPACK);
      `uvm_field_arrary_int(dst_data, UVM_ALL_ON|UVM_NOPACK);
   `uvm_object_utils_end

   rand bit [7:0] dst_status;
   rand bit [63:0] dst_data[];
   rand bit [7:0] src_status;
   rand bit [63:0] src_data[];


   constraint valid size {
      payload.size() inside {[1:256]};
   }

   function new(input string name = "XGMII_Packet");
      super.new(name);
      `uvm_info("XGMII_PACKET CLASS", $sformatf("Hierarchy:%m"),UVM_HIGH);
   endfunction

endclass