//File: riscv_instr.sv
//Author: Miguel Bucio
//Date: 09/10/23
//Description: RISCV instruction class

`ifndef __RISCV_INSTR__
`define __RISCV_INSTR__

class riscv_instr extends uvm_component;

    `uvm_component_utils(riscv_instr)

    rand riscv_instruction_t instr;

    function new(string name = "riscv_instr", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function riscv_instruction_t get_rtype_instr();

        assert (this.randomize() with {
            instr.R.op inside {RISCV_R_TYPE_OP_CODE, RISCV_R_SHFT_TYPE_OP_CODE};
        }) else `uvm_fatal(get_name(), "can't randomize rtype instruction");
        return instr;

    endfunction: get_rtype_instr

    virtual function riscv_instruction_t get_itype_instr();

        assert (this.randomize() with {
            instr.I.op inside {RISCV_I_TYPE_OP_CODE, RISCV_LOAD_OP_CODE, RISCV_JALR_OP_CODE};
        }) else `uvm_fatal(get_name(), "can't randomize itype instruction");
        return instr;

    endfunction: get_itype_instr

    virtual function riscv_instruction_t get_stype_instr();

        assert (this.randomize() with {
            instr.S.op inside {RISCV_S_TYPE_OP_CODE};
        }) else `uvm_fatal(get_name(), "can't randomize stype instruction");
        return instr;

    endfunction: get_stype_instr

    virtual function riscv_instruction_t get_btype_instr();

        assert (this.randomize() with {
            instr.B.op inside {RISCV_B_TYPE_OP_CODE};
        }) else `uvm_fatal(get_name(), "can't randomize btype instruction");
        return instr;

    endfunction: get_btype_instr

    virtual function riscv_instruction_t get_utype_instr();

        assert (this.randomize() with {
            instr.U.op inside {RISCV_LUI_OP_CODE, RISCV_AUIPC_OP_CODE};
        }) else `uvm_fatal(get_name(), "can't randomize jtype instruction");
        return instr;

    endfunction: get_utype_instr

    virtual function riscv_instruction_t get_jtype_instr();

        assert (this.randomize() with {
            instr.J.op inside {RISCV_J_TYPE_OP_CODE};
        }) else `uvm_fatal(get_name(), "can't randomize jtype instruction");
        return instr;

    endfunction: get_jtype_instr

    virtual function riscv_instruction_t get_rand_instr();

        assert (this.randomize()) else `uvm_fatal(get_name(), "can't randomize rand instruction");
        return instr;

    endfunction: get_rand_instr

    virtual function riscv_instruction_t get_int_queue_instr();

        assert (this.randomize() with {
            instr.R.op inside {RISCV_R_TYPE_OP_CODE, RISCV_R_SHFT_TYPE_OP_CODE,
                              RISCV_I_TYPE_OP_CODE, RISCV_JALR_OP_CODE,
                              RISCV_B_TYPE_OP_CODE, RISCV_LUI_OP_CODE, RISCV_AUIPC_OP_CODE,
                              RISCV_J_TYPE_OP_CODE};
            if (instr.R.op == RISCV_R_TYPE_OP_CODE){
                instr.R.funct7 != RISCV_FUNCT7_MUL;
                instr.R.funct7 != RISCV_FUNCT7_DIV;
            }            
        }) else `uvm_fatal(get_name(), "can't randomize int queue instruction");
        return instr;

    endfunction: get_int_queue_instr

    virtual function riscv_instruction_t get_int_queue_no_br_jmp_instr();

        assert (this.randomize() with {
            instr.R.op inside {RISCV_R_TYPE_OP_CODE, RISCV_R_SHFT_TYPE_OP_CODE,
                              RISCV_I_TYPE_OP_CODE,
                              RISCV_LUI_OP_CODE, RISCV_AUIPC_OP_CODE};
            if (instr.R.op == RISCV_R_TYPE_OP_CODE){
                instr.R.funct7 != RISCV_FUNCT7_MUL;
                instr.R.funct7 != RISCV_FUNCT7_DIV;
            }            
        }) else `uvm_fatal(get_name(), "can't randomize int queue no branch jump instruction");
        return instr;

    endfunction: get_int_queue_no_br_jmp_instr

    virtual function riscv_instruction_t get_ls_queue_instr();

        assert (this.randomize() with {
            instr.R.op inside {RISCV_S_TYPE_OP_CODE, RISCV_LOAD_OP_CODE};          
        }) else `uvm_fatal(get_name(), "can't randomize ls queue instruction");
        return instr;

    endfunction: get_ls_queue_instr

    virtual function riscv_instruction_t get_mul_queue_instr();

        assert (this.randomize() with {
            instr.R.op     == RISCV_R_TYPE_OP_CODE;
            instr.R.funct7 == RISCV_FUNCT7_MUL; 
            instr.R.funct3 == RISCV_FUNCT3_MUL;        
        }) else `uvm_fatal(get_name(), "can't randomize mul queue instruction");
        return instr;

    endfunction: get_mul_queue_instr

    virtual function riscv_instruction_t get_div_queue_instr();

        assert (this.randomize() with {
            instr.R.op     == RISCV_R_TYPE_OP_CODE;
            instr.R.funct7 ==  RISCV_FUNCT7_DIV;    
            instr.R.funct3 == RISCV_FUNCT3_DIV;      
        }) else `uvm_fatal(get_name(), "can't randomize div queue instruction");
        return instr;

    endfunction: get_div_queue_instr

    virtual function riscv_instruction_t get_jal_instr();

        assert (this.randomize() with {
            instr.R.op     == RISCV_J_TYPE_OP_CODE;
        }) else `uvm_fatal(get_name(), "can't randomize jal instruction");
        return instr;

    endfunction: get_jal_instr

    virtual function riscv_instruction_t get_jalr_instr();

        assert (this.randomize() with {
            instr.R.op     == RISCV_JALR_OP_CODE;
        }) else `uvm_fatal(get_name(), "can't randomize jalr instruction");
        return instr;
        
    endfunction: get_jalr_instr

    virtual function riscv_instruction_t get_branch_instr();

        assert (this.randomize() with {
            instr.B.op     == RISCV_B_TYPE_OP_CODE;
        }) else `uvm_fatal(get_name(), "can't randomize branch instruction");
        return instr;
        
    endfunction: get_branch_instr

    virtual function riscv_instruction_t get_beq_instr();

        assert (this.randomize() with {
            instr.B.op     == RISCV_B_TYPE_OP_CODE;
            instr.B.funct3 == RISCV_FUNCT3_BEQ;
        }) else `uvm_fatal(get_name(), "can't randomize BEQ instruction");
        return instr;
        
    endfunction: get_beq_instr

    virtual function riscv_instruction_t get_st_instr();

        assert (this.randomize() with {
            instr.S.op     == RISCV_S_TYPE_OP_CODE;
        }) else `uvm_fatal(get_name(), "can't randomize store instruction");
        return instr;
        
    endfunction: get_st_instr

    virtual function riscv_instruction_t get_ld_instr();

        assert (this.randomize() with {
            instr.S.op     == RISCV_LOAD_OP_CODE;
        }) else `uvm_fatal(get_name(), "can't randomize load instruction");
        return instr;
        
    endfunction: get_ld_instr

    virtual function riscv_instruction_t get_j_br_instr();

        assert (this.randomize() with {
            instr.R.op inside{RISCV_B_TYPE_OP_CODE, RISCV_JALR_OP_CODE, RISCV_J_TYPE_OP_CODE};
        }) else `uvm_fatal(get_name(), "can't randomize jal/jalr/branch instruction");
        return instr;

    endfunction: get_j_br_instr

    //Constraints
    constraint op{
        instr.R.op inside{RISCV_R_TYPE_OP_CODE, RISCV_R_SHFT_TYPE_OP_CODE, 
                          RISCV_I_TYPE_OP_CODE, RISCV_LOAD_OP_CODE, RISCV_JALR_OP_CODE,
                          RISCV_S_TYPE_OP_CODE,
                          RISCV_B_TYPE_OP_CODE,
                          RISCV_LUI_OP_CODE, RISCV_AUIPC_OP_CODE,
                          RISCV_J_TYPE_OP_CODE};
    }

    constraint funct3{
        if(instr.R.op == RISCV_R_TYPE_OP_CODE){
            if(instr.R.funct7 == RISCV_FUNCT7_SPEC){
                instr.R.funct3 inside{RISCV_FUNCT3_SUB, RISCV_FUNCT3_SRA};
            } else if (instr.R.funct7 == RISCV_FUNCT7_GEN){
                instr.R.funct3 inside{RISCV_FUNCT3_ADD, RISCV_FUNCT3_SLL, RISCV_FUNCT3_SLT, RISCV_FUNCT3_SLTU, RISCV_FUNCT3_XOR, RISCV_FUNCT3_SRL, RISCV_FUNCT3_OR, RISCV_FUNCT3_AND};
            } else if (instr.R.funct7 == RISCV_FUNCT7_MUL){     //MUL and DIV has same funct7
                instr.R.funct3 inside{RISCV_FUNCT3_MUL, RISCV_FUNCT3_DIV};
            }
        } else if (instr.R.op == RISCV_R_SHFT_TYPE_OP_CODE){
            if(instr.R.funct7 == RISCV_FUNCT7_SPEC){
                instr.R.funct3 inside{RISCV_FUNCT3_SRAI};
            } else if (instr.R.funct7 == RISCV_FUNCT7_GEN){
                instr.R.funct3 inside{RISCV_FUNCT3_SLLI, RISCV_FUNCT3_SRLI};
            }
        } else if (instr.R.op == RISCV_I_TYPE_OP_CODE){
            instr.R.funct3 inside{RISCV_FUNCT3_ADDI, RISCV_FUNCT3_SLTI, RISCV_FUNCT3_SLTIU, RISCV_FUNCT3_XORI, RISCV_FUNCT3_ORI, RISCV_FUNCT3_ANDI};
        } else if (instr.R.op == RISCV_LOAD_OP_CODE){
            instr.R.funct3 inside{RISCV_FUNCT3_LB, RISCV_FUNCT3_LH, RISCV_FUNCT3_LW, RISCV_FUNCT3_LBU, RISCV_FUNCT3_LHU};
        } else if (instr.R.op == RISCV_JALR_OP_CODE){
            instr.R.funct3 == RISCV_FUNCT3_JALR;
        } else if (instr.R.op == RISCV_S_TYPE_OP_CODE){
            instr.R.funct3 inside{RISCV_FUNCT3_SB, RISCV_FUNCT3_SH, RISCV_FUNCT3_SW};
        } else if (instr.R.op == RISCV_B_TYPE_OP_CODE){
            instr.R.funct3 inside{RISCV_FUNCT3_BEQ, RISCV_FUNCT3_BNE, RISCV_FUNCT3_BLT, RISCV_FUNCT3_BGE, RISCV_FUNCT3_BLTU, RISCV_FUNCT3_BGEU};
        }
    }
    
    constraint funct7{
        if (instr.R.op == RISCV_R_TYPE_OP_CODE){
            (instr.R.funct7 == RISCV_FUNCT7_GEN) || (instr.R.funct7 == RISCV_FUNCT7_SPEC) || (instr.R.funct7 == RISCV_FUNCT7_MUL) || (instr.R.funct7 == RISCV_FUNCT7_DIV);
        } else if (instr.R.op == RISCV_R_SHFT_TYPE_OP_CODE) {
            (instr.R.funct7 == RISCV_FUNCT7_GEN) ||  (instr.R.funct7 == RISCV_FUNCT7_SPEC);
        } else if (instr.R.op == RISCV_I_TYPE_OP_CODE){
            if (instr.R.funct3 == RISCV_FUNCT3_SLL){
                instr.R.funct7 == RISCV_FUNCT7_SRL;
            } else if (instr.R.funct3 == RISCV_FUNCT3_SRL){
                (instr.R.funct7 == RISCV_FUNCT7_SRL) || (instr.R.funct7 == RISCV_FUNCT7_SRA);
            }
        }
    }

endclass: riscv_instr 

`endif //__RISCV_INSTR__ 