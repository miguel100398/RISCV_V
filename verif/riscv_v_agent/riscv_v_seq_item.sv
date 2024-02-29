//File: riscv_v_seq_item.sv
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V RF seq item

`ifndef __RISCV_V_SEQ_ITEM__
`define __RISCV_V_SEQ_ITEM__

class riscv_v_seq_item extends riscv_v_base_in_out_seq_item#(
    .in_seq_item_t(riscv_v_in_seq_item),
    .out_seq_item_t(riscv_v_out_seq_item)
);

    `uvm_object_utils(riscv_v_seq_item)


    //Constructor
    function new(string name = "riscv_v_seq_item");
        super.new(name);
    endfunction: new

endclass: riscv_v_seq_item


`endif //__RISCV_V_SEQ_ITEM__