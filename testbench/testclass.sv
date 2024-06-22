`ifndef TESTCLASS__SV
`define TESTCLASS__SV
`include "env.sv"
`include "packet_sequence.sv"
`include "reset_sequence.sv"
`include "wishbone_sequence.sv"
`include "virtual_sequencer.sv"
`include "virtual_sequence.sv"

class test_base extends uvm_test;

  `uvm_component_utils(test_base)
   
  env envo;
  packet_sequence seq;
  packet eth;

  virtual_sequencer v_seqr;
  
  function new(input string name = "test_base", input uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(input uvm_phase);
    super.build_phase(phase);

    //create objects
    envo = env::type_id::create("envo",this);
    v_seqr = virtual_sequencer::type_id::create("v_seqr",this);

    //virtual sequence config
    uvm_config_db#(uvm_object_wrapper)::set(this, "v_seqr.reset_phase",
    "default_sequence", virtual_sequence::get_type());

    //appoach 2: running a sequence using uvm config
    //uvm_config_db#(uvm_object_wrapper)::set(this, "envo.tx_agent.seqr.main_phase",
   // "default_sequence", packet_sequence::get_type()); //method two instead of seq.start()

    // connect virtual interfaces
    //connecting virtual interface "vi" to actual interface "xge_mac_if"
    uvm_config_db#(virtual xge_mac_interface)::set(this, "envo.tx_agent.tx_drv", "tx_drv_vi", xge_mac_tb_top.xge_mac_if);

    //connecting virtual interface "mi" to actual interfacxe "xge_mac_if"
    uvm_config_db#(virtual xge_mac_interface)::set(this, "envo.tx_agent.tx_mon", "tx_mon_mi", xge_mac_tb_top.xge_mac_if);

    //connecting virtual interface "mi" tp actual interface for packet_rx
    uvm_config_db#(virtual xge_mac_interface)::set(this, "envo.rx_agent.rx_mon", "rx_mon_mi", xge_mac_tb_top.xge_mac_if);

    //connecting virtual interface "for reset_driver.sv:agent_rst.drv.vi = xge_mac_tb_top.xge_mac_if
    uvm_config_db#(virtual xge_mac_interface)::set(this, "envo.reset_agent.rst_drv", "rst_drv_vi", xge_mac_tb_top.xge_mac_if);

     //connecting virtual interface "vi" to actual interface "xge_mac_if"
    uvm_config_db#(virtual xge_mac_interface)::set(this, "envo.wb_agent.wb_drv", "wb_drv_vi", xge_mac_tb_top.xge_mac_if);

    //connecting virtual interface "mi" to actual interfacxe "xge_mac_if"
    uvm_config_db#(virtual xge_mac_interface)::set(this, "envo.wb_agent.wb_mon", "wb_mon_mi", xge_mac_tb_top.xge_mac_if);

    //done connection virtual interfaces

    //method 2 run the sequences
   // uvm_config_db #(uvm_object_wrapper)::set(this, "envo.rst_agent.rst_seqr.reset_phase", "default_sequence", reset_sequence::get_type() );
   // uvm_config_db #(uvm_object_wrapper)::set(this, "envo.wb_agent.wb_seqr.configure_phase", "default_sequence", wishbone_init_sequence::get_type() );
    //uvm_config_db #(uvm_object_wrapper)::set(this, "envo.tx_agent.tx_seqr.main_phase", "default_sequence", packet_sequence::get_type() );

    //  Set the number of packets in the sequence 
    //uvm_config_db #(int unsigned)::set(this, "envo.tx_agent.tx_seqr.packet_sequence", "num_packets", 10 );
    

  endfunction

  virtual task run_phase(input uvm_phase phase);

    `uvm_info("TEST_BASE", "I am inside the run_phase()", UVM_HIGH);
    `uvm_info("TEST_BASE", $sformatf("%m"), UVM_HIGH);

    v_seq = virtual_sequence::type_id::create("seq",this);
    phase.raise_objection(this);
    v_seq.start(envo.v_seqr);
    //seq.start(envo.agent_in);
    phase.drop_objection(this);

  endtask

  virtual task main_phase(input uvm_phase phase);
    uvm_objection  drain_time;
    super.main_phase(phase);

    objection = phase.get_objection();
    objection.set_drain_time(this,1us);
  endtask

  virtual function void end_of_elaboration_phase(input uvm_phase phase) ;
   super.end_of_elaboration_phase(phase);
   uvm_top.print_topology();
   factory.print();
  endfunction

 virtual function void start_of_simulation_phase(input uvm_phase phase);
   super.start_of_simulation_phase(phase);
   uvm_top.print_topology();
   factory.print();
  endfunction 

  
 virtual function void connect_phase(input uvm_phase phase);
   super.connect_phase(phase);
   v_seqr.seqr_rst = envo.rst_agent.rst_seqr;
   v_seqr.seqr_tx= envo.tx_agent.tx_seqr;
   v_seqr.seqr_wb= envo.wb_agent.wb_seqr;

  endfunction 
   

endclass

`endif //testbase
