//File: riscv_v_arithmetic_alu_model
//Author: Miguel Bucio
//Date: 16/04/24
//Description: RiscV V arithmetic ALU Model

`ifndef __RISCV_V_ARITHMETIC_ALU_MODEL__
`define __RISCV_V_ARITHMETIC_ALU_MODEL__ 

class riscv_v_arithmetic_alu_model extends riscv_v_alu_base_model;
    `uvm_component_utils(riscv_v_arithmetic_alu_model)

    function new(string name = "riscv_v_arithmetic_alu_model", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new 

    virtual function riscv_v_data_t execute_vec_op(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_opcode_e opcode, riscv_v_osize_e src_osize, riscv_v_osize_e dst_osize, riscv_v_vlen_t len, riscv_v_src_start_t start, riscv_v_mask_t mask, riscv_v_mask_t dst_mask_merge, bit use_mask);
        riscv_v_data_t result = 'x;
        riscv_v_src_len_t len_op;

        len_op = get_len_op(len, dst_osize);
        
        unique case(opcode)
            ADD         : result = calc_add          (srca, srcb, is_scalar, dst_osize, len_op, start);
            ADD_REDUCT  : result = calc_add_reduct   (srca, srcb, dst_osize, len_op, start, mask, use_mask);
            ADDC        : result = calc_addc         (srca, srcb, is_scalar, dst_osize, len_op, start, mask);
            SUB         : result = calc_sub          (srca, srcb, is_scalar, dst_osize, len_op, start);
            SUBB        : result = calc_subb         (srca, srcb, is_scalar, dst_osize, len_op, start, mask);
            ZERO_EXT    : result = calc_zext         (srcb, dst_osize, src_osize, len_op, start);
            SIGN_EXT    : result = calc_sext         (srcb, dst_osize, src_osize, len_op, start);
            MULLS       : result = calc_mulls        (srca, srcb, is_scalar, dst_osize, len_op, start);
            MULHS       : result = calc_mulhs        (srca, srcb, is_scalar, dst_osize, len_op, start);
            MULHU       : result = calc_mulhu        (srca, srcb, is_scalar, dst_osize, len_op, start);
            SEQ         : result = calc_seq          (srca, srcb, is_scalar, dst_osize, len_op, start, mask,  dst_mask_merge, use_mask);
            SNE         : result = calc_sne          (srca, srcb, is_scalar, dst_osize, len_op, start, mask,  dst_mask_merge, use_mask);
            SLE         : result = calc_sle          (srca, srcb, is_scalar, dst_osize, len_op, start, mask,  dst_mask_merge, use_mask);
            SLEU        : result = calc_sleu         (srca, srcb, is_scalar, dst_osize, len_op, start, mask,  dst_mask_merge, use_mask);
            SLT         : result = calc_slt          (srca, srcb, is_scalar, dst_osize, len_op, start, mask,  dst_mask_merge, use_mask);
            SLTU        : result = calc_sltu         (srca, srcb, is_scalar, dst_osize, len_op, start, mask,  dst_mask_merge, use_mask);
            SGT         : result = calc_sgt          (srca, srcb, is_scalar, dst_osize, len_op, start, mask,  dst_mask_merge, use_mask);
            SGTU        : result = calc_sgtu         (srca, srcb, is_scalar, dst_osize, len_op, start, mask,  dst_mask_merge, use_mask);
            MINS        : result = calc_mins         (srca, srcb, is_scalar, dst_osize, len_op, start);
            MINU        : result = calc_minu         (srca, srcb, is_scalar, dst_osize, len_op, start);
            MAXS        : result = calc_maxs         (srca, srcb, is_scalar, dst_osize, len_op, start);
            MAXU        : result = calc_maxu         (srca, srcb, is_scalar, dst_osize, len_op, start);
            MINS_REDUCT : result = calc_mins_reduct  (srca, srcb, dst_osize, len_op, start, mask, use_mask);
            MINU_REDUCT : result = calc_minu_reduct  (srca, srcb, dst_osize, len_op, start, mask, use_mask);
            MAXS_REDUCT : result = calc_maxs_reduct  (srca, srcb, dst_osize, len_op, start, mask, use_mask);
            MAXU_REDUCT : result = calc_maxu_reduct  (srca, srcb, dst_osize, len_op, start, mask, use_mask);
            default : `uvm_fatal(get_name(), $sformatf("Invalid opcode: %s", opcode.name()))
        endcase

        return result;
    endfunction: execute_vec_op

    virtual function riscv_v_data_t calc_add(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start);

        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin

            unique case(osize)

                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = signed'(srca.Byte[idx]) + signed'(srcb.Byte[idx]);
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = signed'(srca.Word[idx]) + signed'(srcb.Word[idx]);
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = signed'(srca.Dword[idx]) + signed'(srcb.Dword[idx]);
                    end
                end
                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = signed'(srca.Qword[idx]) + signed'(srcb.Qword[idx]);
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = signed'(srca.Dqword[idx]) + signed'(srcb.Dqword[idx]);
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))

            endcase

        end else begin

            unique case(osize)

                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = signed'(srca.Byte[0]) + signed'(srcb.Byte[idx]);
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = signed'(srca.Word[0]) + signed'(srcb.Word[idx]);
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = signed'(srca.Dword[0]) + signed'(srcb.Dword[idx]);
                    end
                end
                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = signed'(srca.Qword[0]) + signed'(srcb.Qword[idx]);
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = signed'(srca.Dqword[0]) + signed'(srcb.Dqword[idx]);
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))

            endcase

        end

        return result;

    endfunction: calc_add

    virtual function riscv_v_data_t calc_add_reduct(riscv_v_data_t srca, riscv_v_data_t srcb, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start, riscv_v_mask_t mask, bit use_mask);
        riscv_v_data_t result;
        result = 'x;

        if(start != 0) begin
            `uvm_fatal(get_name(), "Start different from 0 not supported for this op, VREDSUM")
        end

        if (len == 0) begin
            return result;
        end

        unique case(osize)
            OSIZE_8 : begin
                if (~use_mask | mask[0]) begin
                    result.Byte[0] = signed'(srcb.Byte[0]) + signed'(srca.Byte[0]);
                end else begin
                    result.Byte[0] = signed'(srca.Byte[0]);
                end
                for (int idx = 1; idx <len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Byte[0] = signed'(srcb.Byte[idx]) + signed'(result.Byte[0]);
                    end
                end
            end
            OSIZE_16 : begin
                if (~use_mask | mask[0]) begin
                    result.Word[0] = signed'(srcb.Word[0]) + signed'(srca.Word[0]);
                end else begin
                    result.Word[0] = signed'(srca.Word[0]);
                end
                for (int idx = 1; idx <len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Word[0] = signed'(srcb.Word[idx]) + signed'(result.Word[0]);
                    end
                end
            end
            OSIZE_32 : begin
                if (~use_mask | mask[0]) begin
                    result.Dword[0] = signed'(srcb.Dword[0]) + signed'(srca.Dword[0]);
                end else begin
                    result.Dword[0] = signed'(srca.Dword[0]);
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Dword[0] = signed'(srcb.Dword[idx]) + signed'(result.Dword[0]);
                    end
                end
            end
            OSIZE_64 : begin
                if (~use_mask | mask[0]) begin
                    result.Qword[0] = signed'(srcb.Qword[0]) + signed'(srca.Qword[0]);
                end else begin
                    result.Qword[0] = signed'(srca.Qword[0]);
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Qword[0] = signed'(srcb.Qword[idx]) + signed'(result.Qword[0]);
                    end
                end
            end
            default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
        endcase 

        return result;
    endfunction: calc_add_reduct

    virtual function riscv_v_data_t calc_addc(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start, riscv_v_mask_t carry_in);

        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin

            unique case(osize)

                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = signed'(srca.Byte[idx]) + signed'(srcb.Byte[idx]) + carry_in[idx];
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = signed'(srca.Word[idx]) + signed'(srcb.Word[idx]) + carry_in[idx];
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = signed'(srca.Dword[idx]) + signed'(srcb.Dword[idx]) + carry_in[idx];
                    end
                end
                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = signed'(srca.Qword[idx]) + signed'(srcb.Qword[idx]) + carry_in[idx];
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = signed'(srca.Dqword[idx]) + signed'(srcb.Dqword[idx]) + carry_in[idx];
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))

            endcase

        end else begin

            unique case(osize)

                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = signed'(srca.Byte[0]) + signed'(srcb.Byte[idx]) + carry_in[idx];
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = signed'(srca.Word[0]) + signed'(srcb.Word[idx]) + carry_in[idx];
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = signed'(srca.Dword[0]) + signed'(srcb.Dword[idx]) + carry_in[idx];
                    end
                end
                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = signed'(srca.Qword[0]) + signed'(srcb.Qword[idx]) + carry_in[idx];
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = signed'(srca.Dqword[0]) + signed'(srcb.Dqword[idx]) + carry_in[idx];
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))

            endcase

        end

        return result;

    endfunction: calc_addc

    virtual function riscv_v_data_t calc_sub(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start);

        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin

            unique case(osize)

                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = signed'(srca.Byte[idx]) - signed'(srcb.Byte[idx]);
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = signed'(srca.Word[idx]) - signed'(srcb.Word[idx]);
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = signed'(srca.Dword[idx]) - signed'(srcb.Dword[idx]);
                    end
                end
                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = signed'(srca.Qword[idx]) - signed'(srcb.Qword[idx]);
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = signed'(srca.Dqword[idx]) - signed'(srcb.Dqword[idx]);
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))

            endcase

        end else begin

            unique case(osize)

                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = signed'(srca.Byte[0]) - signed'(srcb.Byte[idx]);
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = signed'(srca.Word[0]) - signed'(srcb.Word[idx]);
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = signed'(srca.Dword[0]) - signed'(srcb.Dword[idx]);
                    end
                end
                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = signed'(srca.Qword[0]) - signed'(srcb.Qword[idx]);
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = signed'(srca.Dqword[0]) - signed'(srcb.Dqword[idx]);
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))

            endcase

        end

        return result;

    endfunction: calc_sub

    virtual function riscv_v_data_t calc_subb(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start, riscv_v_mask_t borrow_in);

        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin

            unique case(osize)

                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = signed'(srca.Byte[idx]) - signed'(srcb.Byte[idx]) - borrow_in[idx];
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = signed'(srca.Word[idx]) - signed'(srcb.Word[idx]) - borrow_in[idx];
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = signed'(srca.Dword[idx]) - signed'(srcb.Dword[idx]) - borrow_in[idx];
                    end
                end
                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = signed'(srca.Qword[idx]) - signed'(srcb.Qword[idx]) - borrow_in[idx];
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = signed'(srca.Dqword[idx]) - signed'(srcb.Dqword[idx]) - borrow_in[idx];
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))

            endcase

        end else begin

            unique case(osize)

                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = signed'(srca.Byte[0]) - signed'(srcb.Byte[idx]) - borrow_in[idx];
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = signed'(srca.Word[0]) - signed'(srcb.Word[idx]) - borrow_in[idx];
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = signed'(srca.Dword[0]) - signed'(srcb.Dword[idx]) - borrow_in[idx];
                    end
                end
                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = signed'(srca.Qword[0]) - signed'(srcb.Qword[idx]) - borrow_in[idx];
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = signed'(srca.Dqword[0]) - signed'(srcb.Dqword[idx]) - borrow_in[idx];
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))

            endcase

        end

        return result;

    endfunction: calc_subb

    virtual function riscv_v_data_t calc_zext(riscv_v_data_t srcb, riscv_v_osize_e dst_osize, riscv_v_osize_e src_osize, riscv_v_src_len_t len, riscv_v_src_start_t start);

        riscv_v_data_t result;
        result = 'x;

        unique case (dst_osize)
            OSIZE_8: begin
                unique case(src_osize)
                    OSIZE_8 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Byte[idx] = `RISCV_V_ZX(srcb.Byte[idx], 8);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("invalid src_osize: %0s", src_osize.name()))
                endcase
            end
            OSIZE_16 : begin
                unique case(src_osize)
                    OSIZE_8 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Word[idx] = `RISCV_V_ZX(srcb.Byte[idx], 16);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("invalid src_osize: %0s", src_osize.name()))
                endcase
            end
            OSIZE_32 : begin
                unique case(src_osize)
                    OSIZE_8 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Dword[idx] = `RISCV_V_ZX(srcb.Byte[idx], 32);
                        end
                    end
                    OSIZE_16 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Dword[idx] = `RISCV_V_ZX(srcb.Word[idx], 32);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("invalid src_osize: %0s", src_osize.name()))
                endcase
            end
            OSIZE_64 : begin
                unique case(src_osize)
                    OSIZE_8 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Qword[idx] = `RISCV_V_ZX(srcb.Byte[idx], 64);
                        end
                    end
                    OSIZE_16 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Qword[idx] = `RISCV_V_ZX(srcb.Word[idx], 64);
                        end
                    end
                    OSIZE_32 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Qword[idx] = `RISCV_V_ZX(srcb.Dword[idx], 64);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("invalid src_osize: %0s", src_osize.name()))
                endcase
            end
            OSIZE_128 : begin
                unique case(src_osize)
                    OSIZE_16 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Dqword[idx] = `RISCV_V_ZX(srcb.Word[idx], 128);
                        end
                    end
                    OSIZE_32 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Dqword[idx] = `RISCV_V_ZX(srcb.Dword[idx], 128);
                        end
                    end
                    OSIZE_64 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Dqword[idx] = `RISCV_V_ZX(srcb.Qword[idx], 128);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("invalid src_osize: %0s", src_osize.name()))
                endcase
            end
            default : `uvm_fatal(get_name(), $sformatf("invalid dst_osize: %0s", dst_osize.name()))
        endcase 

        return result;

    endfunction: calc_zext

    virtual function riscv_v_data_t calc_sext(riscv_v_data_t srcb, riscv_v_osize_e dst_osize, riscv_v_osize_e src_osize, riscv_v_src_len_t len, riscv_v_src_start_t start);

        riscv_v_data_t result;
        result = 'x;

        unique case (dst_osize)
            OSIZE_8: begin
                unique case(src_osize)
                    OSIZE_8 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Byte[idx] = `RISCV_V_SX(srcb.Byte[idx], 8);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("invalid src_osize: %0s", src_osize.name()))
                endcase
            end
            OSIZE_16 : begin
                unique case(src_osize)
                    OSIZE_8 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Word[idx] = `RISCV_V_SX(srcb.Byte[idx], 16);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("invalid src_osize: %0s", src_osize.name()))
                endcase
            end
            OSIZE_32 : begin
                unique case(src_osize)
                    OSIZE_8 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Dword[idx] = `RISCV_V_SX(srcb.Byte[idx], 32);
                        end
                    end
                    OSIZE_16 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Dword[idx] = `RISCV_V_SX(srcb.Word[idx], 32);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("invalid src_osize: %0s", src_osize.name()))
                endcase
            end
            OSIZE_64 : begin
                unique case(src_osize)
                    OSIZE_8 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Qword[idx] = `RISCV_V_SX(srcb.Byte[idx], 64);
                        end
                    end
                    OSIZE_16 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Qword[idx] = `RISCV_V_SX(srcb.Word[idx], 64);
                        end
                    end
                    OSIZE_32 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Qword[idx] = `RISCV_V_SX(srcb.Dword[idx], 64);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("invalid src_osize: %0s", src_osize.name()))
                endcase
            end
            OSIZE_128 : begin
                unique case(src_osize)
                    OSIZE_16 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Dqword[idx] = `RISCV_V_SX(srcb.Word[idx], 128);
                        end
                    end
                    OSIZE_32 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Dqword[idx] = `RISCV_V_SX(srcb.Dword[idx], 128);
                        end
                    end
                    OSIZE_64 : begin
                        for (int idx = start; idx < len; idx++) begin
                            result.Dqword[idx] = `RISCV_V_SX(srcb.Qword[idx], 128);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("invalid src_osize: %0s", src_osize.name()))
                endcase
            end
            default : `uvm_fatal(get_name(), $sformatf("invalid dst_osize: %0s", dst_osize.name()))
        endcase 

        return result;

    endfunction: calc_sext

    virtual function riscv_v_data_t calc_mulls(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start);

        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin
            unique case (osize)
                OSIZE_8 : begin
                    logic [(2*BYTE_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Byte[idx]) * signed'(srcb.Byte[idx]);
                        result.Byte[idx] = tmp_rslt[0 +: BYTE_WIDTH];
                    end
                end
                OSIZE_16 : begin
                    logic [(2*WORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Word[idx]) * signed'(srcb.Word[idx]);
                        result.Word[idx] = tmp_rslt[0 +: WORD_WIDTH];
                    end
                end
                OSIZE_32 : begin
                    logic [(2*DWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Dword[idx]) * signed'(srcb.Dword[idx]);
                        result.Dword[idx] = tmp_rslt[0 +: DWORD_WIDTH];
                    end
                end

                OSIZE_64 : begin
                    logic [(2*QWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Qword[idx]) * signed'(srcb.Qword[idx]);
                        result.Qword[idx] = tmp_rslt[0 +: QWORD_WIDTH];
                    end
                end
                OSIZE_128 : begin
                    logic [(2*DQWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Dqword[idx]) * signed'(srcb.Dqword[idx]);
                        result.Dqword[idx] = tmp_rslt[0 +: DQWORD_WIDTH];
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end else begin
            unique case (osize)
                OSIZE_8 : begin
                    logic [(2*BYTE_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Byte[0]) * signed'(srcb.Byte[idx]);
                        result.Byte[idx] = tmp_rslt[0 +: BYTE_WIDTH];
                    end
                end
                OSIZE_16 : begin
                    logic [(2*WORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Word[0]) * signed'(srcb.Word[idx]);
                        result.Word[idx] = tmp_rslt[0 +: WORD_WIDTH];
                    end
                end
                OSIZE_32 : begin
                    logic [(2*DWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Dword[0]) * signed'(srcb.Dword[idx]);
                        result.Dword[idx] = tmp_rslt[0 +: DWORD_WIDTH];
                    end
                end

                OSIZE_64 : begin
                    logic [(2*QWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Qword[0]) * signed'(srcb.Qword[idx]);
                        result.Qword[idx] = tmp_rslt[0 +: QWORD_WIDTH];
                    end
                end
                OSIZE_128 : begin
                    logic [(2*DQWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Dqword[0]) * signed'(srcb.Dqword[idx]);
                        result.Dqword[idx] = tmp_rslt[0 +: DQWORD_WIDTH];
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end

        return result;

    endfunction: calc_mulls

    virtual function riscv_v_data_t calc_mulhs(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start);

        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin
            unique case (osize)
                OSIZE_8 : begin
                    logic [(2*BYTE_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Byte[idx]) * signed'(srcb.Byte[idx]);
                        result.Byte[idx] = tmp_rslt[BYTE_WIDTH +: BYTE_WIDTH];
                    end
                end
                OSIZE_16 : begin
                    logic [(2*WORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Word[idx]) * signed'(srcb.Word[idx]);
                        result.Word[idx] = tmp_rslt[WORD_WIDTH +: WORD_WIDTH];
                    end
                end
                OSIZE_32 : begin
                    logic [(2*DWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Dword[idx]) * signed'(srcb.Dword[idx]);
                        result.Dword[idx] = tmp_rslt[DWORD_WIDTH +: DWORD_WIDTH];
                    end
                end

                OSIZE_64 : begin
                    logic [(2*QWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Qword[idx]) * signed'(srcb.Qword[idx]);
                        result.Qword[idx] = tmp_rslt[QWORD_WIDTH +: QWORD_WIDTH];
                    end
                end
                OSIZE_128 : begin
                    logic [(2*DQWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Dqword[idx]) * signed'(srcb.Dqword[idx]);
                        result.Dqword[idx] = tmp_rslt[DQWORD_WIDTH +: DQWORD_WIDTH];
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end else begin
            unique case (osize)
                OSIZE_8 : begin
                    logic [(2*BYTE_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Byte[0]) * signed'(srcb.Byte[idx]);
                        result.Byte[idx] = tmp_rslt[BYTE_WIDTH +: BYTE_WIDTH];
                    end
                end
                OSIZE_16 : begin
                    logic [(2*WORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Word[0]) * signed'(srcb.Word[idx]);
                        result.Word[idx] = tmp_rslt[WORD_WIDTH +: WORD_WIDTH];
                    end
                end
                OSIZE_32 : begin
                    logic [(2*DWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Dword[0]) * signed'(srcb.Dword[idx]);
                        result.Dword[idx] = tmp_rslt[DWORD_WIDTH +: DWORD_WIDTH];
                    end
                end

                OSIZE_64 : begin
                    logic [(2*QWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Qword[0]) * signed'(srcb.Qword[idx]);
                        result.Qword[idx] = tmp_rslt[QWORD_WIDTH +: QWORD_WIDTH];
                    end
                end
                OSIZE_128 : begin
                    logic [(2*DQWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = signed'(srca.Dqword[0]) * signed'(srcb.Dqword[idx]);
                        result.Dqword[idx] = tmp_rslt[DQWORD_WIDTH +: DQWORD_WIDTH];
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end

        return result;

    endfunction: calc_mulhs

    virtual function riscv_v_data_t calc_mulhu(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start);

        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin
            unique case (osize)
                OSIZE_8 : begin
                    logic [(2*BYTE_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = unsigned'(srca.Byte[idx]) * unsigned'(srcb.Byte[idx]);
                        result.Byte[idx] = tmp_rslt[BYTE_WIDTH +: BYTE_WIDTH];
                    end
                end
                OSIZE_16 : begin
                    logic [(2*WORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = unsigned'(srca.Word[idx]) * unsigned'(srcb.Word[idx]);
                        result.Word[idx] = tmp_rslt[WORD_WIDTH +: WORD_WIDTH];
                    end
                end
                OSIZE_32 : begin
                    logic [(2*DWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = unsigned'(srca.Dword[idx]) * unsigned'(srcb.Dword[idx]);
                        result.Dword[idx] = tmp_rslt[DWORD_WIDTH +: DWORD_WIDTH];
                    end
                end

                OSIZE_64 : begin
                    logic [(2*QWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = unsigned'(srca.Qword[idx]) * unsigned'(srcb.Qword[idx]);
                        result.Qword[idx] = tmp_rslt[QWORD_WIDTH +: QWORD_WIDTH];
                    end
                end
                OSIZE_128 : begin
                    logic [(2*DQWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = unsigned'(srca.Dqword[idx]) * unsigned'(srcb.Dqword[idx]);
                        result.Dqword[idx] = tmp_rslt[DQWORD_WIDTH +: DQWORD_WIDTH];
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end else begin
            unique case (osize)
                OSIZE_8 : begin
                    logic [(2*BYTE_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = unsigned'(srca.Byte[0]) * unsigned'(srcb.Byte[idx]);
                        result.Byte[idx] = tmp_rslt[BYTE_WIDTH +: BYTE_WIDTH];
                    end
                end
                OSIZE_16 : begin
                    logic [(2*WORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = unsigned'(srca.Word[0]) * unsigned'(srcb.Word[idx]);
                        result.Word[idx] = tmp_rslt[WORD_WIDTH +: WORD_WIDTH];
                    end
                end
                OSIZE_32 : begin
                    logic [(2*DWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = unsigned'(srca.Dword[0]) * unsigned'(srcb.Dword[idx]);
                        result.Dword[idx] = tmp_rslt[DWORD_WIDTH +: DWORD_WIDTH];
                    end
                end

                OSIZE_64 : begin
                    logic [(2*QWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = unsigned'(srca.Qword[0]) * unsigned'(srcb.Qword[idx]);
                        result.Qword[idx] = tmp_rslt[QWORD_WIDTH +: QWORD_WIDTH];
                    end
                end
                OSIZE_128 : begin
                    logic [(2*DQWORD_WIDTH)-1:0]  tmp_rslt;
                    for (int idx = start; idx < len; idx++) begin
                        tmp_rslt = unsigned'(srca.Dqword[0]) * unsigned'(srcb.Dqword[idx]);
                        result.Dqword[idx] = tmp_rslt[DQWORD_WIDTH +: DQWORD_WIDTH];
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end

        return result;

    endfunction: calc_mulhu

    virtual function riscv_v_data_t calc_seq(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start, riscv_v_mask_t mask, riscv_v_mask_t dst_mask_merge, bit use_mask);

        riscv_v_data_t result;
        result = 'x;
        result[RISCV_V_NUM_ELEMENTS_REG-1:0] = dst_mask_merge;


        if (~is_scalar) begin
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Byte[idx] == srcb.Byte[idx]);
                        end
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Word[idx] == srcb.Word[idx]);
                        end
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Dword[idx] == srcb.Dword[idx]);
                        end
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Qword[idx] == srcb.Qword[idx]);
                        end
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Dqword[idx] == srcb.Dqword[idx]);
                        end
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end else begin
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Byte[0] == srcb.Byte[idx]);
                        end
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Word[0] == srcb.Word[idx]);
                        end
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Dword[0] == srcb.Dword[idx]);
                        end
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Qword[0] == srcb.Qword[idx]);
                        end
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Dqword[0] == srcb.Dqword[idx]);
                        end
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end

        return result;


    endfunction: calc_seq

    virtual function riscv_v_data_t calc_sne(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start, riscv_v_mask_t mask, riscv_v_mask_t dst_mask_merge, bit use_mask);

        riscv_v_data_t result;
        result = 'x;
        result[RISCV_V_NUM_ELEMENTS_REG-1:0] = dst_mask_merge;

        if (~is_scalar) begin
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Byte[idx] != srcb.Byte[idx]);
                        end
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Word[idx] != srcb.Word[idx]);
                        end
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Dword[idx] != srcb.Dword[idx]);
                        end
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Qword[idx] != srcb.Qword[idx]);
                        end
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Dqword[idx] != srcb.Dqword[idx]);
                        end
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end else begin
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Byte[0] != srcb.Byte[idx]);
                        end
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Word[0] != srcb.Word[idx]);
                        end
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Dword[0] != srcb.Dword[idx]);
                        end
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Qword[0] != srcb.Qword[idx]);
                        end
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (srca.Dqword[0] != srcb.Dqword[idx]);
                        end
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end

        return result;

    endfunction: calc_sne

    virtual function riscv_v_data_t calc_sle(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start, riscv_v_mask_t mask, riscv_v_mask_t dst_mask_merge, bit use_mask);

        riscv_v_data_t result;
        result = 'x;
        result[RISCV_V_NUM_ELEMENTS_REG-1:0] = dst_mask_merge;

        if (~is_scalar) begin
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Byte[idx]) <= signed'(srca.Byte[idx]));
                        end
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Word[idx]) <= signed'(srca.Word[idx]));
                        end
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Dword[idx]) <= signed'(srca.Dword[idx]));
                        end
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Qword[idx]) <= signed'(srca.Qword[idx]));
                        end
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Dqword[idx]) <= signed'(srca.Dqword[idx]));
                        end
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end else begin
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Byte[idx]) <= signed'(srca.Byte[0]));
                        end
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Word[idx]) <= signed'(srca.Word[0]));
                        end
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Dword[idx]) <= signed'(srca.Dword[0]));
                        end
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Qword[idx]) <= signed'(srca.Qword[0]));
                        end
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Dqword[idx]) <= signed'(srca.Dqword[0]));
                        end
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end

        return result;


    endfunction: calc_sle

    virtual function riscv_v_data_t calc_sleu(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start, riscv_v_mask_t mask, riscv_v_mask_t dst_mask_merge, bit use_mask);

        riscv_v_data_t result;
        result = 'x;
        result[RISCV_V_NUM_ELEMENTS_REG-1:0] = dst_mask_merge;

        if (~is_scalar) begin
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Byte[idx]) <= unsigned'(srca.Byte[idx]));
                        end
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Word[idx]) <= unsigned'(srca.Word[idx]));
                        end
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Dword[idx]) <= unsigned'(srca.Dword[idx]));
                        end
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Qword[idx]) <= unsigned'(srca.Qword[idx]));
                        end
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Dqword[idx]) <= unsigned'(srca.Dqword[idx]));
                        end
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end else begin
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Byte[idx]) <= unsigned'(srca.Byte[0]));
                        end
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Word[idx]) <= unsigned'(srca.Word[0]));
                        end
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Dword[idx]) <= unsigned'(srca.Dword[0]));
                        end
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Qword[idx]) <= unsigned'(srca.Qword[0]));
                        end
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Dqword[idx]) <= unsigned'(srca.Dqword[0]));
                        end
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end

        return result;


    endfunction: calc_sleu

    virtual function riscv_v_data_t calc_slt(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start, riscv_v_mask_t mask, riscv_v_mask_t dst_mask_merge, bit use_mask);

        riscv_v_data_t result;
        result = 'x;
        result[RISCV_V_NUM_ELEMENTS_REG-1:0] = dst_mask_merge;

        if (~is_scalar) begin
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Byte[idx]) < signed'(srca.Byte[idx]));
                        end
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Word[idx]) < signed'(srca.Word[idx]));
                        end
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Dword[idx]) < signed'(srca.Dword[idx]));
                        end
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Qword[idx]) < signed'(srca.Qword[idx]));
                        end
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Dqword[idx]) < signed'(srca.Dqword[idx]));
                        end
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end else begin
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Byte[idx]) < signed'(srca.Byte[0]));
                        end
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Word[idx]) < signed'(srca.Word[0]));
                        end
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Dword[idx]) < signed'(srca.Dword[0]));
                        end
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Qword[idx]) < signed'(srca.Qword[0]));
                        end
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Dqword[idx]) < signed'(srca.Dqword[0]));
                        end
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end

        return result;


    endfunction: calc_slt

    virtual function riscv_v_data_t calc_sltu(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start, riscv_v_mask_t mask, riscv_v_mask_t dst_mask_merge, bit use_mask);

        riscv_v_data_t result;
        result = 'x;
        result[RISCV_V_NUM_ELEMENTS_REG-1:0] = dst_mask_merge;

        if (~is_scalar) begin
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Byte[idx]) < unsigned'(srca.Byte[idx]));
                        end
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Word[idx]) < unsigned'(srca.Word[idx]));
                        end
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Dword[idx]) < unsigned'(srca.Dword[idx]));
                        end
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Qword[idx]) < unsigned'(srca.Qword[idx]));
                        end
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Dqword[idx]) < unsigned'(srca.Dqword[idx]));
                        end
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end else begin
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Byte[idx]) < unsigned'(srca.Byte[0]));
                        end
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Word[idx]) < unsigned'(srca.Word[0]));
                        end
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Dword[idx]) < unsigned'(srca.Dword[0]));
                        end
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Qword[idx]) < unsigned'(srca.Qword[0]));
                        end
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Dqword[idx]) < unsigned'(srca.Dqword[0]));
                        end
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end

        return result;


    endfunction: calc_sltu

    virtual function riscv_v_data_t calc_sgt(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start, riscv_v_mask_t mask, riscv_v_mask_t dst_mask_merge, bit use_mask);

        riscv_v_data_t result;
        result = 'x;
        result[RISCV_V_NUM_ELEMENTS_REG-1:0] = dst_mask_merge;

        if (~is_scalar) begin
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Byte[idx]) > signed'(srca.Byte[idx]));
                        end
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Word[idx]) > signed'(srca.Word[idx]));
                        end
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Dword[idx]) > signed'(srca.Dword[idx]));
                        end
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Qword[idx]) > signed'(srca.Qword[idx]));
                        end
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Dqword[idx]) > signed'(srca.Dqword[idx]));
                        end
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end else begin
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Byte[idx]) > signed'(srca.Byte[0]));
                        end
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Word[idx]) > signed'(srca.Word[0]));
                        end
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Dword[idx]) > signed'(srca.Dword[0]));
                        end
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Qword[idx]) > signed'(srca.Qword[0]));
                        end
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (signed'(srcb.Dqword[idx]) > signed'(srca.Dqword[0]));
                        end
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end

        return result;


    endfunction: calc_sgt

    virtual function riscv_v_data_t calc_sgtu(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start, riscv_v_mask_t mask, riscv_v_mask_t dst_mask_merge, bit use_mask);

        riscv_v_data_t result;
        result = 'x;
        result[RISCV_V_NUM_ELEMENTS_REG-1:0] = dst_mask_merge;

        if (~is_scalar) begin
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Byte[idx]) > unsigned'(srca.Byte[idx]));
                        end
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Word[idx]) > unsigned'(srca.Word[idx]));
                        end
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Dword[idx]) > unsigned'(srca.Dword[idx]));
                        end
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Qword[idx]) > unsigned'(srca.Qword[idx]));
                        end
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Dqword[idx]) > unsigned'(srca.Dqword[idx]));
                        end
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end else begin
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Byte[idx]) > unsigned'(srca.Byte[0]));
                        end
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Word[idx]) > unsigned'(srca.Word[0]));
                        end
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Dword[idx]) > unsigned'(srca.Dword[0]));
                        end
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Qword[idx]) > unsigned'(srca.Qword[0]));
                        end
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        if (~use_mask | mask[idx]) begin
                            result[idx] = (unsigned'(srcb.Dqword[idx]) > unsigned'(srca.Dqword[0]));
                        end
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
        end

        return result;


    endfunction: calc_sgtu


    virtual function riscv_v_data_t calc_mins(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start);
        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin

            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = get_min_byte(srca.Byte[idx], srcb.Byte[idx], 1'b1);
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = get_min_word(srca.Word[idx], srcb.Word[idx], 1'b1);
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = get_min_dword(srca.Dword[idx], srcb.Dword[idx], 1'b1);
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = get_min_qword(srca.Qword[idx], srcb.Qword[idx], 1'b1);
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = get_min_dqword(srca.Dqword[idx], srcb.Dqword[idx], 1'b1);
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
            
        end else begin
            
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = get_min_byte(srca.Byte[0], srcb.Byte[idx], 1'b1);
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = get_min_word(srca.Word[0], srcb.Word[idx], 1'b1);
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = get_min_dword(srca.Dword[0], srcb.Dword[idx], 1'b1);
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = get_min_qword(srca.Qword[0], srcb.Qword[idx], 1'b1);
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = get_min_dqword(srca.Dqword[0], srcb.Dqword[idx], 1'b1);
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase

        end

        return result;
    endfunction: calc_mins 

    virtual function riscv_v_data_t calc_minu(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start);
        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin

            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = get_min_byte(srca.Byte[idx], srcb.Byte[idx], 1'b0);
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = get_min_word(srca.Word[idx], srcb.Word[idx], 1'b0);
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = get_min_dword(srca.Dword[idx], srcb.Dword[idx], 1'b0);
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = get_min_qword(srca.Qword[idx], srcb.Qword[idx], 1'b0);
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = get_min_dqword(srca.Dqword[idx], srcb.Dqword[idx], 1'b0);
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
            
        end else begin
            
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = get_min_byte(srca.Byte[0], srcb.Byte[idx], 1'b0);
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = get_min_word(srca.Word[0], srcb.Word[idx], 1'b0);
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = get_min_dword(srca.Dword[0], srcb.Dword[idx], 1'b0);
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = get_min_qword(srca.Qword[0], srcb.Qword[idx], 1'b0);
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = get_min_dqword(srca.Dqword[0], srcb.Dqword[idx], 1'b0);
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase

        end

        return result;
    endfunction: calc_minu

    virtual function riscv_v_data_t calc_maxs(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start);
        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin

            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = get_max_byte(srca.Byte[idx], srcb.Byte[idx], 1'b1);
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = get_max_word(srca.Word[idx], srcb.Word[idx], 1'b1);
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = get_max_dword(srca.Dword[idx], srcb.Dword[idx], 1'b1);
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = get_max_qword(srca.Qword[idx], srcb.Qword[idx], 1'b1);
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = get_max_dqword(srca.Dqword[idx], srcb.Dqword[idx], 1'b1);
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
            
        end else begin
            
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = get_max_byte(srca.Byte[0], srcb.Byte[idx], 1'b1);
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = get_max_word(srca.Word[0], srcb.Word[idx], 1'b1);
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = get_max_dword(srca.Dword[0], srcb.Dword[idx], 1'b1);
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = get_max_qword(srca.Qword[0], srcb.Qword[idx], 1'b1);
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = get_max_dqword(srca.Dqword[0], srcb.Dqword[idx], 1'b1);
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase

        end

        return result;
    endfunction: calc_maxs

    virtual function riscv_v_data_t calc_maxu(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start);
        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin

            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = get_max_byte(srca.Byte[idx], srcb.Byte[idx], 1'b0);
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = get_max_word(srca.Word[idx], srcb.Word[idx], 1'b0);
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = get_max_dword(srca.Dword[idx], srcb.Dword[idx], 1'b0);
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = get_max_qword(srca.Qword[idx], srcb.Qword[idx], 1'b0);
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = get_max_dqword(srca.Dqword[idx], srcb.Dqword[idx], 1'b0);
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase
            
        end else begin
            
            unique case (osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = get_max_byte(srca.Byte[0], srcb.Byte[idx], 1'b0);
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = get_max_word(srca.Word[0], srcb.Word[idx], 1'b0);
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = get_max_dword(srca.Dword[0], srcb.Dword[idx], 1'b0);
                    end
                end

                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = get_max_qword(srca.Qword[0], srcb.Qword[idx], 1'b0);
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = get_max_dqword(srca.Dqword[0], srcb.Dqword[idx], 1'b0);
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
            endcase

        end

        return result;
    endfunction: calc_maxu

    virtual function riscv_v_data_t calc_mins_reduct(riscv_v_data_t srca, riscv_v_data_t srcb, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start, riscv_v_mask_t mask, bit use_mask);
        riscv_v_data_t result;
        result = 'x;

        if(start != 0) begin
            `uvm_fatal(get_name(), "Start different from 0 not supported for this op, VREDMIN")
        end

        if (len == 0) begin
            return result;
        end

        unique case(osize)
            OSIZE_8 : begin
                if (~use_mask | mask[0]) begin
                    result.Byte[0] = get_min_byte(srca.Byte[0], srcb.Byte[0], 1'b1);
                end else begin
                    result.Byte[0] = srca.Byte[0];
                end
                for (int idx = 1; idx <len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Byte[0] = get_min_byte(result.Byte[0], srcb.Byte[idx], 1'b1);
                    end
                end
            end
            OSIZE_16 : begin
                if (~use_mask | mask[0]) begin
                    result.Word[0] = get_min_word(srca.Word[0], srcb.Word[0], 1'b1);
                end else begin
                    result.Word[0] = srca.Word[0];
                end
                for (int idx = 1; idx <len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Word[0] = get_min_word(result.Word[0], srcb.Word[idx], 1'b1);
                    end
                end
            end
            OSIZE_32 : begin
                if (~use_mask | mask[0]) begin
                    result.Dword[0] = get_min_dword(srca.Dword[0], srcb.Dword[0], 1'b1);
                end else begin
                    result.Dword[0] = srca.Dword[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Dword[0] = get_min_dword(result.Dword[0], srcb.Dword[idx], 1'b1);
                    end
                end
            end
            OSIZE_64 : begin
                if (~use_mask | mask[0]) begin
                    result.Qword[0] = get_min_qword(srca.Qword[0], srcb.Qword[0], 1'b1);
                end else begin
                    result.Qword[0] = srca.Qword[0];
                end
                $display("First result: srca: 0x%0h, %0d, srcb: 0x%0h, %0d, result: 0x%0h", srca.Qword[0], srca.Qword[0], srcb.Qword[0], srcb.Qword[0], result.Qword[0]);
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Qword[0] = get_min_qword(result.Qword[0], srcb.Qword[idx], 1'b1);
                        $display("result[%0d]: srca: 0x%0h, %0d, srcb: 0x%0h, %0d, result: 0x%0h", idx, srca.Qword[idx], srca.Qword[idx], srcb.Qword[idx], srcb.Qword[idx], result.Qword[idx]);

                    end
                end
            end
            default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
        endcase 

        return result;
    endfunction: calc_mins_reduct

    virtual function riscv_v_data_t calc_minu_reduct(riscv_v_data_t srca, riscv_v_data_t srcb, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start, riscv_v_mask_t mask, bit use_mask);
        riscv_v_data_t result;
        result = 'x;

        if(start != 0) begin
            `uvm_fatal(get_name(), "Start different from 0 not supported for this op, VREDMINU")
        end

        if (len == 0) begin
            return result;
        end

        unique case(osize)
            OSIZE_8 : begin
                if (~use_mask | mask[0]) begin
                    result.Byte[0] = get_min_byte(srca.Byte[0], srcb.Byte[0], 1'b0);
                end else begin
                    result.Byte[0] = srca.Byte[0];
                end
                for (int idx = 1; idx <len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Byte[0] = get_min_byte(result.Byte[0], srcb.Byte[idx], 1'b0);
                    end
                end
            end
            OSIZE_16 : begin
                if (~use_mask | mask[0]) begin
                    result.Word[0] = get_min_word(srca.Word[0], srcb.Word[0], 1'b0);
                end else begin
                    result.Word[0] = srca.Word[0];
                end
                for (int idx = 1; idx <len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Word[0] = get_min_word(result.Word[0], srcb.Word[idx], 1'b0);
                    end
                end
            end
            OSIZE_32 : begin
                if (~use_mask | mask[0]) begin
                    result.Dword[0] = get_min_dword(srca.Dword[0], srcb.Dword[0], 1'b0);
                end else begin
                    result.Dword[0] = srca.Dword[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Dword[0] = get_min_dword(result.Dword[0], srcb.Dword[idx], 1'b0);
                    end
                end
            end
            OSIZE_64 : begin
                if (~use_mask | mask[0]) begin
                    result.Qword[0] = get_min_qword(srca.Qword[0], srcb.Qword[0], 1'b0);
                end else begin
                    result.Qword[0] = srca.Qword[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Qword[0] = get_min_qword(result.Qword[0], srcb.Qword[idx], 1'b0);
                    end
                end
            end
            default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
        endcase 

        return result;
    endfunction: calc_minu_reduct

    virtual function riscv_v_data_t calc_maxs_reduct(riscv_v_data_t srca, riscv_v_data_t srcb, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start, riscv_v_mask_t mask, bit use_mask);
        riscv_v_data_t result;
        result = 'x;

        if(start != 0) begin
            `uvm_fatal(get_name(), "Start different from 0 not supported for this op, VREDMAX")
        end

        if (len == 0) begin
            return result;
        end

        unique case(osize)
            OSIZE_8 : begin
                if (~use_mask | mask[0]) begin
                    result.Byte[0] = get_max_byte(srca.Byte[0], srcb.Byte[0], 1'b1);
                end else begin
                    result.Byte[0] = srca.Byte[0];
                end
                for (int idx = 1; idx <len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Byte[0] = get_max_byte(result.Byte[0], srcb.Byte[idx], 1'b1);
                    end
                end
            end
            OSIZE_16 : begin
                if (~use_mask | mask[0]) begin
                    result.Word[0] = get_max_word(srca.Word[0], srcb.Word[0], 1'b1);
                end else begin
                    result.Word[0] = srca.Word[0];
                end
                for (int idx = 1; idx <len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Word[0] = get_max_word(result.Word[0], srcb.Word[idx], 1'b1);
                    end
                end
            end
            OSIZE_32 : begin
                if (~use_mask | mask[0]) begin
                    result.Dword[0] = get_max_dword(srca.Dword[0], srcb.Dword[0], 1'b1);
                end else begin
                    result.Dword[0] = srca.Dword[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Dword[0] = get_max_dword(result.Dword[0], srcb.Dword[idx], 1'b1);
                    end
                end
            end
            OSIZE_64 : begin
                if (~use_mask | mask[0]) begin
                    result.Qword[0] = get_max_qword(srca.Qword[0], srcb.Qword[0], 1'b1);
                end else begin
                    result.Qword[0] = srca.Qword[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Qword[0] = get_max_qword(result.Qword[0], srcb.Qword[idx], 1'b1);
                    end
                end
            end
            default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
        endcase 

        return result;
    endfunction: calc_maxs_reduct


    virtual function riscv_v_data_t calc_maxu_reduct(riscv_v_data_t srca, riscv_v_data_t srcb, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start, riscv_v_mask_t mask, bit use_mask);
        riscv_v_data_t result;
        result = 'x;

        if(start != 0) begin
            `uvm_fatal(get_name(), "Start different from 0 not supported for this op, VREDMAXU")
        end

        if (len == 0) begin
            return result;
        end

        unique case(osize)
            OSIZE_8 : begin
                if (~use_mask | mask[0]) begin
                    result.Byte[0] = get_max_byte(srca.Byte[0], srcb.Byte[0], 1'b0);
                end else begin
                    result.Byte[0] = srca.Byte[0];
                end
                for (int idx = 1; idx <len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Byte[0] = get_max_byte(result.Byte[0], srcb.Byte[idx], 1'b0);
                    end
                end
            end
            OSIZE_16 : begin
                if (~use_mask | mask[0]) begin
                    result.Word[0] = get_max_word(srca.Word[0], srcb.Word[0], 1'b0);
                end else begin
                    result.Word[0] = srca.Word[0];
                end
                for (int idx = 1; idx <len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Word[0] = get_max_word(result.Word[0], srcb.Word[idx], 1'b0);
                    end
                end
            end
            OSIZE_32 : begin
                if (~use_mask | mask[0]) begin
                    result.Dword[0] = get_max_dword(srca.Dword[0], srcb.Dword[0], 1'b0);
                end else begin
                    result.Dword[0] = srca.Dword[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Dword[0] = get_max_dword(result.Dword[0], srcb.Dword[idx], 1'b0);
                    end
                end
            end
            OSIZE_64 : begin
                if (~use_mask | mask[0]) begin
                    result.Qword[0] = get_max_qword(srca.Qword[0], srcb.Qword[0], 1'b0);
                end else begin
                    result.Qword[0] = srca.Qword[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Qword[0] = get_max_qword(result.Qword[0], srcb.Qword[idx], 1'b0);
                    end
                end
            end
            default : `uvm_fatal(get_name(), $sformatf("invalid osize: %0s", osize.name()))
        endcase 

        return result;
    endfunction: calc_maxu_reduct


    virtual function Byte_t get_min_byte(Byte_t srca, Byte_t srcb, bit is_signed);
        if (is_signed) begin
            if (signed'(srca) < signed'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end else begin
            if (unsigned'(srca) < unsigned'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end
    endfunction: get_min_byte


    virtual function Byte_t get_max_byte(Byte_t srca, Byte_t srcb, bit is_signed);
        if (is_signed) begin
            if (signed'(srca) > signed'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end else begin
            if (unsigned'(srca) > unsigned'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end
    endfunction: get_max_byte

    virtual function Word_t get_min_word(Word_t srca, Word_t srcb, bit is_signed);
        if (is_signed) begin
            if (signed'(srca) < signed'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end else begin
            if (unsigned'(srca) < unsigned'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end
    endfunction: get_min_word


    virtual function Word_t get_max_word(Word_t srca, Word_t srcb, bit is_signed);
        if (is_signed) begin
            if (signed'(srca) > signed'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end else begin
            if (unsigned'(srca) > unsigned'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end
    endfunction: get_max_word

    virtual function Dword_t get_min_dword(Dword_t srca, Dword_t srcb, bit is_signed);
        if (is_signed) begin
            if (signed'(srca) < signed'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end else begin
            if (unsigned'(srca) < unsigned'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end
    endfunction: get_min_dword


    virtual function Dword_t get_max_dword(Dword_t srca, Dword_t srcb, bit is_signed);
        if (is_signed) begin
            if (signed'(srca) > signed'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end else begin
            if (unsigned'(srca) > unsigned'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end
    endfunction: get_max_dword

    virtual function Qword_t get_min_qword(Qword_t srca, Qword_t srcb, bit is_signed);
        if (is_signed) begin
            if (signed'(srca) < signed'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end else begin
            if (unsigned'(srca) < unsigned'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end
    endfunction: get_min_qword


    virtual function Qword_t get_max_qword(Qword_t srca, Qword_t srcb, bit is_signed);
        if (is_signed) begin
            if (signed'(srca) > signed'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end else begin
            if (unsigned'(srca) > unsigned'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end
    endfunction: get_max_qword

    virtual function Dqword_t get_min_dqword(Dqword_t srca, Dqword_t srcb, bit is_signed);
        if (is_signed) begin
            if (signed'(srca) < signed'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end else begin
            if (unsigned'(srca) < unsigned'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end
    endfunction: get_min_dqword


    virtual function Dqword_t get_max_dqword(Dqword_t srca, Dqword_t srcb, bit is_signed);
        if (is_signed) begin
            if (signed'(srca) > signed'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end else begin
            if (unsigned'(srca) > unsigned'(srcb)) begin
                return srca;
            end else begin
                return srcb;
            end
        end
    endfunction: get_max_dqword

endclass: riscv_v_arithmetic_alu_model

`endif //__RISCV_V_ARITHMETIC_ALU_MODEL__ 