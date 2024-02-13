//File: riscv_v_if_trk_item
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V register file tracker item

`ifndef __RISCV_V_IF_TRK_ITEM__
`define __RISCV_V_IF_TRK_ITEM__ 

class riscv_v_if_trk_item extends riscv_v_base_seq_item;
    riscv_instruction_t   instruction;
    `ifdef RISCV_V_INST
        riscv_v_opcode_e  opcode;
    `endif //RISCV_V_INST

    `uvm_object_utils_begin(riscv_v_if_trk_item)
        `uvm_field_int(instruction, UVM_ALL_ON)
        `ifdef RISCV_V_INST
            `uvm_field_enum(riscv_v_opcode_e, opcode, UVM_ALL_ON)
        `endif //RISCV_V_INST
    `uvm_object_utils_end

    //Constructor
    function new(string name = "riscv_v_if_trk_item");
        super.new(name);
    endfunction: new


endclass: riscv_v_if_trk_item

`endif //__RISCV_V_IF_TRK_ITEM__