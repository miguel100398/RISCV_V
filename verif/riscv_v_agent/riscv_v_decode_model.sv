//File: riscv_v_decode_model
//Author: Miguel Bucio
//Date: 16/04/24
//Description: RiscV V Decode Model

`ifndef __RISCV_V_DECODE_MODEL__
`define __RISCV_V_DECODE_MODEL__

class riscv_v_decode_model extends riscv_v_base_model;
    `uvm_component_utils(riscv_v_decode_model)

    function new(string name = "riscv_v_decode_model", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    virtual function void rst();
        return;
    endfunction: rst

    ////////////////////////////////DECODE FUNCTIONS/////////////////////////////////////////////////////////

    //FUNCT6
    virtual function riscv_instr_funct6_t get_funct6(riscv_v_type_instruction_t instr);
        return instr.funct6;
    endfunction: get_funct6

    //VM (Vector Mask)
    virtual function riscv_instr_mask_t get_vm(riscv_v_type_instruction_t instr);
        return instr.vm;
    endfunction: get_vm

    //VS2
    virtual function riscv_instr_rs_t get_vs2(riscv_v_type_instruction_t instr);
        return instr.vs2;
    endfunction: get_vs2

    //VS1
    virtual function riscv_instr_rs_t get_vs1(riscv_v_type_instruction_t instr);
        return instr.vs1;
    endfunction: get_vs1

    //FUNCT3
    virtual function riscv_instr_funct3_t get_funct3(riscv_v_type_instruction_t instr);
        return instr.funct3;
    endfunction: get_funct3

    //VD
    virtual function riscv_instr_rd_t get_vd(riscv_v_type_instruction_t instr);
        return instr.vd;
    endfunction: get_vd

    //OP
    virtual function riscv_instr_op_t get_op(riscv_v_type_instruction_t instr);
        return instr.op;
    endfunction: get_op 

    //Is vector operation
    virtual function bit is_vector_op(riscv_v_type_instruction_t instr);
        return f_is_vector_op(instr.op);
    endfunction: is_vector_op

    //Get internal opcode
    virtual function riscv_v_opcode_e get_alu_opcode(riscv_v_type_instruction_t instr);
        return f_riscv_v_get_opcode(instr);
    endfunction: get_alu_opcode

    //Get vs1 type
    virtual function riscv_v_src_type_t get_vs1_type(riscv_v_type_instruction_t instr);
        unique case(1'b1)
            f_is_vector_vector_op(riscv_v_funct3_e'(instr.funct3)) : begin
                return SRC_VEC;
            end
            f_is_scalar_vector_op(riscv_v_funct3_e'(instr.funct3)) : begin
                return SRC_SCALAR_VEC;
            end
            f_is_scalar_int_op(riscv_v_funct3_e'(instr.funct3)) : begin
                return SRC_SCALAR_INT;
            end
            f_is_scalar_imm_op(riscv_v_funct3_e'(instr.funct3)) : begin
                return SRC_SCALAR_IMM;
            end
            f_is_scalar_fp_op(riscv_v_funct3_e'(instr.funct3)) : begin
                `uvm_fatal(get_name(), "Scalar_FP not supported yet")
                return SRC_SCALAR_FP;
            end
            default : begin
                `uvm_fatal(get_name(), "VS1 type not found")
            end
        endcase
    endfunction: get_vs1_type


    //Get vs2 type
    virtual function riscv_v_src_type_t get_vs2_type(riscv_v_type_instruction_t instr);
        return SRC_VEC;
    endfunction: get_vs2_type

    //Is scalar
    virtual function bit is_scalar(riscv_v_type_instruction_t instr);
        return f_is_scalar_op(riscv_v_funct3_e'(instr.funct3));
    endfunction: is_scalar

    //Get ALU
    virtual function riscv_v_alu_e get_ALU(riscv_v_opcode_e opcode);

        if (opcode inside {
            BW_AND, BW_AND_REDUCT,
            BW_OR, BW_OR_REDUCT,
            BW_XOR, BW_XOR_REDUCT,
            SLL, SRL, SRA
        }) begin
            return LOGIC_ALU;
        end else if (opcode inside {
            ADDC, ADD, ADD_REDUCT,
            SUBB, SUB, SUB_REDUCT,
            SIGN_EXT, ZERO_EXT,
            MINS, MINS_REDUCT, MINU, MINU_REDUCT,
            MAXS, MAXS_REDUCT, MAXU, MAXU_REDUCT, 
            MULLS, MULHS, MULLU, MULHU, 
            SEQ, SNE, SLE, SLEU, SLT, SLTU, SGT, SGTU,
            MAND, MNAND, MANDN, MXOR, MOR, MNOR, MORN, MXNOR
        }) begin
            return ARITHMETIC_ALU;
        end else if (opcode inside {1'b0}) begin
            return MASK_ALU;
        end else if (opcode inside {
            I2V, V2I
        }) begin
            return PERMUTATION_ALU;
        end else begin
            `uvm_fatal(get_name(), $sformatf("ALU not found for op: %s", opcode.name()))
        end

    endfunction: get_ALU 

    //Write Vector destination
    virtual function bit write_vec_dest(riscv_v_opcode_e opcode);
        return (opcode != V2I);
    endfunction: write_vec_dest

    //Write integer destination
    virtual function bit write_int_dest(riscv_v_opcode_e opcode);
        return (opcode == I2V);
    endfunction: write_int_dest

    //Write floating point destination
    virtual function bit write_fp_dest(riscv_v_opcode_e opcode);
        return 1'b0;
    endfunction: write_fp_dest

    //Get Immediate
    virtual function riscv_v_imm_t get_imm(riscv_v_type_instruction_t instr);
        return instr.vs1;
    endfunction: get_imm 

    //Get source osize
    virtual function riscv_v_osize_e get_src_osize(riscv_v_vtype_t vtype, riscv_v_opcode_e opcode, riscv_instr_rs_t vs1, riscv_v_osize_e dst_osize);
        riscv_v_osize_e src_osize;

        if (opcode == ZERO_EXT) begin

            unique case(dst_osize)
                OSIZE_16: begin
                    unique case (vs1)
                        RISCV_V_ZEXT_VF8 : src_osize = OSIZE_8;
                        RISCV_V_ZEXT_VF4 : src_osize = OSIZE_8;
                        RISCV_V_ZEXT_VF2 : src_osize = OSIZE_8;
                        default : `uvm_fatal(get_name(), $sformatf("Invalid VS1 for ZERO_EXT, vs1: %0b", vs1))
                    endcase
                end
                OSIZE_32: begin
                    unique case (vs1)
                        RISCV_V_ZEXT_VF8 : src_osize = OSIZE_8;
                        RISCV_V_ZEXT_VF4 : src_osize = OSIZE_8;
                        RISCV_V_ZEXT_VF2 : src_osize = OSIZE_16;
                        default : `uvm_fatal(get_name(), $sformatf("Invalid VS1 for ZERO_EXT, vs1: %0b", vs1))
                    endcase
                end
                OSIZE_64: begin
                    unique case (vs1)
                        RISCV_V_ZEXT_VF8 : src_osize = OSIZE_8;
                        RISCV_V_ZEXT_VF4 : src_osize = OSIZE_16;
                        RISCV_V_ZEXT_VF2 : src_osize = OSIZE_32;
                        default : `uvm_fatal(get_name(), $sformatf("Invalid VS1 for ZERO_EXT, vs1: %0b", vs1))
                    endcase
                end
                OSIZE_128: begin
                    unique case (vs1)
                        RISCV_V_ZEXT_VF8 : src_osize = OSIZE_16;
                        RISCV_V_ZEXT_VF4 : src_osize = OSIZE_32;
                        RISCV_V_ZEXT_VF2 : src_osize = OSIZE_64;
                        default : `uvm_fatal(get_name(), $sformatf("Invalid VS1 for ZERO_EXT, vs1: %0b", vs1))
                    endcase
                end
                default : `uvm_fatal(get_name(), $sformatf("Invalid dst_osize: %0s", dst_osize))
            endcase
            
        end else if (opcode == SIGN_EXT) begin
            unique case(dst_osize)
                OSIZE_16: begin
                    unique case (vs1)
                        RISCV_V_SEXT_VF8 : src_osize = OSIZE_8;
                        RISCV_V_SEXT_VF4 : src_osize = OSIZE_8;
                        RISCV_V_SEXT_VF2 : src_osize = OSIZE_8;
                        default : `uvm_fatal(get_name(), $sformatf("Invalid VS1 for ZERO_EXT, vs1: %0b", vs1))
                    endcase
                end
                OSIZE_32: begin
                    unique case (vs1)
                        RISCV_V_SEXT_VF8 : src_osize = OSIZE_8;
                        RISCV_V_SEXT_VF4 : src_osize = OSIZE_8;
                        RISCV_V_SEXT_VF2 : src_osize = OSIZE_16;
                        default : `uvm_fatal(get_name(), $sformatf("Invalid VS1 for ZERO_EXT, vs1: %0b", vs1))
                    endcase
                end
                OSIZE_64: begin
                    unique case (vs1)
                        RISCV_V_SEXT_VF8 : src_osize = OSIZE_8;
                        RISCV_V_SEXT_VF4 : src_osize = OSIZE_16;
                        RISCV_V_SEXT_VF2 : src_osize = OSIZE_32;
                        default : `uvm_fatal(get_name(), $sformatf("Invalid VS1 for ZERO_EXT, vs1: %0b", vs1))
                    endcase
                end
                OSIZE_128: begin
                    unique case (vs1)
                        RISCV_V_SEXT_VF8 : src_osize = OSIZE_16;
                        RISCV_V_SEXT_VF4 : src_osize = OSIZE_32;
                        RISCV_V_SEXT_VF2 : src_osize = OSIZE_64;
                        default : `uvm_fatal(get_name(), $sformatf("Invalid VS1 for ZERO_EXT, vs1: %0b", vs1))
                    endcase
                end
                default : `uvm_fatal(get_name(), $sformatf("Invalid dst_osize: %0s", dst_osize))
            endcase
        end else begin
            src_osize = riscv_v_osize_e'(vtype.vsew);
        end
        
        return src_osize;
    endfunction: get_src_osize

    //Get source osize
    virtual function riscv_v_osize_e get_dst_osize(riscv_v_vtype_t vtype);
        return riscv_v_osize_e'(vtype.vsew);
    endfunction: get_dst_osize

    virtual function riscv_v_vlen_t get_len(riscv_v_vl_t vl, riscv_v_osize_e osize);
        riscv_v_vlen_t len;
        len = vl.len;
        return len;
    endfunction: get_len

    virtual function riscv_v_src_start_t get_start(riscv_v_vstart_t vstart);
        return vstart.index;
    endfunction: get_start 

    virtual function riscv_v_valid_data_t get_valid(riscv_v_vtype_t vtype, riscv_v_vl_t vl, riscv_v_vstart_t vstart, bit use_mask, riscv_v_mask_t mask, bit is_mask, bit is_reduct, bit is_i2v, bit is_v2i);
        riscv_v_osize_e osize;
        riscv_v_vlen_t len;
        riscv_v_valid_data_t valid;
        int num_bytes_osize;

        osize = riscv_v_osize_e'(vtype.vsew);
        len   = vl.len;
        //Set valid to all 1
        valid = '1;

        //Get number of bytes per osize
        unique case(osize)
            OSIZE_8   : num_bytes_osize = 1;
            OSIZE_16  : num_bytes_osize = 2;
            OSIZE_32  : num_bytes_osize = 4;
            OSIZE_64  : num_bytes_osize = 8;
            OSIZE_128 : num_bytes_osize = 16;
            default : `uvm_fatal(get_name(), $sformatf("Invalid OSIZE: %s", osize.name()))
        endcase

        //Turn off valid bits with vstart
        for (int idx = 0; idx < (vstart.index * num_bytes_osize); idx++) begin
            valid[idx] = 1'b0;
        end

        //Turn off valid bits with vlen 
        for (int idx = (len*num_bytes_osize); idx < RISCV_V_NUM_ELEMENTS_REG; idx++) begin
            valid[idx] = 1'b0;
        end

        //Turn off valid bits with mask
        if (use_mask) begin
            unique case(osize) 
                OSIZE_8 : begin
                    for (int idx = 0; idx < RISCV_V_NUM_BYTES_DATA; idx++) begin
                        valid[(idx) +: 1] &= mask[idx];
                    end
                end
                OSIZE_16 : begin
                    for (int idx = 0; idx < RISCV_V_NUM_WORDS_DATA; idx++) begin
                        valid[(idx*2) +: 2] &= {2{mask[idx]}};
                    end
                end
                OSIZE_32 : begin
                    for (int idx = 0; idx < RISCV_V_NUM_DWORDS_DATA; idx++) begin
                        valid[(idx*4) +: 4] &= {4{mask[idx]}};
                    end
                end
                OSIZE_64 : begin
                    for (int idx = 0; idx < RISCV_V_NUM_QWORDS_DATA; idx++) begin
                        valid[(idx*8) +: 8] &= {8{mask[idx]}};
                    end
                end
                OSIZE_128 : begin
                    for (int idx = 0; idx < RISCV_V_NUM_DQWORDS_DATA; idx++) begin
                        valid[(idx*16) +: 16] &= {16{mask[idx]}};
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("Invalid OSIZE: %s", osize.name()))
            endcase
        end 

        //Turn off valid bits if is a reduct operation
        if (is_reduct) begin
            unique case(osize)
                OSIZE_8 : begin
                    valid[RISCV_V_NUM_BYTES_DATA-1:(BYTE_WIDTH/BYTE_WIDTH)] = '0;
                end
                OSIZE_16 : begin
                    valid[RISCV_V_NUM_BYTES_DATA-1:(WORD_WIDTH/BYTE_WIDTH)] = '0;
                end
                OSIZE_32 : begin
                    valid[RISCV_V_NUM_BYTES_DATA-1:(DWORD_WIDTH/BYTE_WIDTH)] = '0;
                end
                OSIZE_64 : begin
                    valid[RISCV_V_NUM_BYTES_DATA-1:(QWORD_WIDTH/BYTE_WIDTH)] = '0;
                end 
                default : `uvm_fatal(get_name(), $sformatf("Invalid OSIZE: %s", osize.name()))
            endcase
        end

        //Turn off valid bits if is i2v
        if (is_i2v) begin
            unique case(osize)
                OSIZE_8 : begin
                    valid[RISCV_V_NUM_ELEMENTS_REG-1 : 1] = '0;
                end
                OSIZE_16 : begin
                    valid[RISCV_V_NUM_ELEMENTS_REG-1 : 2] = '0;
                end
                OSIZE_32 : begin
                    valid[RISCV_V_NUM_ELEMENTS_REG-1 : 4] = '0;
                end
                OSIZE_64 : begin
                    valid[RISCV_V_NUM_ELEMENTS_REG-1 : 8] = '0;
                end
                OSIZE_128 : begin
                    //Don't need to turn off bits here
                end
                default : `uvm_fatal(get_name(), $sformatf("Invalid OSIZE: %s", osize.name()))
            endcase
            
        end

        //Turn off valid bits if is v2i
        if (is_v2i) begin
            valid = '0;
        end

        //Turn off valid bits if is a mask operations
        if (is_mask) begin
            valid[RISCV_V_NUM_ELEMENTS_REG-1 : RISCV_V_NUM_BYTES_ALLOCATE_MASK] = '0;
            valid[RISCV_V_NUM_BYTES_ALLOCATE_MASK-1:0] = '1;
        end


        return valid;

    endfunction: get_valid

    virtual function bit get_use_mask(riscv_v_type_instruction_t instr, use_carry);
        return f_use_mask(instr.vm, use_carry);
    endfunction: get_use_mask

    virtual function bit get_is_mask(riscv_v_type_instruction_t instr);
        bit is_OPMVV;
        bit is_OPIVV;
        bit is_OPIVX;
        bit is_OPIVI;
        bit is_OPIVV_OPIVX;
        bit is_OPIVX_OPIVI;
        bit is_OPI;

        is_OPIVV       = (instr.funct3 == OPIVV);
        is_OPIVX       = (instr.funct3 == OPIVX);
        is_OPIVI       = (instr.funct3 == OPIVI);
        is_OPIVV_OPIVX = (is_OPIVV || is_OPIVV_OPIVX);
        is_OPIVX_OPIVI = (is_OPIVX || is_OPIVI); 
        is_OPI         = (is_OPIVV || is_OPIVX|| is_OPIVI);
        is_OPMVV       = (instr.funct3 == OPMVV);
        return f_is_mask(instr.funct6, is_OPMVV, is_OPI, is_OPIVV_OPIVX, is_OPIVX_OPIVI);

    endfunction: get_is_mask

    virtual function bit get_is_reduct(riscv_v_opcode_e opcode);
        if (opcode inside {BW_AND_REDUCT, BW_OR_REDUCT, BW_XOR_REDUCT,
                           ADD_REDUCT, SUB_REDUCT, MINS_REDUCT, MINU_REDUCT,
                           MAXS_REDUCT, MAXU_REDUCT}) begin
            return 1'b1;
        end else begin
            return 1'b0;
        end
    endfunction: get_is_reduct

    virtual function bit get_is_compare(riscv_v_type_instruction_t instr);
        bit is_compare;
        bit is_OPIVV;
        bit is_OPIVX;
        bit is_OPIVI;
        bit is_OPIVV_OPIVX;
        bit is_OPIVX_OPIVI;
        bit is_OPI;

        is_OPIVV       = (instr.funct3 == OPIVV);
        is_OPIVX       = (instr.funct3 == OPIVX);
        is_OPIVI       = (instr.funct3 == OPIVI);
        is_OPIVV_OPIVX = (is_OPIVV || is_OPIVV_OPIVX);
        is_OPIVX_OPIVI = (is_OPIVX || is_OPIVI); 
        is_OPI         = (is_OPIVV || is_OPIVX|| is_OPIVI);
        is_compare = f_is_compare(instr.funct6, is_OPI, is_OPIVV_OPIVX, is_OPIVX_OPIVI);

        return is_compare;
    endfunction: get_is_compare

    virtual function bit get_use_carry(riscv_v_type_instruction_t instr);
        bit use_carry;
        bit is_OPIVV;
        bit is_OPIVX;
        bit is_OPIVI;
        bit is_OPIVV_OPIVX;
        bit is_OPI;

        is_OPIVV       = (instr.funct3 == OPIVV);
        is_OPIVX       = (instr.funct3 == OPIVX);
        is_OPIVI       = (instr.funct3 == OPIVI);
        is_OPIVV_OPIVX = (is_OPIVV || is_OPIVX);
        is_OPI         = (is_OPIVV || is_OPIVX|| is_OPIVI);
        use_carry = f_use_carry(instr.funct6, is_OPI, is_OPIVV_OPIVX);

        return use_carry;
    endfunction: get_use_carry

    virtual function bit get_is_shift(riscv_v_type_instruction_t instr);
        bit is_shift;
        bit is_OPIVV;
        bit is_OPIVX;
        bit is_OPIVI;
        bit is_OPI;

        is_OPIVV       = (instr.funct3 == OPIVV);
        is_OPIVX       = (instr.funct3 == OPIVX);
        is_OPIVI       = (instr.funct3 == OPIVI);
        is_OPI         = (is_OPIVV || is_OPIVX|| is_OPIVI);

        is_shift = f_is_shift(instr.funct6, is_OPI);

        return is_shift;
    endfunction: get_is_shift

    virtual function bit get_is_i2v(riscv_v_type_instruction_t instr);
        bit is_i2v;
        bit is_OPIVX;

        is_OPIVX       = (instr.funct3 == OPIVX);

        is_i2v = f_is_i2v(instr.funct6, is_OPIVX);

        return is_i2v;
    endfunction: get_is_i2v 

    virtual function bit get_is_v2i(riscv_v_type_instruction_t instr);
        bit is_v2i;
        bit is_OPIVV;

        is_OPIVV       = (instr.funct3 == OPIVV);

        is_v2i = f_is_v2i(instr.funct6, is_OPIVV);

        return is_v2i;
    endfunction: get_is_v2i 

endclass: riscv_v_decode_model

`endif //__RISCV_V_DECODE_MODEL__