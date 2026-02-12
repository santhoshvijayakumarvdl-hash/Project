import uvm_pkg::*;
`include "uvm_macros.svh" 

//factory registration
class driver extends uvm_driver #(seq_item);
  `uvm_component_utils(driver)
  
  
  //virtual interface
  virtual  add_if vif;
    
   //object creation
    seq_item req;

  //default constructor
  function new(string name = "driver",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
//phases
    
    //BUILD_PHASE
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db #(virtual add_if)::get(this,"","vif",vif))
        `uvm_info(get_type_name(),"build_phase in driver is wrong",UVM_MEDIUM);
    endfunction
      
      //RUN_PHASE
      virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"run_phase in driver is started",UVM_MEDIUM); 
        forever begin
          seq_item_port.get_next_item(req);
          drive_item(req);
          seq_item_port.item_done();
        end
      endtask
      
      task drive_item(input seq_item req);
        
         @(negedge vif.wclk);
       vif.wrst_n<=req.wrst_n;
        vif.rrst_n<=req.rrst_n;
        
        
        
        
          
      
        
        
        if(req.w_en) begin
          if(!vif.full&vif.wrst_n) begin
        @(negedge vif.wclk);
        vif.w_en<=req.w_en;
        vif.data_in<=req.data_in;
           
            #1;
            @(negedge vif.wclk);
            vif.w_en<=0;
          end
        end

            if(req.r_en) begin
              
              if(!vif.empty&vif.rrst_n) begin
                
        @(negedge vif.rclk);
           begin
        vif.r_en<=1;
              #1;
             @(negedge vif.rclk);
            vif.r_en<=0;
          end
              end
            end
        
        #5;
        
        
       
      endtask
    
    
endclass

