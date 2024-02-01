//File: base_seq_item.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base seq item

`ifndef __BASE_SEQ_ITEM__
`define __BASE_SEQ_ITEM__

virtual class base_seq_item#(
    type in_seq_item_t  = uvm_sequence_item,
    type out_seq_item_t = in_seq_item_t
) extends uvm_sequence_item;

    in_seq_item_t  in;
    out_seq_item_t out;

    //Constructor
    function new(string name = "base_seq_item");
        super.new(name);
    endfunction: new

endclass: base_seq_item


`endif //__BASE_SEQ_ITEM__