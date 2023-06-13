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

    //Constraint control signals depending on opcode
    //is_and
    constraint is_and_c {
        //Is_and
        if (opcode inside {BW_AND, BW_AND_REDUCT}) {
            {is_and == 1'b1};
         } else {
            {is_and == 1'b0};
        }
    }
    //s_reduct
    constraint is_reduct_c {
        if (opcode inside {BW_AND_REDUCT}) {
            {is_reduct == 1'b1};
        } else {
            {is_reduct == 1'b0};
        }
    }

    constraint logic_opcode_c {
        {opcode inside {BW_AND, BW_AND_REDUCT}};
    }


endclass: riscv_v_logic_alu_in_seq_item

`endif // __RISCV_V_LOGIC_ALU_IN_SEQ_ITEM__