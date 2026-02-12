import uvm_pkg::*;
`include "uvm_macros.svh"

//factory registration
class seq extends uvm_sequence #(seq_item);
  int test_case;
  


  `uvm_object_utils(seq)

  //default constructor
  function new(string name = "seq_item");
    super.new(name);
    req=new();
  endfunction
  
//task
  virtual task body();
 
    case(test_case)
      1:reset();
      2:single_write_read();
      3:multiple_write_read();
      4:test_overflow();
      5:test_underflow();
      6:random_write();
      7:wrap();
      8:simultaneous_wr_rd();
      9:mid_reset();
    endcase

  `uvm_info(get_type_name(), "sequence is finished", UVM_MEDIUM)
  
endtask
  
  
  
  task automatic reset();
    seq_item req;
    $display("RESET COMPLETED");
    req = seq_item::type_id::create("req");
    start_item(req);
    req.wrst_n=0;
    req.rrst_n=0;
    finish_item(req);
    #20
    req = seq_item::type_id::create("req");
    start_item(req);
    req.wrst_n=1;
    req.rrst_n=1;
    finish_item(req);
  endtask
  
   task automatic single_write_read();
     seq_item req;
      $display("SINGLE WRITE AND READ");
     
     req = seq_item::type_id::create("req");
     $display("%b",req.w_en);
     start_item(req);
     req.wrst_n=1;
     req.rrst_n=1;
     req.w_en=1;
     req.r_en=0;
     req.data_in=58;
     finish_item(req);
     #60
     req = seq_item::type_id::create("req");
     start_item(req);
     req.wrst_n=1;
     req.rrst_n=1;
     req.w_en=0;
     req.r_en=1;
     $display("SINGLE READ");
     finish_item(req);
     
   endtask
  
  task automatic multiple_write_read();
    seq_item req;
     $display("MULTIPLE WRITE AND READ");
    for(int i=0;i<4;i++) begin 
   req = seq_item::type_id::create("req");
       req.wrst_n=1;
     req.rrst_n=1;
   start_item(req);
   req.w_en=1;
   req.r_en=0;
   req.data_in=$random&8'b11111111;
      finish_item(req);
     end
    
    #20;
    for(int i=0;i<4;i++) begin 
   req = seq_item::type_id::create("req");
   start_item(req);
       req.wrst_n=1;
     req.rrst_n=1;
   req.w_en=0;
   req.r_en=1;
   
  finish_item(req);
     end
  endtask
    
        
 task automatic test_overflow();
   seq_item req;
    $display("OVERFLOW");
   for(int i=0;i<16;i++) begin
   req = seq_item::type_id::create("req");
   start_item(req);
     req.wrst_n=1;
     req.rrst_n=1;
   req.w_en=1;
   req.r_en=0;
   req.data_in=8'hA0+i;
     finish_item(req);
  
     end
  endtask
    
     task automatic test_underflow();
       seq_item req;
     $display("UNDERFLOW");
  
  req = seq_item::type_id::create("req");
   start_item(req);
   req.wrst_n=1;
   req.rrst_n=1;    
   req.w_en=1;
   req.r_en=0;
   req.data_in=42;
   finish_item(req);
  
   for(int i=0;i<5;i++) begin
   req = seq_item::type_id::create("req");
   start_item(req);
     req.wrst_n=1;
     req.rrst_n=1;
   req.w_en=0;
   req.r_en=1;
   finish_item(req);
     end
  endtask
    
    
    
task automatic random_write();
  seq_item req;
  $display("RANDOM_WRITE");

  repeat (100) begin
    `uvm_do_with(req, {
      wrst_n == 1;rrst_n==1;
    })
  end
endtask

    
    
     task automatic wrap();
       seq_item req;
    $display("WRAP");
   
    
    
    for(int i=0;i<16;i++) begin
    req = seq_item::type_id::create("req");
      start_item(req);
      req.wrst_n=1;
     req.rrst_n=1;
   req.w_en=1;
   req.r_en=0;
   req.data_in=8'hA0+i;
   finish_item(req);
     end
    
    for(int i=0;i<8;i++) begin
   req = seq_item::type_id::create("req");
      start_item(req);
      req.wrst_n=1;
     req.rrst_n=1;
   req.w_en=0;
   req.r_en=1;
   finish_item(req);
     end
    
    for(int i=0;i<8;i++) begin
   req = seq_item::type_id::create("req");
      start_item(req);
      req.wrst_n=1;
     req.rrst_n=1;
   req.w_en=1;
   req.r_en=0;
   req.data_in=8'hA0+i;
   finish_item(req);
     end
    
      for(int i=0;i<16;i++) begin
   req = seq_item::type_id::create("req");
      start_item(req);
        req.wrst_n=1;
     req.rrst_n=1;
   req.w_en=0;
   req.r_en=1;
   finish_item(req);
     end
    
  endtask
  
   task simultaneous_wr_rd();
     
    $display("SIMULTANEOUS WRITE AND READ");
   
   
    
     for(int i=0;i<8;i++) begin
 req = seq_item::type_id::create("req");
   start_item(req);
        req.wrst_n=1;
     req.rrst_n=1;
   req.w_en=1;
   req.r_en=1;
   req.data_in=8'hA0+i;
   finish_item(req);
     end
    
   endtask
  
  
    task automatic mid_reset();
    $display("middle reset");
    
   
     for(int i=0;i<8;i++) begin
   req = seq_item::type_id::create("req");
   start_item(req);
   req.wrst_n=1;
     req.rrst_n=1;
   req.w_en=1;
   req.r_en=1;
   req.data_in=8'hA0+i;
       
       if(i>4)begin
     req.wrst_n=0;
     req.rrst_n=0;
       end
         
       finish_item(req);
   
     end
    
 
    
    
  endtask
  
    
endclass

