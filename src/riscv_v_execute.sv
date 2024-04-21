//File: riscv_v_execute.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension Execute Stage
`timescale 1ns/1ps

module riscv_v_execute 
import riscv_pkg::*, riscv_v_pkg::*;
(
    //Clocks and resets
    input  logic                       clk,
    input  logic                       rst,
    //Decode interface
    `ifdef RISCV_V_INST 
        input riscv_v_opcode_e  opcode_exe,
    `endif //RISCV_V_INST
    input  riscv_data_t                int_data_exe,
    input  riscv_v_imm_t               imm_exe,
    output riscv_data_t                int_data_result_exe,
    input  riscv_v_data_t              srca_exe,
    input  riscv_v_data_t              srcb_exe,
    input  riscv_v_mask_t              mask_exe,
    output riscv_v_wb_data_t           alu_result_exe,
    //Bypass
    input  riscv_v_rf_wr_en_t          rf_wr_en_mem,
    input  riscv_v_rf_wr_en_t          rf_wr_en_wb,
    input  riscv_instr_rs_t            rf_rd_addr_srca_exe,
    input  riscv_instr_rs_t            rf_rd_addr_srcb_exe,
    input  riscv_instr_rd_t            rf_wr_addr_mem,
    input  riscv_instr_rd_t            rf_wr_addr_wb,
    input  riscv_v_data_t              rf_wr_data_mem,
    input  riscv_v_data_t              rf_wr_data_wb,
    //Control
    input  logic                       is_scalar_op_exe,
    input  logic                       is_vector_vector_op_exe,
    input  logic                       is_scalar_vector_op_exe,
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
    input  logic                       use_mask_exe,
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
    input  riscv_v_vtype_t             vtype,
    input  riscv_v_vl_t                vl,
    input  riscv_v_vstart_t            vstart   
);

riscv_v_data_t srca_byp;
riscv_v_data_t srcb_byp;

riscv_v_alu_data_t  srca_alu;
riscv_v_alu_data_t  srcb_alu;
osize_vector_t      dst_osize_vector;
osize_vector_t      src_osize_vector;
osize_vector_t      is_greater_osize_vector;
osize_vector_t      is_less_osize_vector;


`ifdef RISCV_V_INST
    riscv_v_osize_e     osize_exe;
    riscv_v_src_len_t   len_exe;
`endif //RISCV_V_INST

//Execution ALUS
riscv_v_exe_alu exe_alu(
    .clk(clk),
    .rst(rst),
    `ifdef RISCV_V_INST 
        .osize_exe(osize_exe),
        .opcode_exe(opcode_exe),
        .len_exe(len_exe),
    `endif //RISCV_V_INST
    .srca_exe(srca_alu),
    .srcb_exe(srcb_alu),
    .src_int_exe(int_data_exe),
    .mask_exe(mask_exe),
    .dst_osize_vector_exe(dst_osize_vector),
    .src_osize_vector_exe(src_osize_vector),
    .is_greater_osize_vector_exe(is_greater_osize_vector),
    .is_less_osize_vector_exe(is_less_osize_vector),
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
    .use_carry_exe(use_carry_exe),
    .int_result_exe(int_data_result_exe),
    .vec_result_exe(alu_result_exe)
);

riscv_v_decode_element decode_element(
    .srca(srca_byp),
    .srcb(srcb_byp),
    .vtype(vtype),
    .vl(vl),
    .vstart(vstart),
    .use_mask(use_mask_exe),
    .mask(mask_exe),
    .is_mask(is_mask_exe),
    .srca_alu(srca_alu),
    .srcb_alu(srcb_alu),
    `ifdef RISCV_V_INST
        .len(len_exe),
        .osize(osize_exe),
    `endif //RISCV_V_INST
    .dst_osize_vector(dst_osize_vector),
    .src_osize_vector(src_osize_vector),
    .is_greater_osize_vector(is_greater_osize_vector),
    .is_less_osize_vector(is_less_osize_vector)
);

//Bypass unit
riscv_v_bypass v_bypass(
    .integer_data(int_data_exe),
    .imm(imm_exe),
    .srca(srca_exe),
    .srcb(srcb_exe),
    .osize_vector(src_osize_vector),
    .is_scalar_int(is_scalar_int_op_exe),
    .is_scalar_imm(is_scalar_imm_op_exe),
    .is_scalar_vec(is_scalar_vector_op_exe),
    .is_scalar_fp(is_scalar_fp_op_exe),
    .is_scalar(is_scalar_op_exe),
    .rf_wr_en_mem(rf_wr_en_mem),
    .rf_wr_en_wb(rf_wr_en_wb),
    .rf_rd_addr_srca_exe(rf_rd_addr_srca_exe),
    .rf_rd_addr_srcb_exe(rf_rd_addr_srcb_exe),
    .rf_wr_addr_mem(rf_wr_addr_mem),
    .rf_wr_addr_wb(rf_wr_addr_wb),
    .rf_wr_data_mem(rf_wr_data_mem),
    .rf_wr_data_wb(rf_wr_data_wb),
    .srca_byp(srca_byp),
    .srcb_byp(srcb_byp)
);


endmodule: riscv_v_execute
