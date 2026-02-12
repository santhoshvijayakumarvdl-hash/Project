import uvm_pkg::*;
`include "uvm_macros.svh"

//factory registration
class agent extends uvm_agent;
  `uvm_component_utils(agent)
    
   //object creation
  monitor mon;
  driver drv;
  sequencer seqr;
  
  // analysis port
  uvm_analysis_port #(seq_item) mon_ap;

   //default constructor
  function new(string name = "agent",uvm_component parent=null);
    super.new(name,parent);
   
  endfunction
  
//phases
    
    //BUILD_PHASE
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      mon=monitor::type_id::create("mon",this);
      drv=driver::type_id::create("drv",this);
      seqr=sequencer::type_id::create("seq",this);
    endfunction
      
      //CONNECT_PHASE
      function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction  
endclass

