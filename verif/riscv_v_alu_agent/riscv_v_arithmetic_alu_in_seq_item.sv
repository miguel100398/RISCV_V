//File: riscv_v_arithmetic_alu_seq_item
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector extension arithmetic ALU in sequence item

`ifndef __RISCV_V_ARITHMETIC_ALU_IN_SEQ_ITEM__
`define __RISCV_V_ARITHMETIC_ALU_IN_SEQ_ITEM__ 

class riscv_v_arithmetic_alu_in_seq_item extends riscv_v_alu_in_seq_item;
    rand logic is_reduct;
    rand logic is_add;
    rand logic is_sub;
    rand logic is_mul;
    rand logic is_zero_ext;
    rand logic is_sign_ext;
    rand logic is_set_equal;
    rand logic is_set_nequal;
    rand logic is_set_less;
    rand logic is_set_greater;
    rand logic is_max;
    rand logic is_min;
    rand logic is_high;
    rand logic is_signed;
    rand logic use_carry;
    rand riscv_v_carry_in_t carry_in;

    `uvm_object_utils_begin(riscv_v_arithmetic_alu_in_seq_item)
        `uvm_field_int(is_reduct,       UVM_ALL_ON)
        `uvm_field_int(is_add,          UVM_ALL_ON)
        `uvm_field_int(is_sub,          UVM_ALL_ON)
        `uvm_field_int(is_mul,          UVM_ALL_ON)
        `uvm_field_int(is_zero_ext,     UVM_ALL_ON)
        `uvm_field_int(is_sign_ext,     UVM_ALL_ON)
        `uvm_field_int(is_set_equal,    UVM_ALL_ON)
        `uvm_field_int(is_set_nequal,   UVM_ALL_ON)
        `uvm_field_int(is_set_greater,  UVM_ALL_ON)
        `uvm_field_int(is_sign_ext,     UVM_ALL_ON)
        `uvm_field_int(is_max,          UVM_ALL_ON)
        `uvm_field_int(is_min,          UVM_ALL_ON)
        `uvm_field_int(is_high,         UVM_ALL_ON)
        `uvm_field_int(is_signed,       UVM_ALL_ON)
        `uvm_field_int(use_carry,       UVM_ALL_ON)
        `uvm_field_int(carry_in,        UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor 
    function new (string name = "riscv_v_arithmetic_alu_in_seq_item");
        super.new(name);
    endfunction: new

    function void post_randomize();
        super.post_randomize();
        constraint_control();
    endfunction: post_randomize

    virtual function void constraint_control();
        is_add         = (opcode inside {ADDC, ADD, ADD_REDUCT});
        is_sub         = (opcode inside {SUBB, SUB, SUB_REDUCT, MINS, MINS_REDUCT, MINU, MINU_REDUCT, MAXS, MAXS_REDUCT, MAXU, MAXU_REDUCT, SEQ, SNE, SLE, SLEU, SLT, SLTU, SGT, SGTU});
        is_mul         = (opcode inside {MULLS, MULHS, MULLU, MULHU});
        is_zero_ext    = (opcode inside {ZERO_EXT});
        is_sign_ext    = (opcode inside {SIGN_EXT});
        is_set_equal   = (opcode inside {SEQ, SLE, SLEU});
        is_set_nequal  = (opcode inside {SNE});
        is_set_less    = (opcode inside {SLE, SLEU, SLT, SLTU});
        is_set_greater = (opcode inside {SGT, SGTU});
        is_max         = (opcode inside {MAXS, MAXS_REDUCT, MAXU, MAXU_REDUCT});
        is_min         = (opcode inside {MINS, MINS_REDUCT, MINU, MINU_REDUCT});
        is_high        = (opcode inside {MULHS, MULHU});
        is_signed      = (opcode inside {ADD, ADDC, ADD_REDUCT, SUBB, SUB, SUB_REDUCT, MAXS, MAXS_REDUCT, MINS, MINS_REDUCT, MULLS, MULHS, SLE, SLT, SGT});
        use_carry      = (opcode inside {ADDC, SUBB});
        is_reduct      = (opcode inside {ADD_REDUCT, SUB_REDUCT, MAXS_REDUCT, MAXU_REDUCT, MINS_REDUCT, MINU_REDUCT});
    endfunction: constraint_control

    constraint arithmetic_opcode_c {
        {opcode inside {ADDC, ADD, ADD_REDUCT, SUBB, SUB, SUB_REDUCT, SIGN_EXT, ZERO_EXT, MINS, MINS_REDUCT, MINU, MINU_REDUCT, MAXS, MAXS_REDUCT, MAXU, MAXU_REDUCT, MULLU, MULLS, MULHU, MULHS, SEQ, SNE, SLE, SLEU, SLT, SLTU, SGT, SGTU}};
    }

    virtual function void constraint_valid();
        super.constraint_valid();
        if (opcode inside {ADD_REDUCT, SUB_REDUCT, MAXS_REDUCT, MAXU_REDUCT, MINS_REDUCT, MINU_REDUCT}) begin
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


endclass: riscv_v_arithmetic_alu_in_seq_item

`endif // __RISCV_V_ARITHMETIC_ALU_IN_SEQ_ITEM__