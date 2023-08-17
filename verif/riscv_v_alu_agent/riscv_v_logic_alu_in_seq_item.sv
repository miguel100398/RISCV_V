//File: riscv_v_logic_alu_seq_item
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector extension logic ALU in sequence item

`ifndef __RISCV_V_LOGIC_ALU_IN_SEQ_ITEM__
`define __RISCV_V_LOGIC_ALU_IN_SEQ_ITEM__ 

class riscv_v_logic_alu_in_seq_item extends riscv_v_alu_in_seq_item;
    rand logic is_reduct;
    rand logic is_and;
    rand logic is_or;
    rand logic is_xor;
    rand logic is_shift;
    rand logic is_left;
    rand logic is_arith;

    `uvm_object_utils_begin(riscv_v_logic_alu_in_seq_item)
        `uvm_field_int(is_reduct,  UVM_ALL_ON)
        `uvm_field_int(is_and,     UVM_ALL_ON)
        `uvm_field_int(is_or,      UVM_ALL_ON)
        `uvm_field_int(is_xor,     UVM_ALL_ON)
        `uvm_field_int(is_shift,   UVM_ALL_ON)
        `uvm_field_int(is_left,    UVM_ALL_ON)
        `uvm_field_int(is_arith,   UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor 
    function new (string name = "riscv_v_logic_alu_in_seq_item");
        super.new(name);
    endfunction: new

    constraint solve_opcode_before_and    {solve opcode before is_and;}
    constraint solve_opcode_before_or     {solve opcode before is_or;}
    constraint solve_opcode_before_xor    {solve opcode before is_xor;}
    constraint solve_opcode_before_shift  {solve opcode before is_shift;}
    constraint solve_opcode_before_left   {solve opcode before is_left;}
    constraint solve_opcode_before_arith  {solve opcode before is_arith;}
    constraint solve_opcode_before_reduct {solve opcode before is_reduct;}

    //Constraint control signals depending on opcode
    //is_and
    constraint is_and_c {
        {is_and == (opcode inside {BW_AND, BW_AND_REDUCT})};
    }

    constraint is_or_c{
        {is_or == (opcode inside {BW_OR, BW_OR_REDUCT})};
    }

    constraint is_xor_c{
        {is_xor == (opcode inside {BW_XOR, BW_XOR_REDUCT})};
    }

    constraint is_shift_c{
        {is_shift == (opcode inside {SLL, SRL, SRA})};
    }

    constraint is_left_c{
        {is_left == (opcode inside {SLL})};
    }

    constraint is_arith_c{
        {is_arith == (opcode inside {SRA})}
    }

    constraint is_reduct_c{
        {is_reduct == (opcode inside {BW_AND_REDUCT, BW_OR_REDUCT, BW_XOR_REDUCT})};
    }

    constraint logic_opcode_c {
        //{opcode inside {BW_AND, BW_AND_REDUCT, BW_OR, BW_OR_REDUCT, BW_XOR, BW_XOR_REDUCT, SLL, SRL, SRA}};
        {opcode inside {SLL}};
    }

    virtual function void constraint_valid();
        super.constraint_valid();
        if (opcode inside {BW_AND_REDUCT, BW_OR_REDUCT, BW_XOR_REDUCT}) begin
            srca.valid = '0;
            case (osize)
                OSIZE_8:   begin 
                    srca.valid[0]    = (len > 0);
                    for (int i=0; i<len; i++) begin
                        srcb.valid[i] = 1'b1;
                    end
                end
                OSIZE_16: begin
                    srca.valid[1:0]  = {2{(len > 0)}};
                    for (int i=0; i<len; i++) begin
                        srcb.valid[i*2 +: 2] = 2'b11;
                    end
                end
                OSIZE_32: begin
                    srca.valid[3:0]  = {4{(len > 0)}};
                    for (int i=0; i<len; i++) begin
                        srcb.valid[i*4 +: 4] = 4'b1111;
                    end
                end
                OSIZE_64: begin
                    srca.valid[7:0]  = {8{(len > 0)}};
                    for (int i=0; i<len; i++) begin
                        srcb.valid[i*8 +: 8] = 8'b1111_1111;
                    end
                end
                OSIZE_128: begin
                    srca.valid[15:0] = {16{(len > 0)}};
                    for (int i=0; i<len; i++) begin
                        srcb.valid[i*16 +: 16] = 16'b1111_1111_1111_1111;
                    end

                end
                default: srca.valid = '0;
            endcase
        end
    endfunction: constraint_valid


endclass: riscv_v_logic_alu_in_seq_item

`endif // __RISCV_V_LOGIC_ALU_IN_SEQ_ITEM__