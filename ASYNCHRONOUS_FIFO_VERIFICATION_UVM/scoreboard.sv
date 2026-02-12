import uvm_pkg::*;
`include "uvm_macros.svh"


//factory registration
class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  //queue
  bit[7:0] expected_queue[$];
  bit[7:0] expected_item;

  

  
  
  //import creation
  uvm_analysis_imp #(seq_item, scoreboard) scb_port;
 

   //default constructor
  function new(string name = "scoreboard",uvm_component parent=null);
    super.new(name,parent);
    scb_port=new("scb_port",this);
   endfunction
  
//phases
    
    //BUILD_PHASE
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction
  
  
  //writing items 
  function void write(seq_item scb_item);

    if(scb_item.w_en)
      expected_queue.push_back(scb_item.data_in);
    
    
    if(scb_item.r_en) begin
      expected_item=expected_queue.pop_front();
      if(expected_item==scb_item.data_out) 
      
        `uvm_info(get_type_name(),$sformatf("matched din=%d,wrst_n=%d,w_en=%d,r_en=%d,dout=%d",scb_item.data_in,scb_item.wrst_n,scb_item.w_en,scb_item.r_en,scb_item.data_out),UVM_MEDIUM)
            
        else `uvm_info(get_type_name(),$sformatf("mismatched din=%d,wrst_n=%d,w_en=%d,r_en=%d,dout=%d",scb_item.data_in,scb_item.wrst_n,scb_item.w_en,scb_item.r_en,scb_item.data_out),UVM_MEDIUM)
        end
        
            endfunction
      
      
endclass

