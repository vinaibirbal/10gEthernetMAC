`ifndef PACKET__SV
`define PACKET__SV

class packet extends uvm_sequence_item;

   //rand bit [7:0] pkt_status[];
   rand bit [63:0] pkt_data [];

   `uvm_object_utils_begin(packet)
      //`uvm_field_int_array( pkt_status, UVM_ALL_ON|UVM_NOPACT)
      `uvm_field_arrary_int( pkt_data , UVM_ALL_ON|UVM_NOPACT)
   `uvm_object_utils_end


//status ports
//[2:0] - pkt modulus
//[4:3] - unused- [3] pkt_val, [4] pkt_avail
//[5] - error detection (err)
//[6] - EOP
//[7] - SOP

   //change these bits to 1 to generate error packets in drivers
   rand bit eop_error_flag;
   rand bit sop_error_flag;
   rand bit overflow_error_flag;
   rand bit underflow_error_flag ;


   constraint valid_size {
      pkt_data.size() inside {[60:1518]};//6 bytes MAC destination + 6 bytes MAC Scoure + 2 bytes length + 46-1500 bytes payload
      //pkt_status.size()== pkt_data.size() ;
   }

  // constraint eop_sop{ /// eop and sop not asserted at the same time
   //   pkt_status[7] == 1'b1 && pkt_status[6] == 1'b0;
   //   pkt_status[7] == 1'b0 && pkt_status[6] == 1'b1;
  //    pkt_status[7] == 1'b0 && pkt_status[6] == 1'b0;

  // }

   function new(input string name = "Packet");
      super.new(name);
      `uvm_info("PACKET CLASS", $sformatf("Hierarchy:%m"),UVM_HIGH);
   endfunction

endclass



class packet_large extends packet;

    `uvm_object_utils(packet_large)

    constraint large_packet{
      pkt_data.size() inside {[1518:3000]}; // packet larger than 1500 bytes
     // pkt_status.size()== pkt_data.size() ;
    }

    function new(input string name="PacketLarge");
     super.new(name);
     `uvm_info("Large_Packet Class", $sformatf("HIERACY:%m"), UVM_HIGH);
    endfunction

endclass




class packet_small extends packet;

    `uvm_object_utils(packet_small)

    constraint small_packet{
      pkt_data.size() inside {[1:45]}; //packet less than 64 bytes
      //pkt_status.size()== pkt_data.size() ;
   }

    function new(input string name="PacketSmall");
     super.new(name);
     `uvm_info("Small_Packet Class", $sformatf("HIERACY:%m"), UVM_HIGH);
    endfunction

endclass


`endif // PACKET__SV
