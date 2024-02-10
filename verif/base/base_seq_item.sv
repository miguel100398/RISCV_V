//File: base_seq_item.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base seq item

`ifndef __BASE_SEQ_ITEM__
`define __BASE_SEQ_ITEM__

class base_seq_item extends uvm_sequence_item;

    `uvm_object_utils(base_seq_item)

    //Constructor
    function new(string name = "base_seq_item");
        super.new(name);
    endfunction: new

endclass: base_seq_item


`endif //__BASE_SEQ_ITEM__