//File: riscv_v_logic_alu_model
//Author: Miguel Bucio
//Date: 16/04/24
//Description: RiscV V Logic ALU Model

`ifndef __RISCV_V_LOGIC_ALU_MODEL__
`define __RISCV_V_LOGIC_ALU_MODEL__ 

class riscv_v_logic_alu_model extends riscv_v_alu_base_model;
    `uvm_component_utils(riscv_v_logic_alu_model)

    function new(string name = "riscv_v_logic_alu_model", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new 

    virtual function riscv_v_data_t execute_vec_op(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_opcode_e opcode, riscv_v_osize_e src_osize, riscv_v_osize_e dst_osize, riscv_v_vlen_t len, riscv_v_field_vstart_t start, riscv_v_mask_t mask, riscv_v_mask_t dst_mask_merge, bit use_mask);
        riscv_v_data_t result = 'x;
        riscv_v_src_len_t len_op;

        if (!(opcode inside {MAND, MNAND, MANDN, MOR, MNOR, MORN, MXOR, MXNOR})) begin
            len_op = get_len_op(len, dst_osize);
        end else begin
            if (len > RISCV_V_NUM_ELEMENTS_REG) begin
                len_op = RISCV_V_NUM_ELEMENTS_REG;
            end else begin
                len_op = len;
            end
        end
        
        unique case(opcode)
            BW_AND        : result = calc_bw_and        (srca, srcb, is_scalar, dst_osize, len_op, start);
            BW_OR         : result = calc_bw_or         (srca, srcb, is_scalar, dst_osize, len_op, start);
            BW_XOR        : result = calc_bw_xor        (srca, srcb, is_scalar, dst_osize, len_op, start);
            BW_AND_REDUCT : result = calc_bw_redand     (srca, srcb,            dst_osize, len_op, start, mask, use_mask);
            BW_OR_REDUCT  : result = calc_bw_redor      (srca, srcb,            dst_osize, len_op, start, mask, use_mask);
            BW_XOR_REDUCT : result = calc_bw_redxor     (srca, srcb,            dst_osize, len_op, start, mask, use_mask);
            MAND          : result = calc_mand          (srca, srcb, len_op,    start, dst_mask_merge);
            MNAND         : result = calc_mnand         (srca, srcb, len_op,    start, dst_mask_merge);
            MANDN         : result = calc_mandn         (srca, srcb, len_op,    start, dst_mask_merge);
            MXOR          : result = calc_mxor          (srca, srcb, len_op,    start, dst_mask_merge);
            MOR           : result = calc_mor           (srca, srcb, len_op,    start, dst_mask_merge);
            MNOR          : result = calc_mnor          (srca, srcb, len_op,    start, dst_mask_merge);
            MORN          : result = calc_morn          (srca, srcb, len_op,    start, dst_mask_merge);
            MXNOR         : result = calc_mxnor         (srca, srcb, len_op,    start, dst_mask_merge);
            SLL           : result = calc_sll           (srca, srcb, is_scalar, dst_osize, len_op, start);
            SRL           : result = calc_srl           (srca, srcb, is_scalar, dst_osize, len_op, start);
            SRA           : result = calc_sra           (srca, srcb, is_scalar, dst_osize, len_op, start);
            default : `uvm_fatal(get_name(), $sformatf("Invalid opcode: %s", opcode.name()))
        endcase

        return result;
    endfunction: execute_vec_op

    virtual function riscv_v_data_t calc_bw_and(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_field_vstart_t start);
        
        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin

            unique case(osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = srca.Byte[idx] & srcb.Byte[idx];
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = srca.Word[idx] & srcb.Word[idx];
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = srca.Dword[idx] & srcb.Dword[idx];
                    end
                end
                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = srca.Qword[idx] & srcb.Qword[idx];
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = srca.Dqword[idx] & srcb.Dqword[idx];
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))

            endcase

        end else begin

            unique case(osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = srca.Byte[0] & srcb.Byte[idx];
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = srca.Word[0] & srcb.Word[idx];
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = srca.Dword[0] & srcb.Dword[idx];
                    end
                end
                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = srca.Qword[0] & srcb.Qword[idx];
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = srca.Dqword[0] & srcb.Dqword[idx];
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))

            endcase

        end

        return result;

    endfunction: calc_bw_and

    virtual function riscv_v_data_t calc_bw_or(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_field_vstart_t start);
        
        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin

            unique case(osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = srca.Byte[idx] | srcb.Byte[idx];
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = srca.Word[idx] | srcb.Word[idx];
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = srca.Dword[idx] | srcb.Dword[idx];
                    end
                end
                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = srca.Qword[idx] | srcb.Qword[idx];
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = srca.Dqword[idx] | srcb.Dqword[idx];
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))

            endcase

        end else begin

            unique case(osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = srca.Byte[0] | srcb.Byte[idx];
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = srca.Word[0] | srcb.Word[idx];
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = srca.Dword[0] | srcb.Dword[idx];
                    end
                end
                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = srca.Qword[0] | srcb.Qword[idx];
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = srca.Dqword[0] | srcb.Dqword[idx];
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))

            endcase

        end

        return result;

    endfunction: calc_bw_or

    virtual function riscv_v_data_t calc_bw_xor(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_field_vstart_t start);
        
        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin

            unique case(osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = srca.Byte[idx] ^ srcb.Byte[idx];
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = srca.Word[idx] ^ srcb.Word[idx];
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = srca.Dword[idx] ^ srcb.Dword[idx];
                    end
                end
                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = srca.Qword[idx] ^ srcb.Qword[idx];
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = srca.Dqword[idx] ^ srcb.Dqword[idx];
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))

            endcase

        end else begin

            unique case(osize)
                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = srca.Byte[0] ^ srcb.Byte[idx];
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = srca.Word[0] ^ srcb.Word[idx];
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = srca.Dword[0] ^ srcb.Dword[idx];
                    end
                end
                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = srca.Qword[0] ^ srcb.Qword[idx];
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = srca.Dqword[0] ^ srcb.Dqword[idx];
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))

            endcase

        end

        return result;

    endfunction: calc_bw_xor

    virtual function riscv_v_data_t calc_bw_redand(riscv_v_data_t srca, riscv_v_data_t srcb, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_field_vstart_t start, riscv_v_mask_t mask, bit use_mask);
        
        riscv_v_data_t result;
        result = 'x;

        if(start != 0) begin
            `uvm_fatal(get_name(), "Start different from 0 not supported for this op, VREDAND")
        end

        if (len == 0) begin
            return result;
        end


        unique case(osize)

            OSIZE_8 : begin
                if (~use_mask | mask[0]) begin
                    result.Byte[0] = srca.Byte[0] & srcb.Byte[0];
                end else begin
                    result.Byte[0] = srca.Byte[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Byte[0] = result.Byte[0] & srcb.Byte[idx];
                    end
                end
            end
            OSIZE_16 : begin
                if (~use_mask | mask[0]) begin
                    result.Word[0] = srca.Word[0] & srcb.Word[0];
                end else begin
                    result.Word[0] = srca.Word[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Word[0] = result.Word[0] & srcb.Word[idx];
                    end
                end
            end
            OSIZE_32 : begin
                if (~use_mask | mask[0]) begin
                    result.Dword[0] = srca.Dword[0] & srcb.Dword[0];
                end else begin
                    result.Dword[0] = srca.Dword[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Dword[0] = result.Dword[0] & srcb.Dword[idx];
                    end
                end
            end
            OSIZE_64 : begin
                if (~use_mask | mask[0]) begin
                    result.Qword[0] = srca.Qword[0] & srcb.Qword[0];
                end else begin
                    result.Qword[0] = srca.Qword[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Qword[0] = result.Qword[0] & srcb.Qword[idx];
                    end
                end
            end
            default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))

        endcase

        return result;

    endfunction: calc_bw_redand

    virtual function riscv_v_data_t calc_bw_redor(riscv_v_data_t srca, riscv_v_data_t srcb, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_field_vstart_t start, riscv_v_mask_t mask, bit use_mask);
        
        riscv_v_data_t result;
        result = 'x;

        if(start != 0) begin
            `uvm_fatal(get_name(), "Start different from 0 not supported for this op, VREDOR")
        end

        if (len == 0) begin
            return result;
        end


        unique case(osize)

            OSIZE_8 : begin
                if (~use_mask | mask[0]) begin
                    result.Byte[0] = srca.Byte[0] | srcb.Byte[0];
                end else begin
                    result.Byte[0] = srca.Byte[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Byte[0] = result.Byte[0] | srcb.Byte[idx];
                    end
                end
            end
            OSIZE_16 : begin
                if (~use_mask | mask[0]) begin
                    result.Word[0] = srca.Word[0] | srcb.Word[0];
                end else begin
                    result.Word[0] = srca.Word[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Word[0] = result.Word[0] | srcb.Word[idx];
                    end
                end
            end
            OSIZE_32 : begin
                if (~use_mask | mask[0]) begin
                    result.Dword[0] = srca.Dword[0] | srcb.Dword[0];
                end else begin
                    result.Dword[0] = srca.Dword[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Dword[0] = result.Dword[0] | srcb.Dword[idx];
                    end
                end
            end
            OSIZE_64 : begin
                if (~use_mask | mask[0]) begin
                    result.Qword[0] = srca.Qword[0] | srcb.Qword[0];
                end else begin
                    result.Qword[0] = srca.Qword[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Qword[0] = result.Qword[0] | srcb.Qword[idx];
                    end 
                end
            end
            default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))

        endcase

        return result;

    endfunction: calc_bw_redor

    virtual function riscv_v_data_t calc_bw_redxor(riscv_v_data_t srca, riscv_v_data_t srcb, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_field_vstart_t start, riscv_v_mask_t mask, bit use_mask);
        
        riscv_v_data_t result;
        result = 'x;

        if(start != 0) begin
            `uvm_fatal(get_name(), "Start different from 0 not supported for this op, VREDXOR")
        end

        if (len == 0) begin
            return result;
        end


        unique case(osize)

            OSIZE_8 : begin
                if (~use_mask | mask[0]) begin
                    result.Byte[0] = srca.Byte[0] ^ srcb.Byte[0];
                end else begin
                    result.Byte[0] = srca.Byte[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Byte[0] = result.Byte[0] ^ srcb.Byte[idx];
                    end
                end
            end
            OSIZE_16 : begin
                if (~use_mask | mask[0]) begin
                    result.Word[0] = srca.Word[0] ^ srcb.Word[0];
                end else begin
                    result.Word[0] = srca.Word[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Word[0] = result.Word[0] ^ srcb.Word[idx];
                    end
                end
            end
            OSIZE_32 : begin
                if (~use_mask | mask[0]) begin
                    result.Dword[0] = srca.Dword[0] ^ srcb.Dword[0];
                end else begin
                    result.Dword[0] = srca.Dword[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Dword[0] = result.Dword[0] ^ srcb.Dword[idx];
                    end
                end
            end
            OSIZE_64 : begin
                if (~use_mask | mask[0]) begin
                    result.Qword[0] = srca.Qword[0] ^ srcb.Qword[0];
                end else begin
                    result.Qword[0] = srca.Qword[0];
                end
                for (int idx = 1; idx < len; idx++) begin
                    if (~use_mask | mask[idx]) begin
                        result.Qword[0] = result.Qword[0] ^ srcb.Qword[idx];
                    end
                end
            end
            default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))

        endcase

        return result;

    endfunction: calc_bw_redxor

    virtual function riscv_v_data_t calc_mand(riscv_v_data_t srca, riscv_v_data_t srcb, riscv_v_src_len_t len, riscv_v_field_vstart_t start, riscv_v_mask_t dst_mask_merge);
        riscv_v_data_t result;

        result = 'x;
        result[RISCV_V_NUM_ELEMENTS_REG-1:0] = dst_mask_merge;

        for (int idx = start; idx < len; idx++) begin
            result[idx] = (srca[idx] && srcb[idx]);
        end

        return result;

    endfunction: calc_mand

    virtual function riscv_v_data_t calc_mnand(riscv_v_data_t srca, riscv_v_data_t srcb, riscv_v_src_len_t len, riscv_v_field_vstart_t start, riscv_v_mask_t dst_mask_merge);
        riscv_v_data_t result;

        result = 'x;
        result[RISCV_V_NUM_ELEMENTS_REG-1:0] = dst_mask_merge;

        for (int idx = start; idx < len; idx++) begin
            result[idx] = !(srca[idx] && srcb[idx]);
        end

        return result;

    endfunction: calc_mnand

    virtual function riscv_v_data_t calc_mandn(riscv_v_data_t srca, riscv_v_data_t srcb, riscv_v_src_len_t len, riscv_v_field_vstart_t start, riscv_v_mask_t dst_mask_merge);
        riscv_v_data_t result;

        result = 'x;
        result[RISCV_V_NUM_ELEMENTS_REG-1:0] = dst_mask_merge;

        for (int idx = start; idx < len; idx++) begin
            result[idx] = (!srca[idx] && srcb[idx]);
        end

        return result;

    endfunction: calc_mandn

    virtual function riscv_v_data_t calc_mxor(riscv_v_data_t srca, riscv_v_data_t srcb, riscv_v_src_len_t len, riscv_v_field_vstart_t start, riscv_v_mask_t dst_mask_merge);
        riscv_v_data_t result;

        result = 'x;
        result[RISCV_V_NUM_ELEMENTS_REG-1:0] = dst_mask_merge;


        for (int idx = start; idx < len; idx++) begin
            result[idx] = (srca[idx] ^^ srcb[idx]);
        end

        return result;

    endfunction: calc_mxor

    virtual function riscv_v_data_t calc_mor(riscv_v_data_t srca, riscv_v_data_t srcb, riscv_v_src_len_t len, riscv_v_field_vstart_t start, riscv_v_mask_t dst_mask_merge);
        riscv_v_data_t result;

        result = 'x;
        result[RISCV_V_NUM_ELEMENTS_REG-1:0] = dst_mask_merge;

        for (int idx = start; idx < len; idx++) begin
            result[idx] = (srca[idx] || srcb[idx]);
        end

        return result;

    endfunction: calc_mor

    virtual function riscv_v_data_t calc_mnor(riscv_v_data_t srca, riscv_v_data_t srcb, riscv_v_src_len_t len, riscv_v_field_vstart_t start, riscv_v_mask_t dst_mask_merge);
        riscv_v_data_t result;

        result = 'x;
        result[RISCV_V_NUM_ELEMENTS_REG-1:0] = dst_mask_merge;

        for (int idx = start; idx < len; idx++) begin
            result[idx] = !(srca[idx] || srcb[idx]);
        end

        return result;

    endfunction: calc_mnor

    virtual function riscv_v_data_t calc_morn(riscv_v_data_t srca, riscv_v_data_t srcb, riscv_v_src_len_t len, riscv_v_field_vstart_t start, riscv_v_mask_t dst_mask_merge);
        riscv_v_data_t result;

        result = 'x;
        result[RISCV_V_NUM_ELEMENTS_REG-1:0] = dst_mask_merge;

        for (int idx = start; idx < len; idx++) begin
            result[idx] = (!srca[idx] || srcb[idx]);
        end

        return result;

    endfunction: calc_morn

    virtual function riscv_v_data_t calc_mxnor(riscv_v_data_t srca, riscv_v_data_t srcb, riscv_v_src_len_t len, riscv_v_field_vstart_t start, riscv_v_mask_t dst_mask_merge);
        riscv_v_data_t result;

        result = 'x;
        result[RISCV_V_NUM_ELEMENTS_REG-1:0] = dst_mask_merge;

        for (int idx = start; idx < len; idx++) begin
            result[idx] = !(srca[idx] ^^ srcb[idx]);
        end

        return result;

    endfunction: calc_mxnor

    virtual function riscv_v_data_t calc_sll(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_field_vstart_t start);
        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin

            unique case(osize)
                OSIZE_8 : begin
                    logic [$clog2(8)-1:0] shift_amnt;
                    for (int idx = start; idx < len; idx++) begin
                        shift_amnt = srca.Byte[idx][$clog2(8)-1:0];
                        result.Byte[idx] = srcb.Byte[idx] << shift_amnt;
                    end
                end
                OSIZE_16 : begin
                    logic [$clog2(16)-1:0] shift_amnt;
                    for (int idx = start; idx < len; idx++) begin
                        shift_amnt = srca.Word[idx][$clog2(16)-1:0];
                        result.Word[idx] = srcb.Word[idx] << shift_amnt;
                    end
                end
                OSIZE_32 : begin
                    logic [$clog2(32)-1:0] shift_amnt;
                    for (int idx = start; idx < len; idx++) begin
                        shift_amnt = srca.Dword[idx][$clog2(32)-1:0];
                        result.Dword[idx] = srcb.Dword[idx] << shift_amnt;
                    end
                end
                OSIZE_64 : begin
                    logic [$clog2(64)-1:0] shift_amnt;
                    for (int idx = start; idx < len; idx++) begin
                        shift_amnt = srca.Qword[idx][$clog2(64)-1:0];
                        result.Qword[idx] = srcb.Qword[idx] << shift_amnt;
                    end
                end
                OSIZE_128 : begin
                    logic [$clog2(128)-1:0] shift_amnt;
                    for (int idx = start; idx < len; idx++) begin
                        shift_amnt = srca.Dqword[idx][$clog2(128)-1:0];
                        result.Dqword[idx] = srcb.Dqword[idx] << shift_amnt;
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))
            endcase

        end else begin
            
            unique case(osize)
                OSIZE_8 : begin
                    logic [$clog2(8)-1:0] shift_amnt;
                    shift_amnt = srca.Byte[0][$clog2(8)-1:0];
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = srcb.Byte[idx] << shift_amnt;
                    end
                end
                OSIZE_16 : begin
                    logic [$clog2(16)-1:0] shift_amnt;
                    shift_amnt = srca.Word[0][$clog2(16)-1:0];
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = srcb.Word[idx] << shift_amnt;
                    end
                end
                OSIZE_32 : begin
                    logic [$clog2(32)-1:0] shift_amnt;
                    shift_amnt = srca.Dword[0][$clog2(32)-1:0];
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = srcb.Dword[idx] << shift_amnt;
                    end
                end
                OSIZE_64 : begin
                    logic [$clog2(64)-1:0] shift_amnt;
                    shift_amnt = srca.Qword[0][$clog2(64)-1:0];
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = srcb.Qword[idx] << shift_amnt;
                    end
                end
                OSIZE_128 : begin
                    logic [$clog2(128)-1:0] shift_amnt;
                    shift_amnt = srca.Dqword[0][$clog2(128)-1:0];
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = srcb.Dqword[idx] << shift_amnt;
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))
            endcase

        end

        return result;
    endfunction: calc_sll

    virtual function riscv_v_data_t calc_srl(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_field_vstart_t start);
        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin

            unique case(osize)
                OSIZE_8 : begin
                    logic [$clog2(8)-1:0] shift_amnt;
                    for (int idx = start; idx < len; idx++) begin
                        shift_amnt = srca.Byte[idx][$clog2(8)-1:0];
                        result.Byte[idx] = srcb.Byte[idx] >> shift_amnt;
                    end
                end
                OSIZE_16 : begin
                    logic [$clog2(16)-1:0] shift_amnt;
                    for (int idx = start; idx < len; idx++) begin
                        shift_amnt = srca.Word[idx][$clog2(16)-1:0];
                        result.Word[idx] = srcb.Word[idx] >> shift_amnt;
                    end
                end
                OSIZE_32 : begin
                    logic [$clog2(32)-1:0] shift_amnt;
                    for (int idx = start; idx < len; idx++) begin
                        shift_amnt = srca.Dword[idx][$clog2(32)-1:0];
                        result.Dword[idx] = srcb.Dword[idx] >> shift_amnt;
                    end
                end
                OSIZE_64 : begin
                    logic [$clog2(64)-1:0] shift_amnt;
                    for (int idx = start; idx < len; idx++) begin
                        shift_amnt = srca.Qword[idx][$clog2(64)-1:0];
                        result.Qword[idx] = srcb.Qword[idx] >> shift_amnt;
                    end
                end
                OSIZE_128 : begin
                    logic [$clog2(128)-1:0] shift_amnt;
                    for (int idx = start; idx < len; idx++) begin
                        shift_amnt = srca.Dqword[idx][$clog2(128)-1:0];
                        result.Dqword[idx] = srcb.Dqword[idx] >> shift_amnt;
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))
            endcase

        end else begin
            
            unique case(osize)
                OSIZE_8 : begin
                    logic [$clog2(8)-1:0] shift_amnt;
                    shift_amnt = srca.Byte[0][$clog2(8)-1:0];
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = srcb.Byte[idx] >> shift_amnt;
                    end
                end
                OSIZE_16 : begin
                    logic [$clog2(16)-1:0] shift_amnt;
                    shift_amnt = srca.Word[0][$clog2(16)-1:0];
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = srcb.Word[idx] >> shift_amnt;
                    end
                end
                OSIZE_32 : begin
                    logic [$clog2(32)-1:0] shift_amnt;
                    shift_amnt = srca.Dword[0][$clog2(32)-1:0];
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = srcb.Dword[idx] >> shift_amnt;
                    end
                end
                OSIZE_64 : begin
                    logic [$clog2(64)-1:0] shift_amnt;
                    shift_amnt = srca.Qword[0][$clog2(64)-1:0];
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = srcb.Qword[idx] >> shift_amnt;
                    end
                end
                OSIZE_128 : begin
                    logic [$clog2(128)-1:0] shift_amnt;
                    shift_amnt = srca.Dqword[0][$clog2(128)-1:0];
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = srcb.Dqword[idx] >> shift_amnt;
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))
            endcase

        end

        return result;
    endfunction: calc_srl

    virtual function riscv_v_data_t calc_sra(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_field_vstart_t start);
        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin

            unique case(osize)
                OSIZE_8 : begin
                    logic [$clog2(8)-1:0] shift_amnt;
                    for (int idx = start; idx < len; idx++) begin
                        shift_amnt = srca.Byte[idx][$clog2(8)-1:0];
                        result.Byte[idx] = signed'(srcb.Byte[idx]) >>> shift_amnt;
                    end
                end
                OSIZE_16 : begin
                    logic [$clog2(16)-1:0] shift_amnt;
                    for (int idx = start; idx < len; idx++) begin
                        shift_amnt = srca.Word[idx][$clog2(16)-1:0];
                        result.Word[idx] = signed'(srcb.Word[idx]) >>> shift_amnt;
                    end
                end
                OSIZE_32 : begin
                    logic [$clog2(32)-1:0] shift_amnt;
                    for (int idx = start; idx < len; idx++) begin
                        shift_amnt = srca.Dword[idx][$clog2(32)-1:0];
                        result.Dword[idx] = signed'(srcb.Dword[idx]) >>> shift_amnt;
                    end
                end
                OSIZE_64 : begin
                    logic [$clog2(64)-1:0] shift_amnt;
                    for (int idx = start; idx < len; idx++) begin
                        shift_amnt = srca.Qword[idx][$clog2(64)-1:0];
                        result.Qword[idx] = signed'(srcb.Qword[idx]) >>> shift_amnt;
                    end
                end
                OSIZE_128 : begin
                    logic [$clog2(128)-1:0] shift_amnt;
                    for (int idx = start; idx < len; idx++) begin
                        shift_amnt = srca.Dqword[idx][$clog2(128)-1:0];
                        result.Dqword[idx] = signed'(srcb.Dqword[idx]) >>> shift_amnt;
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))
            endcase

        end else begin
            
            unique case(osize)
                OSIZE_8 : begin
                    logic [$clog2(8)-1:0] shift_amnt;
                    shift_amnt = srca.Byte[0][$clog2(8)-1:0];
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = signed'(srcb.Byte[idx]) >>> shift_amnt;
                    end
                end
                OSIZE_16 : begin
                    logic [$clog2(16)-1:0] shift_amnt;
                    shift_amnt = srca.Word[0][$clog2(16)-1:0];
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = signed'(srcb.Word[idx]) >>> shift_amnt;
                    end
                end
                OSIZE_32 : begin
                    logic [$clog2(32)-1:0] shift_amnt;
                    shift_amnt = srca.Dword[0][$clog2(32)-1:0];
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = signed'(srcb.Dword[idx]) >>> shift_amnt;
                    end
                end
                OSIZE_64 : begin
                    logic [$clog2(64)-1:0] shift_amnt;
                    shift_amnt = srca.Qword[0][$clog2(64)-1:0];
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = signed'(srcb.Qword[idx]) >>> shift_amnt;
                    end
                end
                OSIZE_128 : begin
                    logic [$clog2(128)-1:0] shift_amnt;
                    shift_amnt = srca.Dqword[0][$clog2(128)-1:0];
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = signed'(srcb.Dqword[idx]) >>> shift_amnt;
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))
            endcase

        end

        return result;
    endfunction: calc_sra

endclass: riscv_v_logic_alu_model

`endif //__RISCV_V_LOGIC_ALU_MODEL__ 