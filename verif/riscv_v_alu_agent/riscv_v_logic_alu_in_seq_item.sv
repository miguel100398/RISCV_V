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

    virtual function void constraint_valid();
        super.constraint_valid();
        if (opcode inside {BW_AND_REDUCT}) begin
            srca.valid = '0;
            case (osize)
                OSIZE_8:   srca.valid[0]    = (len > 0);
                OSIZE_16:  srca.valid[1:0]  = {2{(len > 0)}};
                OSIZE_32:  srca.valid[3:0]  = {4{(len > 0)}};
                OSIZE_64:  srca.valid[7:0]  = {8{(len > 0)}};
                OSIZE_128: srca.valid[15:0] = {16{(len > 0)}};
                default: srca.valid = '0;
            endcase
        end
    endfunction: constraint_valid


endclass: riscv_v_logic_alu_in_seq_item

`endif // __RISCV_V_LOGIC_ALU_IN_SEQ_ITEM__