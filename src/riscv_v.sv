//File: riscv_v.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension Top module

module riscv_v 
import riscv_pkg::*, riscv_v_pkg::*;
(
    //Clocks and resets
    input  logic                        clk,
    input  logic                        rst,
    input  logic                        clear_pipe,
    //RISCV Integer Interface
    input  riscv_instruction_t          instruction_id,
    //Integer Register File interface
    input  riscv_data_t                 int_rf_rd_data_id,
    output riscv_data_t                 int_rf_wr_data_wb,
    output logic                        int_rf_wr_en_wb,
    //CSR External interface
    input  riscv_data_t                 ext_data_in_exe,
    input  logic                        ext_wr_vsstatus_id,
    input  logic                        ext_wr_vtype_id,
    input  logic                        ext_wr_vl_id,
    input  logic                        ext_wr_vstart_id,
    input  logic                        ext_wr_vxrm_id,
    input  logic                        ext_wr_vxsat_id
);

    //DECODE/EXE signals
    riscv_data_t                 int_rf_rd_data_exe;
    riscv_data_t                 int_rf_wr_data_exe;
    riscv_v_data_t               rf_rd_data_srca_exe;
    riscv_v_data_t               rd_rd_data_srcb_exe;
    riscv_v_mask_t               mask_rf_rd_data_exe;
    riscv_v_wb_data_t            alu_result_exe;
    riscv_v_mask_t               mask_alu_result_exe;
    logic                        is_vector_vector_op_exe;
    logic                        is_vector_scalar_op_exe;
    logic                        is_scalar_imm_op_exe;
    logic                        is_scalar_int_op_exe;
    logic                        is_scalar_fp_op_exe;
    logic                        is_i2v_exe;
    logic                        is_v2i_exe;
    logic                        is_and_exe;
    logic                        is_or_exe;
    logic                        is_xor_exe;
    logic                        is_negate_srca_exe;
    logic                        is_negate_result_exe;
    logic                        is_mask_exe;
    logic                        is_shift_exe;
    logic                        is_left_exe;
    logic                        is_arith_exe;
    logic                        is_reduct_exe;
    logic                        is_add_exe;
    logic                        is_sub_exe;
    logic                        is_mul_exe;
    logic                        is_zero_ext_exe;
    logic                        is_sign_ext_exe;
    logic                        is_set_equal_exe;
    logic                        is_set_nequal_exe;
    logic                        is_set_less_exe;
    logic                        is_set_greater_exe;
    logic                        is_max_exe;
    logic                        is_min_exe;
    logic                        is_high_exe;
    logic                        is_signed_exe;
    logic                        use_carry_exe;
    //CSR
    riscv_v_vsstatus_t           vsstatus;
    riscv_v_vtype_t              vtype;
    riscv_v_vl_t                 vl;
    riscv_v_vlenb_t              vlenb;
    riscv_v_vstart_t             vstart;
    riscv_v_vxrm_t               vxrm;
    riscv_v_vxsat_t              vxsat;
    riscv_v_vcsr_t               vcsr;

    //Decode stage
    riscv_v_decode v_decode(
        .clk(clk),
        .rst(rst),
        .clear_pipe(clear_pipe),
        //Integer Register File Interface
        .int_rf_rd_data_id(int_rf_rd_data_id),
        .int_rf_wr_data_wb(int_rf_wr_data_wb),
        .int_rf_wr_en_wb(int_rf_wr_en_wb),
        //EXE Interface
        .int_rf_rd_data_exe(int_rf_rd_data_exe),
        .int_rf_wr_data_exe(int_rf_wr_data_exe),
        .rf_rd_data_srca_exe(rf_rd_data_srca_exe),
        .rd_rd_data_srcb_exe(rd_rd_data_srcb_exe),
        .mask_rf_rd_data_exe(mask_rf_rd_data_exe),
        .alu_result_exe(alu_result_exe),
        .mask_alu_result_exe(mask_alu_result_exe),
        .is_vector_vector_op_exe(is_vector_vector_op_exe),
        .is_vector_scalar_op_exe(is_vector_scalar_op_exe),
        .is_scalar_imm_op_exe(is_scalar_imm_op_exe),
        .is_scalar_int_op_exe(is_scalar_int_op_exe),
        .is_scalar_fp_op_exe(is_scalar_fp_op_exe),
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
        //CSR External interface
        .ext_data_in_exe(ext_data_in_exe),
        .ext_wr_vsstatus_id(ext_wr_vsstatus_id),
        .ext_wr_vtype_id(ext_wr_vtype_id),
        .ext_wr_vl_id(ext_wr_vl_id),
        .ext_wr_vstart_id(ext_wr_vstart_id),
        .ext_wr_vxrm_id(ext_wr_vxrm_id),
        .ext_wr_vxsat_id(ext_wr_vxsat_id),
        //CSR Interface
        .vsstatus(vsstatus),
        .vtype(vtype),
        .vl(vl),
        .vlenb(vlenb),
        .vstart(vstart),
        .vxrm(vxrm),
        .vxsat(vxsat),
        .vcsr(vcsr)
    );

    //Execute stage
    riscv_v_execute v_execute(
        .clk(clk),
        .rst(rst),
        //Decode interface
        .int_data_exe(int_rf_rd_data_exe),
        .int_data_result_exe(int_rf_wr_data_exe),
        .srca_exe(rf_rd_data_srca_exe),
        .srcb_exe(rf_rd_data_srcb_exe),
        .mask_exe(mask_rf_rd_data_exe),
        .alu_result_exe(alu_result_exe),
        .mask_result_exe(mask_alu_result_exe),
        .is_vector_vector_op_exe(is_vector_vector_op_exe),
        .is_vector_scalar_op_exe(is_vector_scalar_op_exe),
        .is_scalar_imm_op_exe(is_scalar_imm_op_exe),
        .is_scalar_int_op_exe(is_scalar_int_op_exe),
        .is_scalar_fp_op_exe(is_scalar_fp_op_exe),
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
        .vtype(vtype),
        .vl(vl),
        .vstart(vstart)
    );

    //Memory stage
    riscv_v_memory v_memory(
        .clk(clk),
        .rst(rst)
    );

endmodule: riscv_v 