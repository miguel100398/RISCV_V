//File: riscv_v_permutation_alu_out_seq_item
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension Permutation ALU out sequence item

`ifndef __RISCV_V_PERMUTAITON_ALU_OUT_SEQ_ITEM_SV__
`define __RISCV_V_PERMUTAITON_ALU_OUT_SEQ_ITEM_SV__ 

class riscv_v_permutation_alu_out_seq_item extends riscv_v_alu_out_seq_item;
    riscv_data_t        integer_data_out;
    riscv_v_wb_data_t   vector_data_out;

    `uvm_object_utils_begin(riscv_v_permutation_alu_out_seq_item)
        `uvm_field_int(integer_data_out,  UVM_ALL_ON)
        `uvm_field_int(vector_data_out,   UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor 
    function new (string name = "riscv_v_permutation_alu_out_seq_item");
        super.new(name);
    endfunction: new

endclass: riscv_v_permutation_alu_out_seq_item

`endif //__RISCV_V_PERMUTAITON_ALU_OUT_SEQ_ITEM_SV__