//File: base_in_out_seq_item.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base seq item

`ifndef __BASE_IN_OUT_SEQ_ITEM__
`define __BASE_IN_OUT_SEQ_ITEM__

virtual  class base_in_out_seq_item#(
    type in_seq_item_t  = base_seq_item,
    type out_seq_item_t = in_seq_item_t
) extends uvm_sequence_item;


    rand in_seq_item_t  in;
    rand out_seq_item_t out;

    //Constructor
    function new(string name = "base_in_out_seq_item");
        super.new(name);
        in  = in_seq_item_t::type_id::create({get_name(), "_in"});
        out = out_seq_item_t::type_id::create({get_name(), "_out"});
    endfunction: new

endclass: base_in_out_seq_item


`endif //__BASE_IN_OUT_SEQ_ITEM__