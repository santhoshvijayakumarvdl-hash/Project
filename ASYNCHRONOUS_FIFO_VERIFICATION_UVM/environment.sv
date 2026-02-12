import uvm_pkg::*;
`include "uvm_macros.svh"

//factory registration
class environment extends uvm_env;
  `uvm_component_utils(environment)
    
   //object creation
  agent agt;
  scoreboard scb;
  my_cov cov;
  
 

   //default constructor
  function new(string name = "agent",uvm_component parent=null);
    super.new(name,parent);
   
  endfunction
  
//phases
    
    //BUILD_PHASE
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      agt=agent::type_id::create("agt",this);
      scb=scoreboard::type_id::create("scb",this);
      cov=my_cov::type_id::create("cov",this);
    endfunction
      
      //CONNECT_PHASE
      function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      
        agt.mon.mon_ap.connect(scb.scb_port);
        agt.mon.mon_ap.connect(cov.analysis_export); 
    endfunction  
endclass

