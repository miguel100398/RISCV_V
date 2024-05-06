//File: riscv_v_permutation_alu_in_seq_item
//Author: Miguel Bucio
//Date: 15/01/23
//Description: RISC-V Vector extension permutation ALU in sequence item

`ifndef __RISCV_V_PERMUTATION_ALU_IN_SEQ_ITEM__
`define __RISCV_V_PERMUTATION_ALU_IN_SEQ_ITEM__ 

class riscv_v_permutation_alu_in_seq_item extends riscv_v_alu_in_seq_item;

    rand logic              is_i2v;
    rand logic              is_v2i;
    rand riscv_v_alu_data_t srca;
    rand riscv_v_alu_data_t srcb;

    `uvm_object_utils_begin(riscv_v_permutation_alu_in_seq_item)
        `uvm_field_int(is_i2v,             UVM_ALL_ON)
        `uvm_field_int(is_v2i,             UVM_ALL_ON)
        `uvm_field_int(srca,               UVM_ALL_ON)
        `uvm_field_int(srcb,               UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor 
    function new (string name = "riscv_v_permutation_alu_in_seq_item");
        super.new(name);
    endfunction: new

    function void post_randomize();
        super.post_randomize();
        constraint_control();
    endfunction: post_randomize

    constraint solve_opcode_before_i2v              {solve opcode before is_i2v;}
    constraint solve_opcode_before_v2i              {solve opcode before is_v2i;}

    virtual function void constraint_control();
        is_i2v              = (opcode inside {I2V});
        is_v2i              = (opcode inside {V2I});
    endfunction: constraint_control

    constraint mask_opcode_c {
        {opcode inside {I2V, V2I}};
    }

endclass: riscv_v_permutation_alu_in_seq_item

`endif //__RISCV_V_PERMUTAITON_ALU_IN_SEQ_ITEM__