//File: riscv_v_decode.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension Decode Stage
`timescale 1ns/1ps

module riscv_v_decode 
import riscv_pkg::*, riscv_v_pkg::*;
(
    //Clocks and resets
    input  logic                        clk,
    input  logic                        rst,
    input  logic                        clear_pipe,
    input  logic                        riscv_stall,
    output logic                        riscv_v_stall,
    //RISCV Integer Interface
    input  riscv_instruction_t          instruction_id,
    //Integer Register File Interface
    input  riscv_data_t                 int_rf_rd_data_id,
    output riscv_data_t                 int_rf_wr_data_wb,
    output logic                        int_rf_wr_en_wb,
    //EXE interface
    output riscv_v_rf_wr_en_t           rf_wr_en_mem,
    output riscv_v_rf_wr_en_t           rf_wr_en_wb,
    output riscv_instr_rs_t             rf_rd_addr_srca_exe,
    output riscv_instr_rs_t             rf_rd_addr_srcb_exe,
    output riscv_instr_rs_t             rf_wr_addr_exe,
    output riscv_instr_rd_t             rf_wr_addr_mem,
    output riscv_instr_rd_t             rf_wr_addr_wb,
    output riscv_v_data_t               rf_wr_data_mem,
    output riscv_v_data_t               rf_wr_data_wb,
    output riscv_v_imm_t                imm_exe,
    output riscv_data_t                 int_rf_rd_data_exe,
    input  riscv_data_t                 int_rf_wr_data_exe,
    output riscv_v_data_t               rf_rd_data_srca_exe,
    output riscv_v_data_t               rf_rd_data_srcb_exe,
    output riscv_v_mask_t               mask_exe,
    output riscv_v_mask_t               mask_merge_exe,
    input  riscv_v_wb_data_t            alu_result_exe,
    output logic                        is_scalar_op_exe,
    output logic                        is_vector_vector_op_exe,
    output logic                        is_scalar_vector_op_exe,
    output logic                        is_scalar_imm_op_exe,
    output logic                        is_scalar_int_op_exe,
    output logic                        is_scalar_fp_op_exe,
    output logic                        is_i2v_exe,
    output logic                        is_v2i_exe,
    output logic                        is_and_exe,
    output logic                        is_or_exe,
    output logic                        is_xor_exe,
    output logic                        is_negate_srca_exe,
    output logic                        is_negate_srcb_exe,
    output logic                        is_negate_result_exe,
    output logic                        is_mask_exe,
    output logic                        use_mask_exe,
    output logic                        is_shift_exe,
    output logic                        is_left_exe,
    output logic                        is_arith_exe,
    output logic                        is_reduct_exe,
    output logic                        is_add_exe,
    output logic                        is_sub_exe,
    output logic                        is_mul_exe,
    output logic                        is_zero_ext_exe,
    output logic                        is_sign_ext_exe,
    output logic                        is_compare_exe,
    output logic                        is_set_equal_exe,
    output logic                        is_set_nequal_exe,
    output logic                        is_set_less_exe,
    output logic                        is_set_greater_exe,
    output logic                        is_max_exe,
    output logic                        is_min_exe,
    output logic                        is_high_exe,
    output logic                        is_signed_exe,
    output logic                        use_carry_exe,
    //CSR External interface
    input  riscv_data_t                 ext_data_in_exe,
    input  logic                        ext_wr_vsstatus_id,
    input  logic                        ext_wr_vtype_id,
    input  logic                        ext_wr_vl_id,
    input  logic                        ext_wr_vstart_id,
    input  logic                        ext_wr_vxrm_id,
    input  logic                        ext_wr_vxsat_id,
    //CSR interface
    output riscv_v_vsstatus_t           vsstatus_exe,
    output riscv_v_vtype_t              vtype_exe,
    output riscv_v_vl_t                 vl_exe,
    output riscv_v_vlenb_t              vlenb_exe,
    output riscv_v_vstart_t             vstart_exe,
    output riscv_v_vxrm_t               vxrm_exe,
    output riscv_v_vxsat_t              vxsat_exe,
    output riscv_v_vcsr_t               vcsr_exe,
    //Interface to synthesis
    input  riscv_v_rf_addr_t            syn_addr,
    output riscv_v_data_t               syn_data
);

//Control signals
logic                        stall;
logic                        flush;
//Register File Signals
riscv_v_rf_addr_t            rf_rd_addr_srca_id;
riscv_v_rf_addr_t            rf_rd_addr_srcb_id;
riscv_v_rf_addr_t            rf_wr_addr_id;
riscv_v_rf_wr_en_t           rf_wr_en_exe;
riscv_v_data_t               rf_wr_data_exe;
riscv_v_data_t               rf_rd_data_srca_id;
riscv_v_data_t               rf_rd_data_srcb_id;
riscv_v_mask_t               mask_id;
riscv_v_mask_t               mask_merge_id;
//Integer Register File Signals
logic                        int_rf_wr_en_id;
//CSR Signals
riscv_v_data_t               vec_data_in_exe;
logic                        vec_wr_vsstatus_id;
logic                        vec_wr_vtype_id;
logic                        vec_wr_vl_id;
logic                        vec_wr_vstart_id;
logic                        vec_wr_vxrm_id;
logic                        vec_wr_vxsat_id;
logic                        csr_wr_en_vsstatus_exe;
logic                        csr_wr_en_vtype_exe;
logic                        csr_wr_en_vl_exe;
logic                        csr_wr_en_vstart_exe;
logic                        csr_wr_en_vxrm_exe;
logic                        csr_wr_en_vxsat_exe;
riscv_v_vsstatus_t           csr_wr_data_vsstatus_exe;
riscv_v_vtype_t              csr_wr_data_vtype_exe;
riscv_v_vl_t                 csr_wr_data_vl_exe;
riscv_v_vstart_t             csr_wr_data_vstart_exe;
riscv_v_vxrm_t               csr_wr_data_vxrm_exe;
riscv_v_vxsat_t              csr_wr_data_vxsat_exe;
riscv_v_vsstatus_t           vsstatus_id;
riscv_v_vtype_t              vtype_id;
riscv_v_vl_t                 vl_id;
riscv_v_vlenb_t              vlenb_id;
riscv_v_vstart_t             vstart_id;
riscv_v_vxrm_t               vxrm_id;
riscv_v_vxsat_t              vxsat_id;
riscv_v_vcsr_t               vcsr_id;


assign riscv_v_stall = stall;

//FIXME: Drive CSR signals
assign vec_wr_vsstatus_id = 1'b0;
assign vec_wr_vtype_id    = 1'b0;
assign vec_wr_vl_id       = 1'b0;
assign vec_wr_vstart_id   = 1'b0;
assign vec_wr_vxrm_id     = 1'b0;
assign vec_wr_vxsat_id    = 1'b0;

//Control unit
riscv_v_ctrl v_ctrl(
    //Clocks and resets
    .clk(clk),
    .rst(rst),
    .clear_pipe(clear_pipe),
    .riscv_stall(riscv_stall),
    .stall(stall),
    .flush(flush),
    .instruction_id(instruction_id),
    .imm_exe(imm_exe),
    .vs1_id(rf_rd_addr_srca_id),
    .vs1_exe(rf_rd_addr_srca_exe),
    .vs2_id(rf_rd_addr_srcb_id),
    .vs2_exe(rf_rd_addr_srcb_exe),
    .vd_id(rf_wr_addr_id),
    .is_scalar_op_exe(is_scalar_op_exe),
    .is_vector_vector_op_exe(is_vector_vector_op_exe),
    .is_scalar_vector_op_exe(is_scalar_vector_op_exe),
    .is_scalar_imm_op_exe(is_scalar_imm_op_exe),
    .is_scalar_int_op_exe(is_scalar_int_op_exe),
    .is_scalar_fp_op_exe(is_scalar_fp_op_exe),
    .is_i2v_exe(is_i2v_exe),
    .is_v2i_exe(is_v2i_exe),
    .int_rf_wr_en_id(int_rf_wr_en_id),
    .is_and_exe(is_and_exe),
    .is_or_exe(is_or_exe),
    .is_xor_exe(is_xor_exe),
    .is_negate_srca_exe(is_negate_srca_exe),
    .is_negate_srcb_exe(is_negate_srcb_exe),
    .is_negate_result_exe(is_negate_result_exe),
    .is_mask_exe(is_mask_exe),
    .use_mask_exe(use_mask_exe),
    .is_shift_exe(is_shift_exe),
    .is_left_exe(is_left_exe),
    .is_arith_exe(is_arith_exe),
    .is_reduct_exe(is_reduct_exe),
    .is_add_exe(is_add_exe),
    .is_sub_exe(is_sub_exe),
    .is_mul_exe(is_mul_exe),
    .is_zero_ext_exe(is_zero_ext_exe),
    .is_sign_ext_exe(is_sign_ext_exe),
    .is_compare_exe(is_compare_exe),
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

//CSR control
assign vec_data_in_exe = alu_result_exe.data;

riscv_v_csr_ctrl v_csr_ctrl(
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .flush(flush),
    //RISCV External interface
    .ext_data_in_exe(ext_data_in_exe),
    .ext_wr_vsstatus_id(ext_wr_vsstatus_id),
    .ext_wr_vtype_id(ext_wr_vtype_id),
    .ext_wr_vl_id(ext_wr_vl_id),
    .ext_wr_vstart_id(ext_wr_vstart_id),
    .ext_wr_vxrm_id(ext_wr_vxrm_id),
    .ext_wr_vxsat_id(ext_wr_vxsat_id),
    //RISCV Vector interface
    .vec_data_in_exe(vec_data_in_exe),
    .vec_wr_vsstatus_id(vec_wr_vsstatus_id),
    .vec_wr_vtype_id(vec_wr_vtype_id),
    .vec_wr_vl_id(vec_wr_vl_id),
    .vec_wr_vstart_id(vec_wr_vstart_id),
    .vec_wr_vxrm_id(vec_wr_vxrm_id),
    .vec_wr_vxsat_id(vec_wr_vxsat_id),
    //CSR Interface
    .csr_wr_en_vsstatus_exe(csr_wr_en_vsstatus_exe),
    .csr_wr_en_vtype_exe(csr_wr_en_vtype_exe),
    .csr_wr_en_vl_exe(csr_wr_en_vl_exe),
    .csr_wr_en_vstart_exe(csr_wr_en_vstart_exe),
    .csr_wr_en_vxrm_exe(csr_wr_en_vxrm_exe),
    .csr_wr_en_vxsat_exe(csr_wr_en_vxsat_exe),
    .csr_wr_data_vsstatus_exe(csr_wr_data_vsstatus_exe),
    .csr_wr_data_vtype_exe(csr_wr_data_vtype_exe),
    .csr_wr_data_vl_exe(csr_wr_data_vl_exe),
    .csr_wr_data_vstart_exe(csr_wr_data_vstart_exe),
    .csr_wr_data_vxrm_exe(csr_wr_data_vxrm_exe),
    .csr_wr_data_vxsat_exe(csr_wr_data_vxsat_exe),
    //CSR
    .vsstatus_id(vsstatus_id),
    .vtype_id(vtype_id),
    .vl_id(vl_id),
    .vstart_id(vstart_id),
    .vxrm_id(vxrm_id),
    .vxsat_id(vxsat_id),
    .vsstatus_exe(vsstatus_exe),
    .vtype_exe(vtype_exe),
    .vl_exe(vl_exe),
    .vstart_exe(vstart_exe),
    .vxrm_exe(vxrm_exe),
    .vxsat_exe(vxsat_exe)
);

//CSR
riscv_v_csr v_csr(
    .clk(clk),
    .rst(rst),
    .vsstatus_data_in(csr_wr_data_vsstatus_exe),
    .vsstatus_wr_en(csr_wr_en_vsstatus_exe),
    .vsstatus_data_out(vsstatus_id),
    .vtype_data_in(csr_wr_data_vtype_exe),
    .vtype_wr_en(csr_wr_en_vtype_exe),
    .vtype_data_out(vtype_id),
    .vl_data_in(csr_wr_data_vl_exe),
    .vl_wr_en(csr_wr_en_vl_exe),
    .vl_data_out(vl_id),
    .vlenb_data_out(vlenb_id),
    .vstart_data_in(csr_wr_data_vstart_exe),
    .vstart_wr_en(csr_wr_en_vstart_exe),
    .vstart_data_out(vstart_id),
    .vxrm_data_in(csr_wr_data_vxrm_exe),
    .vxrm_wr_en(csr_wr_en_vxrm_exe),
    .vxrm_data_out(vxrm_id),
    .vxsat_data_in(csr_wr_data_vxsat_exe),
    .vxsat_wr_en(csr_wr_en_vxsat_exe),
    .vxsat_data_out(vxsat_id),
    .vcsr_data_out(vcsr_id)
);

//Register File Control
assign rf_wr_data_exe      = alu_result_exe.data;
assign rf_wr_en_exe        = alu_result_exe.valid;

riscv_v_rf_ctrl v_rf_ctrl(
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .flush(flush),
    //Register File interface
    .rf_wr_addr_id(rf_wr_addr_id),
    .rf_wr_addr_exe(rf_wr_addr_exe),
    .rf_wr_addr_mem(rf_wr_addr_mem),
    .rf_wr_addr_wb(rf_wr_addr_wb),
    .rf_wr_en_exe(rf_wr_en_exe),
    .rf_wr_en_mem(rf_wr_en_mem),
    .rf_wr_en_wb(rf_wr_en_wb),
    .rf_wr_data_exe(rf_wr_data_exe),
    .rf_wr_data_mem(rf_wr_data_mem),
    .rf_wr_data_wb(rf_wr_data_wb),
    .rf_rd_data_srca_id(rf_rd_data_srca_id),
    .rf_rd_data_srca_exe(rf_rd_data_srca_exe),
    .rf_rd_data_srcb_id(rf_rd_data_srcb_id),
    .rf_rd_data_srcb_exe(rf_rd_data_srcb_exe),
    .mask_id(mask_id),
    .mask_exe(mask_exe),
    .mask_merge_id(mask_merge_id),
    .mask_merge_exe(mask_merge_exe),
    //Integer Register File interface
    .int_rf_rd_data_id(int_rf_rd_data_id),
    .int_rf_rd_data_exe(int_rf_rd_data_exe),
    .int_rf_wr_data_exe(int_rf_wr_data_exe),
    .int_rf_wr_data_wb(int_rf_wr_data_wb),
    .int_rf_wr_en_id(int_rf_wr_en_id),
    .int_rf_wr_en_wb(int_rf_wr_en_wb)
);


//Vector register file
riscv_v_rf #(
    .RD_ASYNC(RISCV_V_RF_RD_ASYNC),
    .REG_INPUTS(RISCV_V_RF_REG_INPUTS),
    .USE_BYPASS(RISCV_V_RF_USE_BYPASS)
)v_rf(
    .clk(clk),
    .wr_addr(rf_wr_addr_wb),
    .mask_merge_addr(rf_wr_addr_id),
    .rd_addr_A(rf_rd_addr_srca_id),
    .rd_addr_B(rf_rd_addr_srcb_id),
    .data_in(rf_wr_data_wb),
    .wr_en(rf_wr_en_wb),
    .data_out_A(rf_rd_data_srca_id),
    .data_out_B(rf_rd_data_srcb_id),
    .mask(mask_id),
    .mask_merge(mask_merge_id),
    //Interface to synthesis
    .syn_addr(syn_addr),
    .syn_data(syn_data)
);


endmodule: riscv_v_decode
