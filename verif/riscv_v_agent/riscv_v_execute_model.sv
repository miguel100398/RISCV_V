//File: riscv_v_execute_model
//Author: Miguel Bucio
//Date: 16/04/24
//Description: RiscV V Execute Model

`ifndef __RISCV_V_EXECUTE_MODEL__
`define __RISCV_V_EXECUTE_MODEL__

class riscv_v_execute_model extends riscv_v_base_model;
    `uvm_component_utils(riscv_v_execute_model)

    //ALUS
    riscv_v_logic_alu_model       logic_alu;
    riscv_v_arithmetic_alu_model  arithmetic_alu;
    riscv_v_mask_alu_model        mask_alu;
    riscv_v_permutation_alu_model permutation_alu;

    function new(string name = "riscv_v_execute_model", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        logic_alu       = riscv_v_logic_alu_model::type_id::create("riscv_v_logic_alu_model", this);
        arithmetic_alu  = riscv_v_arithmetic_alu_model::type_id::create("riscv_v_arithmetic_alu_model", this);
        mask_alu        = riscv_v_mask_alu_model::type_id::create("riscv_v_mask_alu_model", this);
        permutation_alu = riscv_v_permutation_alu_model::type_id::create("riscv_v_permutation_alu_model", this);
    endfunction: build_phase

    virtual function void rst();
        logic_alu.rst();
        arithmetic_alu.rst();
        mask_alu.rst();
        permutation_alu.rst();
    endfunction: rst 

    virtual function void execute_op(
        input  riscv_v_opcode_e    opcode,
        input  riscv_v_osize_e     src_osize,
        input  riscv_v_osize_e     dst_osize,
        input  riscv_v_alu_e       ALU,
        input  bit                 is_scalar,
        input  riscv_v_src_type_t  srca_type,
        input  riscv_v_src_type_t  srcb_type,
        input  riscv_v_data_t      srca_vec,
        input  riscv_v_data_t      srcb_vec,
        input  riscv_data_t        src_int,
        input  riscv_v_imm_t       src_imm,
        input  riscv_v_vlen_t      len,
        input  riscv_v_src_start_t start,
        input  bit                 use_mask,
        input  bit                 is_shift,
        input  riscv_v_mask_t      mask,
        input  riscv_v_mask_t      dst_mask_merge,
        output riscv_v_data_t      vec_result,
        output riscv_data_t        int_result
    );
        riscv_v_data_t srca;
        riscv_v_data_t srcb;

        vec_result = 'x;
        int_result = 'x;

        //Format sources if one source is scalar
        srca = get_src(srca_type, srca_vec, src_int, src_imm, src_osize, is_shift);
        srcb = get_src(srcb_type, srcb_vec, src_int, src_imm, src_osize, is_shift);

        //Execute op in ALU
        unique case(ALU)
            LOGIC_ALU : begin
                vec_result = logic_alu.execute_vec_op(srca, srcb, is_scalar, opcode, src_osize, dst_osize, len, start, mask, dst_mask_merge, use_mask);
            end
            ARITHMETIC_ALU : begin
                vec_result = arithmetic_alu.execute_vec_op(srca, srcb, is_scalar, opcode, src_osize, dst_osize, len, start, mask, dst_mask_merge, use_mask);
            end
            MASK_ALU : begin
                vec_result = mask_alu.execute_vec_op(srca, srcb, is_scalar, opcode, src_osize, dst_osize, len, start, mask, dst_mask_merge, use_mask);
            end
            PERMUTATION_ALU : begin
                if (opcode == V2I) begin
                    int_result = permutation_alu.execute_v2i_op(srcb, opcode, src_osize);
                end else begin
                    vec_result = permutation_alu.execute_vec_op(srca, srcb, is_scalar, opcode, src_osize, dst_osize, len, start, mask, dst_mask_merge, use_mask);
                end
            end
            default : `uvm_fatal(get_name(), $sformatf("Invalid ALU: %s", ALU.name()))
        endcase

    endfunction: execute_op

    virtual function riscv_v_data_t get_src(riscv_v_src_type_t src_type, riscv_v_data_t src_vec, riscv_data_t src_int, riscv_v_imm_t src_imm, riscv_v_osize_e osize, bit unsigned_imm);
        riscv_v_data_t src;

        src = 'x;

        unique case(src_type)
            SRC_VEC : begin
                src =  src_vec;
            end
            SRC_SCALAR_VEC : begin
                unique case(osize)
                    OSIZE_8: begin
                        src.Byte[0] = src_vec.Byte[0];
                    end
                    OSIZE_16: begin
                        src.Word[0] = src_vec.Word[0];
                    end
                    OSIZE_32: begin
                        src.Dword[0] = src_vec.Dword[0];
                    end
                    OSIZE_64: begin
                        src.Qword[0] = src_vec.Qword[0];
                    end
                    OSIZE_128: begin
                        src.Dqword[0] = src_vec.Dqword[0];
                    end
                    default : `uvm_fatal(get_name(), $sformatf("Invalid OSIZE:%0s", osize.name()))
                endcase
            end
            SRC_SCALAR_INT : begin
                unique case(osize)
                    OSIZE_8: begin
                        src.Byte[0] = src_int[BYTE_WIDTH-1 : 0];
                    end
                    OSIZE_16: begin
                        src.Word[0] = src_int[WORD_WIDTH-1 : 0];
                    end
                    OSIZE_32: begin
                        src.Dword[0] = src_int[DWORD_WIDTH-1 : 0];
                    end
                    OSIZE_64: begin
                        src.Qword[0] = `RISCV_V_SX(src_int, QWORD_WIDTH);
                    end
                    OSIZE_128: begin
                        src.Dqword[0] = `RISCV_V_SX(src_int, DQWORD_WIDTH);
                    end
                    default : `uvm_fatal(get_name(), $sformatf("Invalid OSIZE:%0s", osize.name()))
                endcase
            end
            SRC_SCALAR_IMM : begin
                unique case(osize)
                    OSIZE_8: begin
                        if (unsigned_imm) begin
                            src.Byte[0] = `RISCV_V_ZX(src_imm, BYTE_WIDTH);
                        end else begin
                            src.Byte[0] = `RISCV_V_SX(src_imm, BYTE_WIDTH);
                        end
                    end
                    OSIZE_16: begin
                        if (unsigned_imm) begin
                            src.Word[0] = `RISCV_V_ZX(src_imm, WORD_WIDTH);
                        end else begin
                            src.Word[0] = `RISCV_V_SX(src_imm, WORD_WIDTH);
                        end
                    end
                    OSIZE_32: begin
                        if (unsigned_imm) begin
                            src.Dword[0] = `RISCV_V_ZX(src_imm, DWORD_WIDTH);
                        end else begin
                            src.Dword[0] = `RISCV_V_SX(src_imm, DWORD_WIDTH);
                        end
                    end
                    OSIZE_64: begin
                        if (unsigned_imm) begin
                            src.Qword[0] = `RISCV_V_ZX(src_imm, QWORD_WIDTH);
                        end else begin
                            src.Qword[0] = `RISCV_V_SX(src_imm, QWORD_WIDTH);
                        end
                    end
                    OSIZE_128: begin
                        if (unsigned_imm) begin
                            src.Dqword[0] = `RISCV_V_ZX(src_imm, DQWORD_WIDTH);
                        end else begin
                            src.Dqword[0] = `RISCV_V_SX(src_imm, DQWORD_WIDTH);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("Invalid OSIZE:%0s", osize.name()))
                endcase
            end
            SRC_SCALAR_FP : begin
                `uvm_fatal(get_name(), "SRC_SCALAR_FP not supported yet")
            end
            default : `uvm_fatal(get_name(), $sformatf("Invalid SRC_TYPE: %s", src_type.name()))
        endcase

        return src;

    endfunction: get_src

endclass: riscv_v_execute_model

`endif //__RISCV_V_EXECUTE_MODEL__ 