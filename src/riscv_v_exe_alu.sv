//File: riscv_v_exe_alu.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension Execute ALUs

module riscv_v_exe_alu 
import riscv_pkg::*, riscv_v_pkg::*;
(
    //Clocks and resets
    input  logic                clk,
    input  logic                rst,
    //Control signals
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
    input  logic                use_carry_exe
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
        .dst_osize_vector(),
        .is_greater_osize_vector(),
        .is_less_osize_vector(),
        .srca(),
        .srcb(),
        .result()
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
        .dst_osize_vector(),
        .src_osize_vector(),
        .is_greater_osize_vector(),
        .is_less_osize_vector(),
        .srca(),
        .srcb(),
        .carry_in(),
        .result(),
        .zf(),
        .of(),
        .cf()
    );

    //Mask  ALU
    riscv_v_mask_ALU mask_ALU(
        .is_mask(is_mask_exe),
        .is_and(is_and_exe),
        .is_or(is_or_exe),
        .is_xor(is_xor_exe),
        .is_negate_srca(is_negate_srca_exe),
        .is_negate_result(is_negate_result_exe),
        .srca(),
        .srcb(),
        .result()
    );
    
    //Permutation ALU
    riscv_v_permutation_ALU permutation_ALU(
        .is_i2v(is_i2v_exe),
        .is_v2i(is_v2i_exe),
        .integer_data_in(),
        .vector_data_in(),
        .integer_data_out(),
        .vector_data_out()
    );


endmodule: riscv_v_exe_alu