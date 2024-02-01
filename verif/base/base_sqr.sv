//File: base_sqr.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base sequencer

`ifndef __BASE_SQR__
`define __BASE_SQR__

virtual class base_sqr#(type seq_item_t = base_seq_item) extends uvm_sequencer#(seq_item_t);
    `uvm_component_param_utils(base_sqr#(seq_item_t))

    //Constructor
    function new(string name = "base_sqr", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

endclass: base_sqr

`endif //__BASE_SQR__