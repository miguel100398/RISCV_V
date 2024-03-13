//File: riscv_v_exe_alu.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension Execute ALUs
`timescale 1ns/1ps

module riscv_v_exe_alu 
import riscv_pkg::*, riscv_v_pkg::*;
(
    //Clocks and resets
    input  logic                clk,
    input  logic                rst,
    `ifdef RISCV_V_INST 
        input riscv_v_osize_e      osize_exe,
        input riscv_v_opcode_e     opcode_exe,
        input riscv_v_src_len_t    len_exe,
    `endif //RISCV_V_INST
    //Sources
    input  riscv_v_alu_data_t   srca_exe,
    input  riscv_v_alu_data_t   srcb_exe,
    input  riscv_data_t         src_int_exe,
    input  riscv_v_mask_t       mask_exe,
    //Control signals
    input  osize_vector_t       dst_osize_vector_exe,
    input  osize_vector_t       src_osize_vector_exe,
    input  osize_vector_t       is_greater_osize_vector_exe,
    input  osize_vector_t       is_less_osize_vector_exe,
    
    input  logic                is_i2v_exe,
    input  logic                is_v2i_exe,
    input  logic                is_and_exe,
    input  logic                is_or_exe,
    input  logic                is_xor_exe,
    input  logic                is_negate_srca_exe,
    input  logic                is_negate_result_exe,
    input  logic                is_mask_exe,
    input  logic                is_shift_exe,
    input  logic                is_left_exe,
    input  logic                is_arith_exe,
    input  logic                is_reduct_exe,
    input  logic                is_add_exe,
    input  logic                is_sub_exe,
    input  logic                is_mul_exe,
    input  logic                is_zero_ext_exe,
    input  logic                is_sign_ext_exe,
    input  logic                is_set_equal_exe,
    input  logic                is_set_nequal_exe,
    input  logic                is_set_less_exe,
    input  logic                is_set_greater_exe,
    input  logic                is_max_exe,
    input  logic                is_min_exe,
    input  logic                is_high_exe,
    input  logic                is_signed_exe,
    input  logic                use_carry_exe,
    //Result
    output riscv_data_t         int_result_exe,
    output riscv_v_wb_data_t    vec_result_exe,
    output riscv_v_mask_t       mask_result_exe
);

    riscv_v_alu_data_t  srca_shuffled_exe;
    riscv_v_shuffler_sel_vector_t shuffler_sel_exe;

    //Results
    riscv_v_wb_data_t   logic_result;
    riscv_v_wb_data_t   arithmetic_result;
    riscv_v_wb_data_t   permutation_result;

    assign vec_result_exe = logic_result
                          | arithmetic_result
                          | permutation_result;
    
    assign shuffler_sel_exe = '{default:'0};

    //Shuffler
    riscv_v_shuffler v_shuffler(
        .src(srca_exe),
        .sel(shuffler_sel_exe),
        .result(srca_shuffled_exe)
    );

    //Logical ALU
    riscv_v_logic_ALU logic_ALU(
        .is_reduct(is_reduct_exe),
        .is_and(is_and_exe),
        .is_or(is_or_exe),
        .is_xor(is_xor_exe),
        .is_mask(is_mask_exe),
        .is_shift(is_shift_exe),
        .is_left(is_left_exe),
        .is_arith(is_arith_exe),
        .dst_osize_vector(dst_osize_vector_exe),
        .is_greater_osize_vector(is_greater_osize_vector_exe),
        .is_less_osize_vector(is_less_osize_vector_exe),
        .srca(srca_shuffled_exe),
        .srcb(srcb_exe),
        `ifdef RISCV_V_INST
            .osize(osize_exe),
            .opcode(opcode_exe),
            .len(len_exe),
        `endif //RISCV_V_INST
        .result(logic_result)
    );
    
    //Arithmetic ALU
    riscv_v_arithmetic_ALU arithmetic_ALU(
        .is_reduct(is_reduct_exe),
        .is_add(is_add_exe),
        .is_sub(is_sub_exe),
        .is_mul(is_mul_exe),
        .is_zero_ext(is_zero_ext_exe),
        .is_sign_ext(is_sign_ext_exe),
        .is_set_equal(is_set_equal_exe),
        .is_set_nequal(is_set_nequal_exe),
        .is_set_less(is_set_less_exe),
        .is_set_greater(is_set_greater_exe),
        .is_max(is_max_exe),
        .is_min(is_min_exe),
        .is_high(is_high_exe),
        .is_signed(is_signed_exe),
        .use_carry(use_carry_exe),
        .dst_osize_vector(dst_osize_vector_exe),
        .src_osize_vector(src_osize_vector_exe),
        .is_greater_osize_vector(is_greater_osize_vector_exe),
        .is_less_osize_vector(is_less_osize_vector_exe),
        .srca(srca_shuffled_exe),
        .srcb(srcb_exe),
        .carry_in(mask_exe),
        `ifdef RISCV_V_INST
            .osize(osize_exe),
            .opcode(opcode_exe),
            .len(len_exe),
        `endif //RISCV_V_INST
        .result(arithmetic_result)
    );

    //Mask  ALU
    riscv_v_mask_ALU mask_ALU(
        .is_mask(is_mask_exe),
        .is_and(is_and_exe),
        .is_or(is_or_exe),
        .is_xor(is_xor_exe),
        .is_negate_srca(is_negate_srca_exe),
        .is_negate_result(is_negate_result_exe),
        .srca(srca_shuffled_exe.data.Bit[RISCV_V_NUM_ELEMENTS_REG-1:0]),
        .srcb(srcb_exe.data.Bit[RISCV_V_NUM_ELEMENTS_REG-1:0]),
        `ifdef RISCV_V_INST
            .opcode(opcode_exe),
        `endif //RISCV_V_INST
        .result(mask_result_exe)
    );

    //Permutation ALU
    riscv_v_permutation_ALU permutation_ALU(
        .is_i2v(is_i2v_exe),
        .is_v2i(is_v2i_exe),
        .integer_data_in(src_int_exe),
        .vector_data_in(srca_shuffled_exe),
        `ifdef RISCV_V_INST
            .opcode(opcode_exe),
        `endif //RISCV_V_INST
        .integer_data_out(int_result_exe),
        .vector_data_out(permutation_result)
    );


endmodule: riscv_v_exe_alu