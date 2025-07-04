//File: riscv_v.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension Top module
`timescale 1ns/1ps

module riscv_v 
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
    `ifdef RISCV_V_INST 
        input riscv_v_opcode_e  opcode_id,
    `endif //RISCV_V_INST
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
    input  logic                        ext_wr_vxsat_id,
    //Interface to synthesis
    input  riscv_v_rf_addr_t            syn_addr,
    output riscv_v_data_t               syn_data                 
);

    //DECODE/EXE signals
    riscv_data_t                 int_rf_rd_data_exe;
    riscv_data_t                 int_rf_wr_data_exe;
    riscv_v_data_t               rf_rd_data_srca_exe;
    riscv_v_data_t               rf_rd_data_srcb_exe;
    riscv_v_mask_t               mask_exe;
    riscv_v_mask_t               mask_merge_exe;
    riscv_v_wb_data_t            alu_result_exe;
    logic                        is_scalar_op_exe;
    logic                        is_vector_vector_op_exe;
    logic                        is_scalar_vector_op_exe;
    logic                        is_scalar_imm_op_exe;
    logic                        is_scalar_int_op_exe;
    logic                        is_scalar_fp_op_exe;
    logic                        is_i2v_exe;
    logic                        is_v2i_exe;
    logic                        is_and_exe;
    logic                        is_or_exe;
    logic                        is_xor_exe;
    logic                        is_negate_srca_exe;
    logic                        is_negate_srcb_exe;
    logic                        is_negate_result_exe;
    logic                        is_mask_exe;
    logic                        use_mask_exe;
    logic                        is_shift_exe;
    logic                        is_left_exe;
    logic                        is_arith_exe;
    logic                        is_reduct_exe;
    logic                        is_add_exe;
    logic                        is_sub_exe;
    logic                        is_mul_exe;
    logic                        is_zero_ext_exe;
    logic                        is_sign_ext_exe;
    logic                        is_compare_exe;
    logic                        is_set_equal_exe;
    logic                        is_set_nequal_exe;
    logic                        is_set_less_exe;
    logic                        is_set_greater_exe;
    logic                        is_max_exe;
    logic                        is_min_exe;
    logic                        is_high_exe;
    logic                        is_signed_exe;
    logic                        use_carry_exe;
    riscv_v_imm_t                imm_exe;
    //CSR
    riscv_v_vsstatus_t           vsstatus_exe;
    riscv_v_vtype_t              vtype_exe;
    riscv_v_vl_t                 vl_exe;
    riscv_v_vlenb_t              vlenb_exe;
    riscv_v_vstart_t             vstart_exe;
    riscv_v_vxrm_t               vxrm_exe;
    riscv_v_vxsat_t              vxsat_exe;
    riscv_v_vcsr_t               vcsr_exe;
    //Bypass 
    riscv_v_rf_wr_en_t   rf_wr_en_mem;
    riscv_v_rf_wr_en_t   rf_wr_en_wb;
    riscv_instr_rs_t     rf_rd_addr_srca_exe;
    riscv_instr_rs_t     rf_rd_addr_srcb_exe;
    riscv_instr_rs_t     rf_wr_addr_exe;
    riscv_instr_rd_t     rf_wr_addr_mem;
    riscv_instr_rd_t     rf_wr_addr_wb;
    riscv_v_data_t       rf_wr_data_mem;
    riscv_v_data_t       rf_wr_data_wb;

    `ifdef RISCV_V_INST

        riscv_v_opcode_e opcode_exe;
        logic stall_inst;
        assign stall_inst = riscv_stall || riscv_v_stall;

        riscv_v_stage#(.DATA_T(riscv_v_opcode_e),  .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY)) riscv_v_opcode_inst_stage (.clk(clk), .rst(rst), .en(~stall_inst), .flush(clear_pipe), .rst_val(riscv_v_opcode_e'('x)), .flush_val(riscv_v_opcode_e'('x)), .data_in(opcode_id),  .data_out(opcode_exe));

    `endif //RISCV_V_INST

    //Decode stage
    riscv_v_decode v_decode(
        .clk(clk),
        .rst(rst),
        .clear_pipe(clear_pipe),
        .riscv_stall(riscv_stall),
        .riscv_v_stall(riscv_v_stall),
        .instruction_id(instruction_id),
        //Integer Register File Interface
        .int_rf_rd_data_id(int_rf_rd_data_id),
        .int_rf_wr_data_wb(int_rf_wr_data_wb),
        .int_rf_wr_en_wb(int_rf_wr_en_wb),
        //EXE Interface
        .rf_wr_en_mem(rf_wr_en_mem),
        .rf_wr_en_wb(rf_wr_en_wb),
        .rf_rd_addr_srca_exe(rf_rd_addr_srca_exe),
        .rf_rd_addr_srcb_exe(rf_rd_addr_srcb_exe),
        .rf_wr_addr_exe(rf_wr_addr_exe),
        .rf_wr_addr_mem(rf_wr_addr_mem),
        .rf_wr_addr_wb(rf_wr_addr_wb),
        .rf_wr_data_mem(rf_wr_data_mem),
        .rf_wr_data_wb(rf_wr_data_wb),
        .imm_exe(imm_exe),
        .int_rf_rd_data_exe(int_rf_rd_data_exe),
        .int_rf_wr_data_exe(int_rf_wr_data_exe),
        .rf_rd_data_srca_exe(rf_rd_data_srca_exe),
        .rf_rd_data_srcb_exe(rf_rd_data_srcb_exe),
        .mask_exe(mask_exe),
        .mask_merge_exe(mask_merge_exe),
        .alu_result_exe(alu_result_exe),
        .is_scalar_op_exe(is_scalar_op_exe),
        .is_vector_vector_op_exe(is_vector_vector_op_exe),
        .is_scalar_vector_op_exe(is_scalar_vector_op_exe),
        .is_scalar_imm_op_exe(is_scalar_imm_op_exe),
        .is_scalar_int_op_exe(is_scalar_int_op_exe),
        .is_scalar_fp_op_exe(is_scalar_fp_op_exe),
        .is_i2v_exe(is_i2v_exe),
        .is_v2i_exe(is_v2i_exe),
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
        .vsstatus_exe(vsstatus_exe),
        .vtype_exe(vtype_exe),
        .vl_exe(vl_exe),
        .vlenb_exe(vlenb_exe),
        .vstart_exe(vstart_exe),
        .vxrm_exe(vxrm_exe),
        .vxsat_exe(vxsat_exe),
        .vcsr_exe(vcsr_exe),
        //Interface to synthesis
        .syn_addr(syn_addr),
        .syn_data(syn_data)
    );

    //Execute stage
    riscv_v_execute v_execute(
        .clk(clk),
        .rst(rst),
        //Decode interface
        `ifdef RISCV_V_INST
            .opcode_exe(opcode_exe),
        `endif //RISCV_V_INST
        .int_data_exe(int_rf_rd_data_exe),
        .imm_exe(imm_exe),
        .int_data_result_exe(int_rf_wr_data_exe),
        .srca_exe(rf_rd_data_srca_exe),
        .srcb_exe(rf_rd_data_srcb_exe),
        .mask_exe(mask_exe),
        .mask_merge_exe(mask_merge_exe),
        .alu_result_exe(alu_result_exe),
        //Bypass
        .rf_wr_en_mem(rf_wr_en_mem),
        .rf_wr_en_wb(rf_wr_en_wb),
        .rf_rd_addr_srca_exe(rf_rd_addr_srca_exe),
        .rf_rd_addr_srcb_exe(rf_rd_addr_srcb_exe),
        .rf_wr_addr_exe(rf_wr_addr_exe),
        .rf_wr_addr_mem(rf_wr_addr_mem),
        .rf_wr_addr_wb(rf_wr_addr_wb),
        .rf_wr_data_mem(rf_wr_data_mem),
        .rf_wr_data_wb(rf_wr_data_wb),
        //Control
        .is_scalar_op_exe(is_scalar_op_exe),
        .is_vector_vector_op_exe(is_vector_vector_op_exe),
        .is_scalar_vector_op_exe(is_scalar_vector_op_exe),
        .is_scalar_imm_op_exe(is_scalar_imm_op_exe),
        .is_scalar_int_op_exe(is_scalar_int_op_exe),
        .is_scalar_fp_op_exe(is_scalar_fp_op_exe),
        .is_i2v_exe(is_i2v_exe),
        .is_v2i_exe(is_v2i_exe),
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
        .use_carry_exe(use_carry_exe),
        .vtype_exe(vtype_exe),
        .vl_exe(vl_exe),
        .vstart_exe(vstart_exe)
    );

    //Memory stage
    riscv_v_memory v_memory(
        .clk(clk),
        .rst(rst)
    );

endmodule: riscv_v 
