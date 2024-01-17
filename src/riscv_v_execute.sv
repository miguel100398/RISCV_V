//File: riscv_v_execute.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension Execute Stage

module riscv_v_execute 
import riscv_pkg::*, riscv_v_pkg::*;
(
    //Clocks and resets
    input  logic                       clk,
    input  logic                       rst,
    //Decode interface
    input  riscv_data_t                int_data_exe,
    output riscv_data_t                int_data_result_exe,
    input  riscv_v_data_t              srca_exe,
    input  riscv_v_data_t              srcb_exe,
    input  riscv_v_mask_t              mask_exe,
    output riscv_v_wb_data_t           alu_result_exe,
    output riscv_v_mask_t              mask_result_exe,
    input  logic                       is_vector_vector_op_exe,
    input  logic                       is_vector_scalar_op_exe,
    input  logic                       is_scalar_imm_op_exe,
    input  logic                       is_scalar_int_op_exe,
    input  logic                       is_scalar_fp_op_exe,
    input  logic                       is_i2v_exe,
    input  logic                       is_v2i_exe,
    input  logic                       is_and_exe,
    input  logic                       is_or_exe,
    input  logic                       is_xor_exe,
    input  logic                       is_negate_srca_exe,
    input  logic                       is_negate_result_exe,
    input  logic                       is_mask_exe,
    input  logic                       is_shift_exe,
    input  logic                       is_left_exe,
    input  logic                       is_arith_exe,
    input  logic                       is_reduct_exe,
    input  logic                       is_add_exe,
    input  logic                       is_sub_exe,
    input  logic                       is_mul_exe,
    input  logic                       is_zero_ext_exe,
    input  logic                       is_sign_ext_exe,
    input  logic                       is_set_equal_exe,
    input  logic                       is_set_nequal_exe,
    input  logic                       is_set_less_exe,
    input  logic                       is_set_greater_exe,
    input  logic                       is_max_exe,
    input  logic                       is_min_exe,
    input  logic                       is_high_exe,
    input  logic                       is_signed_exe,
    input  logic                       use_carry_exe,
    //CSR interface
    riscv_v_vtype_t                    vtype,
    riscv_v_vl_t                       vl,
    riscv_v_vstart_t                   vstart   
);

//Execution ALUS
riscv_v_exe_alu exe_alu(
    .clk(clk),
    .rst(rst),
    .is_i2v_exe(is_i2v_exe),
    .is_v2i_exe(is_v2i_exe),
    .is_and_exe(is_and_exe),
    .is_or_exe(is_or_exe),
    .is_xor_exe(is_xor_exe),
    .is_negate_srca_exe(is_negate_srca_exe),
    .is_negate_result_exe(is_negate_result_exe),
    .is_mask_exe(is_mask_exe),
    .is_shift_exe(is_shift_exe),
    .is_left_exe(is_left_exe),
    .is_arith_exe(is_arith_exe),
    .is_reduct_exe(is_reduct_exe),
    .is_add_exe(is_add_exe),
    .is_sub_exe(is_sub_exe),
    .is_mul_exe(is_mul_exe),
    .is_zero_ext_exe(is_zero_ext_exe),
    .is_sign_ext_exe(is_sign_ext_exe),
    .is_set_equal_exe(is_set_equal_exe),
    .is_set_nequal_exe(is_set_nequal_exe),
    .is_set_less_exe(is_set_less_exe),
    .is_set_greater_exe(is_set_greater_exe),
    .is_max_exe(is_max_exe),
    .is_min_exe(is_min_exe),
    .is_high_exe(is_high_exe),
    .is_signed_exe(is_signed_exe),
    .use_carry_exe(use_carry_exe)
);

endmodule: riscv_v_execute