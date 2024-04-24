//File: riscv_v_permutation_alu_model
//Author: Miguel Bucio
//Date: 16/04/24
//Description: RiscV V permutation ALU Model

`ifndef __RISCV_V_PERMUTATION_ALU_MODEL__
`define __RISCV_V_PERMUTATION_ALU_MODEL__ 

class riscv_v_permutation_alu_model extends riscv_v_alu_base_model;
    `uvm_component_utils(riscv_v_permutation_alu_model)

    function new(string name = "riscv_v_permutation_alu_model", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new 

    virtual function riscv_v_data_t execute_vec_op(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_opcode_e opcode, riscv_v_osize_e src_osize, riscv_v_osize_e dst_osize, riscv_v_vlen_t len, riscv_v_src_start_t start, riscv_v_mask_t mask, riscv_v_mask_t dst_mask_merge, bit use_mask);
        riscv_v_data_t result = 'x;
        riscv_v_src_len_t len_op;
        
        len_op = get_len_op(len, dst_osize);
        
        unique case(opcode)
            I2V :       result = calc_i2v(srca, dst_osize, len, start); 
            default : `uvm_fatal(get_name(), $sformatf("Invalid opcode: %s", opcode.name()))
        endcase

        return result;
    endfunction: execute_vec_op

    virtual function riscv_data_t execute_v2i_op(riscv_v_data_t srcb, riscv_v_opcode_e opcode, riscv_v_osize_e src_osize);
        riscv_data_t result = 'x;
        
        unique case(opcode)
            V2I     : result = calc_v2i(srcb, src_osize);
            default : `uvm_fatal(get_name(), $sformatf("Invalid opcode: %s", opcode.name()))
        endcase

        return result;
    endfunction: execute_v2i_op

    virtual function riscv_v_data_t calc_i2v(riscv_v_data_t src, riscv_v_osize_e osize, riscv_v_vlen_t len, riscv_v_src_start_t start);
        riscv_v_data_t result;
        riscv_data_t   tmp_src;
        riscv_v_data_t tmp_result;
        
        result = 'x;

        tmp_src = src[RISCV_DATA_WIDTH-1:0];

        unique case(osize)
            OSIZE_8   : begin 
                tmp_result = tmp_src[BYTE_WIDTH-1:0];
                for (int idx = start; idx < len; idx++) begin
                    result.Byte[idx] = tmp_result.Byte[idx];
                end
            end
            OSIZE_16  : begin 
                tmp_result = tmp_src[WORD_WIDTH-1:0];
                for (int idx = start; idx < len; idx++) begin
                    result.Word[idx] = tmp_result.Word[idx];
                end
            end
            OSIZE_32  : begin
                tmp_result = tmp_src[DWORD_WIDTH-1:0];
                for (int idx = start; idx < len; idx++) begin
                    result.Dword[idx] = tmp_result.Dword[idx];
                end
            end
            OSIZE_64  : begin
                tmp_result = `RISCV_V_SX(tmp_src, QWORD_WIDTH);
                for (int idx = start; idx < len; idx++) begin
                    result.Qword[idx] = tmp_result.Qword[idx];
                end
            end
            OSIZE_128 : begin
                tmp_result = `RISCV_V_SX(tmp_src, DQWORD_WIDTH);
                for (int idx = start; idx < len; idx++) begin
                    result.Dqword[idx] = tmp_result.Dqword[idx];
                end
            end
            default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))
        endcase

        return result;
    endfunction: calc_i2v

    virtual function riscv_data_t calc_v2i(riscv_v_data_t src, riscv_v_osize_e osize);
        riscv_data_t result;
        result = 'x;

        unique case(osize)
            OSIZE_8   : result = `RISCV_V_SX(src.Byte[0],  RISCV_DATA_WIDTH);
            OSIZE_16  : result = `RISCV_V_SX(src.Word[0],  RISCV_DATA_WIDTH);
            OSIZE_32  : result = `RISCV_V_SX(src.Dword[0], RISCV_DATA_WIDTH);
            OSIZE_64  : result = src.Qword[0][RISCV_DATA_WIDTH-1:0];
            OSIZE_128 : result = src.Dqword[0][RISCV_DATA_WIDTH-1:0];
            default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))
        endcase

        return result;
    endfunction: calc_v2i 

endclass: riscv_v_permutation_alu_model

`endif //__RISCV_V_PERMUTATION_ALU_MODEL__ 