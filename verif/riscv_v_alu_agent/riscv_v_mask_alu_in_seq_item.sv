//File: riscv_v_mask_alu_in_seq_item
//Author: Miguel Bucio
//Date: 15/01/23
//Description: RISC-V Vector extension mask ALU in sequence item

`ifndef __RISCV_V_MASK_ALU_IN_SEQ_ITEM__
`define __RISCV_V_MASK_ALU_IN_SEQ_ITEM__ 

class riscv_v_mask_alu_in_seq_item extends riscv_v_alu_in_seq_item;

    rand logic              is_mask;
    rand logic              is_and;
    rand logic              is_or;
    rand logic              is_xor;
    rand logic              is_negate_srca;
    rand logic              is_negate_result;
    rand riscv_v_mask_reg_t srca_mask;
    rand riscv_v_mask_reg_t srcb_mask;

    `uvm_object_utils_begin(riscv_v_mask_alu_in_seq_item)
        `uvm_field_int(is_mask,             UVM_ALL_ON)
        `uvm_field_int(is_and,              UVM_ALL_ON)
        `uvm_field_int(is_or,               UVM_ALL_ON)
        `uvm_field_int(is_xor,              UVM_ALL_ON)
        `uvm_field_int(is_negate_srca,      UVM_ALL_ON)
        `uvm_field_int(is_negate_result,    UVM_ALL_ON)
        `uvm_field_int(srca_mask,           UVM_ALL_ON)
        `uvm_field_int(srcb_mask,           UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor 
    function new (string name = "riscv_v_mask_alu_in_seq_item");
        super.new(name);
    endfunction: new

    function void post_randomize();
        super.post_randomize();
        constraint_control();
    endfunction: post_randomize

    constraint solve_opcode_before_and              {solve opcode before is_and;}
    constraint solve_opcode_before_or               {solve opcode before is_or;}
    constraint solve_opcode_before_xor              {solve opcode before is_xor;}
    constraint solve_opcode_before_negate_srca      {solve opcode before is_negate_srca;}
    constraint solve_opcode_before_negate_result    {solve opcode before is_negate_result;}

    virtual function void constraint_control();
        is_and              = (opcode inside {MAND, MNAND, MANDN});
        is_or               = (opcode inside {MOR, MNOR, MORN});
        is_xor              = (opcode inside {MXOR, MXNOR});
        is_negate_srca      = (opcode inside {MANDN, MORN});
        is_negate_result    = (opcode inside {MNAND, MNOR, MXNOR});
        is_mask             = 1'b1;
    endfunction: constraint_control

    constraint mask_opcode_c {
        {opcode inside {MAND, MNAND, MANDN, MOR, MNOR, MORN, MXOR, MXNOR}};
    }

endclass: riscv_v_mask_alu_in_seq_item

`endif //__RISCV_V_MASK_ALU_IN_SEQ_ITEM__