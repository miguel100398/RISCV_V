//File: riscv_v_if_in_seq_item
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V register file write sequence item

`ifndef __RISCV_V_IF_IN_SEQ_ITEM__
`define __RISCV_V_IF_IN_SEQ_ITEM__ 

class riscv_v_if_in_seq_item extends riscv_v_base_seq_item;


    rand logic rst;

    `uvm_object_utils_begin(riscv_v_if_in_seq_item)
        
    `uvm_object_utils_end

    //Constructor
    function new(string name = "riscv_v_if_in_seq_item");
        super.new(name);
    endfunction: new


endclass: riscv_v_if_in_seq_item

`endif //__RISCV_V_IF_IN_SEQ_ITEM__