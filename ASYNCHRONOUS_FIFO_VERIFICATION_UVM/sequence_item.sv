import uvm_pkg::*;
`include "uvm_macros.svh"

//factory registration
class seq_item extends uvm_sequence_item;
  rand bit r_en;
  
  rand bit w_en;

  rand bit[7:0] data_in;
 
  
  bit [7:0] data_out;
  bit full;
  bit empty;
 rand  bit wrst_n;
  rand bit rrst_n;
  
 
 

  `uvm_object_utils_begin(seq_item)
  `uvm_field_int(wrst_n,UVM_ALL_ON)
  `uvm_field_int(rrst_n,UVM_ALL_ON)
  `uvm_field_int(data_in,UVM_ALL_ON)
  `uvm_field_int(w_en,UVM_ALL_ON)
  `uvm_field_int(r_en,UVM_ALL_ON)
  `uvm_field_int(full,UVM_ALL_ON)
  `uvm_field_int(empty,UVM_ALL_ON)
  `uvm_field_int(data_out,UVM_ALL_ON)
  `uvm_object_utils_end
  

  //default constructor
  function new(string name = "seq_item");
    super.new(name);
  endfunction

  //constraint

  constraint ior {w_en dist {1:=8,0:=2};}
  constraint jor {r_en dist {0:=8,1:=2};}
  


  
  constraint dar{(w_en)->data_in<((1<<8)-1);}
  
  
endclass

