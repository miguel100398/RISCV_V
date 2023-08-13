//File: riscv_v_logic_alu_seq_item
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector extension logic ALU in sequence item

`ifndef __RISCV_V_LOGIC_ALU_IN_SEQ_ITEM__
`define __RISCV_V_LOGIC_ALU_IN_SEQ_ITEM__ 

class riscv_v_logic_alu_in_seq_item extends riscv_v_alu_in_seq_item;
    rand logic is_reduct;
    rand logic is_and;

    `uvm_object_utils_begin(riscv_v_logic_alu_in_seq_item)
        `uvm_field_int(is_reduct,  UVM_ALL_ON)
        `uvm_field_int(is_and,     UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor 
    function new (string name = "riscv_v_logic_alu_in_seq_item");
        super.new(name);
    endfunction: new

    constraint solve_opcode_before_and    {solve opcode before is_and;}
    constraint solve_opcode_before_reduct {solve opcode before is_reduct;}

    //Constraint control signals depending on opcode
    //is_and
    constraint is_and_c {
        {is_and == (opcode inside {BW_AND, BW_AND_REDUCT})};
    }

    constraint is_reduct_c{
        {is_reduct == (opcode inside {BW_AND_REDUCT})};
    }

    constraint logic_opcode_c {
        //{opcode inside {BW_AND, BW_AND_REDUCT}};
        {opcode inside {BW_AND}};
    }


endclass: riscv_v_logic_alu_in_seq_item

`endif // __RISCV_V_LOGIC_ALU_IN_SEQ_ITEM__