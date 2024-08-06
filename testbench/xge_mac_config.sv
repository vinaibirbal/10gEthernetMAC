`ifndef XGE_MAC_CONFIG__SV
`define XGE_MAC_CONFIG__SV

class xge_mac_config extends uvm_object;
   `uvm_object_utils(xge_mac_config)

   // Testbench parameters
   int num_packets = 1000;
   int min_packet_size = 64;
   int max_packet_size = 1518;
   
   // DUT configuration
   bit [47:0] mac_address = 48'h001122334455;
   bit promiscuous_mode = 0;
   int max_frame_size = 1518;

   // Timing parameters
   int ifg_delay = 12; // Inter-frame gap in clock cycles

   function new(string name = "xge_mac_config");
      super.new(name);
   endfunction

   function void post_randomize();
      // Add any post-randomization checks or modifications here
   endfunction

endclass

`endif //XGE_MAC_CONFIG__SV
Last edited 1