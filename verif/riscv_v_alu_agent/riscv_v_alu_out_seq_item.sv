//File: riscv_v_alu_seq_item
//Author: Miguel Bucio
//Date: 12/06/23
//Description: RISC-V Vector extension ALU out sequence item

`ifndef __RISCV_V_ALU_OUT_SEQ_ITEM_SV__
`define __RISCV_V_ALU_OUT_SEQ_ITEM_SV__ 

class riscv_v_alu_out_seq_item extends riscv_v_base_seq_item;
    riscv_v_wb_data_t result;
    riscv_v_alu_e     ALU;    

    `uvm_object_utils_begin(riscv_v_alu_out_seq_item)
        `uvm_field_int(result.data,  UVM_ALL_ON)
        `uvm_field_int(result.valid, UVM_ALL_ON)
    `uvm_object_utils_end


    //Constructor 
    function new (string name = "riscv_v_alu_out_seq_item");
        super.new(name);
    endfunction: new

endclass: riscv_v_alu_out_seq_item

`endif // __RISCV_V_ALU_OUT_SEQ_ITEM_SV__