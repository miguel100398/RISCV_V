//File: riscv_v_mask_alu_out_seq_item
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension Mask ALU out sequence item

`ifndef __RISCV_V_MASK_ALU_OUT_SEQ_ITEM_SV__
`define __RISCV_V_MASK_ALU_OUT_SEQ_ITEM_SV__ 

class riscv_v_mask_alu_out_seq_item extends riscv_v_alu_out_seq_item;
    riscv_v_mask_reg_t  result_mask;

    `uvm_object_utils_begin(riscv_v_mask_alu_out_seq_item)
        `uvm_field_int(result_mask,  UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor 
    function new (string name = "riscv_v_mask_alu_out_seq_item");
        super.new(name);
    endfunction: new

endclass: riscv_v_mask_alu_out_seq_item

`endif //__RISCV_V_MASK_ALU_OUT_SEQ_ITEM_SV__