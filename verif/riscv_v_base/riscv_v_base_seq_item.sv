//File: riscv_v_base_seq_item.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base seq item

`ifndef __RISCV_V_BASE_SEQ_ITEM__
`define __RISCV_V_BASE_SEQ_ITEM__

virtual class riscv_v_base_seq_item extends base_seq_item;

    //Constructor
    function new(string name = "base_seq_item");
        super.new(name);
    endfunction: new

endclass: riscv_v_base_seq_item


`endif //__BASE_SEQ_ITEM__