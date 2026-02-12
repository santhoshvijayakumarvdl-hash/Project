import uvm_pkg::*;
`include "uvm_macros.svh"

//factory registration
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  
  //virtual interface
  virtual add_if vif;
    
   //object creation
    seq_item mon_item;
  
  // analysis port
  uvm_analysis_port #(seq_item) mon_ap;

   //default constructor
  function new(string name = "monitor",uvm_component parent=null);
    super.new(name,parent);
    
  endfunction
  
//phases
    
    //BUILD_PHASE
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db #(virtual add_if)::get(this,"","vif",vif))
        `uvm_info(get_type_name(),"build_phase in monitor is wrong",UVM_MEDIUM);
      mon_ap=new("mon_ap",this);
      
    endfunction
      
      //RUN_PHASE
      virtual task run_phase(uvm_phase phase);
        
            
              fork
              monitor_write();
              monitor_read();
              join_none     
              
      endtask   
  
  task monitor_write();
    `uvm_info(get_type_name(),"run_phase in monitor is started",UVM_MEDIUM); 
          forever begin
          @(posedge vif.wclk);
            if(!vif.full&vif.w_en)begin
           #3;
          mon_item=seq_item::type_id::create("mon_item",this);
           
          mon_item.wrst_n=vif.wrst_n;
          
          mon_item.data_in=vif.data_in; 
          mon_item.w_en=1;
          mon_item.print();
              `uvm_info(get_type_name(),$sformatf(" din=%d,wrst_n=%d,w_en=%d,r_en=%d,dout=%d",mon_item.data_in,mon_item.wrst_n,mon_item.w_en,mon_item.r_en,mon_item.data_out),UVM_MEDIUM)  
               
          mon_ap.write(mon_item);
          end
          end
        endtask
          
          
          task monitor_read();
            `uvm_info(get_type_name(),"run_phase in monitor is started",UVM_MEDIUM); 
            forever begin
            @(posedge vif.rclk);
              if(!vif.empty&vif.r_en) begin
            #3;
          mon_item=seq_item::type_id::create("mon_item",this);
          mon_item.rrst_n=vif.rrst_n;
          mon_item.r_en=1;
          mon_item.data_out = vif.data_out;
          mon_item.print();
                `uvm_info(get_type_name(),$sformatf(" din=%d,wrst_n=%d,w_en=%d,r_en=%d,dout=%d",mon_item.data_in,mon_item.wrst_n,mon_item.w_en,mon_item.r_en,mon_item.data_out),UVM_MEDIUM)  
               
            mon_ap.write(mon_item);
            end
            end
          endtask 
endclass

