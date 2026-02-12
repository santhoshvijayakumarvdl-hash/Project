import uvm_pkg::*;
`include "uvm_macros.svh"

//factory registration
class sequencer extends uvm_sequencer #(seq_item);
  `uvm_component_utils(sequencer)

  //default constructor
  function new(string name = "sequencer",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
endclass
