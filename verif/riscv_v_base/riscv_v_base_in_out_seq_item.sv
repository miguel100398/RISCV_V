//File: riscv_v_base_in_out_seq_item.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base seq item

`ifndef __RISCV_V_BASE_IN_OUT_SEQ_ITEM__
`define __RISCV_V_BASE_IN_OUT_SEQ_ITEM__

class riscv_v_base_in_out_seq_item#(
    type in_seq_item_t  = riscv_v_base_seq_item,
    type out_seq_item_t = riscv_v_base_seq_item
) extends base_in_out_seq_item#(
    .in_seq_item_t(in_seq_item_t),
    .out_seq_item_t(out_seq_item_t)
);

    `uvm_object_param_utils(
        riscv_v_base_in_out_seq_item#(
            .in_seq_item_t(in_seq_item_t),
            .out_seq_item_t(out_seq_item_t)
        )
    )

    //Constructor
    function new(string name = "riscv_v_base_in_out_seq_item");
        super.new(name);
    endfunction: new

endclass: riscv_v_base_in_out_seq_item


`endif //__RISCV_V_BASE_IN_OUT_SEQ_ITEM__