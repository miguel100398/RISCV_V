//File: riscv_v_ctrl.sv
//Author: Miguel Bucio
//Date: 16/01/24
//Description: RISC-V Vector Control unit
`timescale 1ns/1ps

module riscv_v_ctrl 
import riscv_pkg::*, riscv_v_pkg::*;
(
    //Clocks and resets
    input  logic                clk,
    input  logic                rst,
    input  logic                clear_pipe,
    input  logic                riscv_stall,
    output logic                stall,
    output logic                flush,
    //Instruction
    input  riscv_instruction_t  instruction_id,
    //Register File Interface
    output riscv_instr_rs_t     vs1_id,
    output riscv_instr_rs_t     vs1_exe,
    output riscv_instr_rs_t     vs2_id,
    output riscv_instr_rs_t     vs2_exe,
    output riscv_instr_rs_t     vd_id,
    //EXE Interface
    output riscv_v_imm_t        imm_exe,
    output logic                is_scalar_op_exe,
    output logic                is_vector_vector_op_exe,
    output logic                is_scalar_vector_op_exe,
    output logic                is_scalar_imm_op_exe,
    output logic                is_scalar_int_op_exe,
    output logic                is_scalar_fp_op_exe,
    output logic                is_i2v_exe,
    output logic                is_v2i_exe,
    output logic                int_rf_wr_en_id,
    output logic                is_and_exe,
    output logic                is_or_exe,
    output logic                is_xor_exe,
    output logic                is_negate_srca_exe,
    output logic                is_negate_srcb_exe,
    output logic                is_negate_result_exe,
    output logic                use_mask_exe,
    output logic                is_mask_exe,
    output logic                is_shift_exe,
    output logic                is_left_exe,
    output logic                is_arith_exe,
    output logic                is_reduct_exe,
    output logic                is_add_exe,
    output logic                is_sub_exe,
    output logic                is_mul_exe,
    output logic                is_zero_ext_exe,
    output logic                is_sign_ext_exe,
    output logic                is_compare_exe,
    output logic                is_set_equal_exe,
    output logic                is_set_nequal_exe,
    output logic                is_set_less_exe,
    output logic                is_set_greater_exe,
    output logic                is_max_exe,
    output logic                is_min_exe,
    output logic                is_high_exe,
    output logic                is_signed_exe,
    output logic                use_carry_exe
);

logic en_stage;

riscv_instr_op_t riscv_v_op_code_id;
riscv_v_funct3_e riscv_v_funct3_id;
riscv_instr_funct6_t riscv_v_funct6_id;
riscv_v_type_instruction_t riscv_vector_instr_id;
logic vm_id;

//Control signals
logic is_vector_op_id;              //Is vector extension op
logic is_scalar_op_id;              //One source is scalar
logic is_vector_vector_op_id;       //Is vector operation with 2 vector sources
logic is_scalar_vector_op_id;       //Scalar source comes from vector
logic is_scalar_imm_op_id;          //Scalar source comes from immediate
logic is_scalar_int_op_id;          //Scalar source comes from integer RF
logic is_scalar_fp_op_id;           //Scalar source comes from fp RF
logic funct3_is_OPIVV_id;
logic funct3_is_OPIVX_id;
logic funct3_is_OPIVI_id;
logic funct3_is_OPMVV_id;
logic funct3_is_OPMVX_id;
logic funct3_is_OPFVV_id;
logic funct3_is_OPFVF_id;
logic funct3_is_OPI_id;
logic funct3_is_OPM_id;
logic funct3_is_OPIVV_OPIVX_id;
logic funct3_is_OPIVX_OPIVI_id;
//ALU control signals
logic is_i2v_id;
logic is_v2i_id;
logic is_and_id;
logic is_or_id;
logic is_xor_id;
logic is_negate_srca_id;
logic is_negate_srcb_id;
logic is_negate_result_id;
logic use_mask_id;
logic is_mask_id;
logic is_shift_id;
logic is_left_id;
logic is_arith_id;
logic is_reduct_id;
logic is_add_id;
logic is_sub_id;
logic is_mul_id;
logic is_zero_ext_id;
logic is_sign_ext_id;
logic is_set_equal_id;
logic is_set_nequal_id;
logic is_set_less_id;
logic is_set_greater_id;
logic is_compare_id;
logic is_max_id;
logic is_min_id;
logic is_high_id;
logic is_signed_id;
logic use_carry_id;

riscv_v_imm_t imm_id;

logic riscv_v_stall;

assign riscv_v_stall = 1'b0;

assign stall = riscv_v_stall || riscv_stall;

assign en_stage  = ~stall;
assign flush     = clear_pipe;

assign riscv_vector_instr_id = instruction_id.V;
assign riscv_v_op_code_id    = riscv_vector_instr_id.op;
assign riscv_v_funct3_id     = riscv_v_funct3_e'(riscv_vector_instr_id.funct3);
assign riscv_v_funct6_id     = riscv_vector_instr_id.funct6;
assign vs1_id                = riscv_vector_instr_id.vs1;
assign vs2_id                = riscv_vector_instr_id.vs2;
assign vd_id                 = riscv_vector_instr_id.vd;
assign imm_id                = riscv_vector_instr_id.vs1;
assign vm_id                 = riscv_vector_instr_id.vm;

//Control signals
assign is_vector_op_id        = f_is_vector_op(riscv_v_op_code_id);

//Vector/Scalar source
assign is_vector_vector_op_id = f_is_vector_vector_op(riscv_v_funct3_id) && is_vector_op_id;
//Scalar source
assign is_scalar_op_id        = f_is_scalar_op(riscv_v_funct3_id)        && is_vector_op_id;
assign is_scalar_vector_op_id = f_is_scalar_vector_op(riscv_v_funct3_id) && is_vector_op_id;
assign is_scalar_imm_op_id    = f_is_scalar_imm_op(riscv_v_funct3_id)    && is_vector_op_id;
assign is_scalar_int_op_id    = f_is_scalar_int_op(riscv_v_funct3_id)    && is_vector_op_id;
assign is_scalar_fp_op_id     = f_is_scalar_fp_op (riscv_v_funct3_id)    && is_vector_op_id;
//Decode funct3
assign funct3_is_OPIVV_id       = (riscv_v_funct3_id == OPIVV) && is_vector_op_id;
assign funct3_is_OPIVX_id       = (riscv_v_funct3_id == OPIVX) && is_vector_op_id;
assign funct3_is_OPIVI_id       = (riscv_v_funct3_id == OPIVI) && is_vector_op_id;
assign funct3_is_OPMVV_id       = (riscv_v_funct3_id == OPMVV) && is_vector_op_id;
assign funct3_is_OPMVX_id       = (riscv_v_funct3_id == OPMVX) && is_vector_op_id;
assign funct3_is_OPFVV_id       = (riscv_v_funct3_id == OPFVV) && is_vector_op_id;
assign funct3_is_OPFVF_id       = (riscv_v_funct3_id == OPFVF) && is_vector_op_id;
assign funct3_is_OPI_id         = (funct3_is_OPIVV_id || funct3_is_OPIVX_id || funct3_is_OPIVI_id);
assign funct3_is_OPM_id         = (funct3_is_OPMVV_id || funct3_is_OPMVX_id);
assign funct3_is_OPIVV_OPIVX_id = (funct3_is_OPIVV_id || funct3_is_OPIVX_id);
assign funct3_is_OPIVX_OPIVI_id = (funct3_is_OPIVX_id || funct3_is_OPIVI_id);
//Decode ALU control signals
assign is_i2v_id            = f_is_i2v          (riscv_v_funct6_id, funct3_is_OPMVX_id, vs2_id)                                                                                     && is_vector_op_id;
assign is_v2i_id            = f_is_v2i          (riscv_v_funct6_id, funct3_is_OPMVV_id, vs1_id)                                                                                     && is_vector_op_id;
assign is_and_id            = f_is_and          (riscv_v_funct6_id, funct3_is_OPMVV_id, funct3_is_OPI_id)                                                                           && is_vector_op_id;
assign is_or_id             = f_is_or           (riscv_v_funct6_id, funct3_is_OPMVV_id, funct3_is_OPI_id)                                                                           && is_vector_op_id;
assign is_xor_id            = f_is_xor          (riscv_v_funct6_id, funct3_is_OPMVV_id, funct3_is_OPI_id)                                                                           && is_vector_op_id;
assign is_negate_srca_id    = f_is_negate_srca  (riscv_v_funct6_id, funct3_is_OPMVV_id, funct3_is_OPI_id, funct3_is_OPIVV_OPIVX_id, funct3_is_OPIVX_OPIVI_id)                       && is_vector_op_id;
assign is_negate_srcb_id    = f_is_negate_srcb  (riscv_v_funct6_id, funct3_is_OPMVV_id, funct3_is_OPMVX_id, funct3_is_OPIVV_OPIVX_id)                                               && is_vector_op_id;
assign is_negate_result_id  = f_is_negate_result(riscv_v_funct6_id, funct3_is_OPMVV_id)                                                                                             && is_vector_op_id;
assign use_mask_id          = f_use_mask        (vm_id, use_carry_id)                                                                                                               && is_vector_op_id;
assign is_mask_id           = f_is_mask         (riscv_v_funct6_id, funct3_is_OPMVV_id, funct3_is_OPI_id, funct3_is_OPIVV_OPIVX_id, funct3_is_OPIVX_OPIVI_id)                       && is_vector_op_id;
assign is_shift_id          = f_is_shift        (riscv_v_funct6_id, funct3_is_OPI_id)                                                                                               && is_vector_op_id;
assign is_left_id           = f_is_left         (riscv_v_funct6_id, funct3_is_OPI_id)                                                                                               && is_vector_op_id;
assign is_arith_id          = f_is_arith        (riscv_v_funct6_id, funct3_is_OPI_id)                                                                                               && is_vector_op_id;
assign is_reduct_id         = f_is_reduct       (riscv_v_funct6_id, funct3_is_OPMVV_id, funct3_is_OPMVX_id)                                                                         && is_vector_op_id;
assign is_add_id            = f_is_add          (riscv_v_funct6_id, funct3_is_OPI_id, funct3_is_OPMVV_id, funct3_is_OPMVX_id)                                                       && is_vector_op_id;
assign is_sub_id            = f_is_sub          (riscv_v_funct6_id, funct3_is_OPI_id, funct3_is_OPMVV_id, funct3_is_OPIVV_OPIVX_id, funct3_is_OPIVX_OPIVI_id, funct3_is_OPMVX_id)   && is_vector_op_id;
assign is_mul_id            = f_is_mul          (riscv_v_funct6_id, funct3_is_OPM_id)                                                                                               && is_vector_op_id;
assign is_zero_ext_id       = f_is_zero_ext     (riscv_v_funct6_id, funct3_is_OPMVV_id, vs1_id)                                                                                     && is_vector_op_id;
assign is_sign_ext_id       = f_is_sign_ext     (riscv_v_funct6_id, funct3_is_OPMVV_id, vs1_id)                                                                                     && is_vector_op_id;
assign is_set_equal_id      = f_is_set_equal    (riscv_v_funct6_id, funct3_is_OPI_id)                                                                                               && is_vector_op_id;
assign is_compare_id        = f_is_compare      (riscv_v_funct6_id, funct3_is_OPI_id, funct3_is_OPIVV_OPIVX_id, funct3_is_OPIVX_OPIVI_id)                                           && is_vector_op_id;
assign is_set_nequal_id     = f_is_set_nequal   (riscv_v_funct6_id, funct3_is_OPI_id)                                                                                               && is_vector_op_id;
assign is_set_less_id       = f_is_set_less     (riscv_v_funct6_id, funct3_is_OPIVV_OPIVX_id, funct3_is_OPI_id)                                                                     && is_vector_op_id;
assign is_set_greater_id    = f_is_set_greater  (riscv_v_funct6_id, funct3_is_OPIVX_OPIVI_id)                                                                                       && is_vector_op_id;
assign is_max_id            = f_is_max          (riscv_v_funct6_id, funct3_is_OPIVV_OPIVX_id, funct3_is_OPMVV_id)                                                                   && is_vector_op_id;
assign is_min_id            = f_is_min          (riscv_v_funct6_id, funct3_is_OPIVV_OPIVX_id, funct3_is_OPMVV_id)                                                                   && is_vector_op_id;
assign is_high_id           = f_is_high         (riscv_v_funct6_id, funct3_is_OPM_id)                                                                                               && is_vector_op_id;
assign is_signed_id         = f_is_signed       (riscv_v_funct6_id, funct3_is_OPI_id, funct3_is_OPMVV_id, funct3_is_OPIVV_OPIVX_id, funct3_is_OPIVX_OPIVI_id, funct3_is_OPM_id)     && is_vector_op_id;
assign use_carry_id         = f_use_carry       (riscv_v_funct6_id, funct3_is_OPI_id, funct3_is_OPIVV_OPIVX_id)                                                                     && is_vector_op_id;
assign int_rf_wr_en_id      = is_v2i_id;

//Stage signals
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_vector_vector  (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_vector_vector_op_id),   .data_out(is_vector_vector_op_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_scalar         (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_scalar_op_id),          .data_out(is_scalar_op_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_vector_scalar  (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_scalar_vector_op_id),   .data_out(is_scalar_vector_op_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_scalar_imm     (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_scalar_imm_op_id),      .data_out(is_scalar_imm_op_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_scalar_int     (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_scalar_int_op_id),      .data_out(is_scalar_int_op_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_scalar_fp      (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_scalar_fp_op_id),       .data_out(is_scalar_fp_op_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_i2v            (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_i2v_id),                .data_out(is_i2v_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_v2i            (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_v2i_id),                .data_out(is_v2i_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_and            (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_and_id),                .data_out(is_and_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_or             (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_or_id),                 .data_out(is_or_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_xor            (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_xor_id),                .data_out(is_xor_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_negate_srca    (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_negate_srca_id),        .data_out(is_negate_srca_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_negate_srcb    (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_negate_srcb_id),        .data_out(is_negate_srcb_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_negate_result  (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_negate_result_id),      .data_out(is_negate_result_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_mask           (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_mask_id),               .data_out(is_mask_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_use_mask          (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(use_mask_id),              .data_out(use_mask_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_shift          (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_shift_id),              .data_out(is_shift_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_left           (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_left_id),               .data_out(is_left_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_arith          (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_arith_id),              .data_out(is_arith_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_reduct         (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_reduct_id),             .data_out(is_reduct_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_add            (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_add_id),                .data_out(is_add_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_sub            (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_sub_id),                .data_out(is_sub_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_mul            (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_mul_id),                .data_out(is_mul_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_zero_ext       (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_zero_ext_id),           .data_out(is_zero_ext_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_sign_ext       (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_sign_ext_id),           .data_out(is_sign_ext_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_compare        (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_compare_id),            .data_out(is_compare_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_set_equal      (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_set_equal_id),          .data_out(is_set_equal_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_set_nequal     (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_set_nequal_id),         .data_out(is_set_nequal_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_set_less       (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_set_less_id),           .data_out(is_set_less_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_set_greater    (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_set_greater_id),        .data_out(is_set_greater_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_max            (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_max_id),                .data_out(is_max_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_min            (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_min_id),                .data_out(is_min_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_high           (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_high_id),               .data_out(is_high_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_is_signed         (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(is_signed_id),             .data_out(is_signed_exe));
riscv_v_stage#(.DATA_T(logic),              .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_use_carry         (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(use_carry_id),             .data_out(use_carry_exe));
riscv_v_stage#(.DATA_T(riscv_v_imm_t),      .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_imm               (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('x), .flush_val('x), .data_in(imm_id),                   .data_out(imm_exe));
riscv_v_stage#(.DATA_T(riscv_instr_rs_t),   .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_vs1               (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('x), .flush_val('x), .data_in(vs1_id),                   .data_out(vs1_exe));
riscv_v_stage#(.DATA_T(riscv_instr_rs_t),   .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_vs2               (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('x), .flush_val('x), .data_in(vs2_id),                   .data_out(vs2_exe));

////////////////////////////////////Assertions//////////////////////////////////////////////////
scalar_fp_supported: assert property ( @(posedge clk)
    !is_scalar_fp_op_id
) else $fatal(1, "Scalar operation with floation point source is not supported yet");

vector_scalar_op_mutex: assert property ( @(posedge clk)
    !(is_vector_vector_op_id && is_scalar_op_id)
) else $fatal(1, "Vector and scalar op asserted at the same time");

vector_vector_without_vector_op: assert property ( @(posedge clk)
    !(is_vector_vector_op_id && ~is_vector_op_id)
) else $fatal(1, "vector_vector_op  asserted without vector_op");

vector_scalar_without_vector_op: assert property ( @(posedge clk)
    !(is_scalar_op_id && ~is_vector_op_id)
) else $fatal(1, "vector_scalar_op  asserted without vector_op");

scalar_vec_withour_scalar_op: assert property ( @(posedge clk)
    !(is_scalar_vector_op_id && ~is_scalar_op_id)
) else $fatal(1, "scalar_vec op asserted without scalar_op");

scalar_imm_without_scalar_op: assert property ( @(posedge clk)
    !(is_scalar_imm_op_id && ~is_scalar_op_id)
) else $fatal(1, "scalar_imm op asserted without scalar_op");

scalar_int_without_scalar_op: assert property ( @(posedge clk)
    !(is_scalar_int_op_id && ~is_scalar_op_id)
) else $fatal(1, "scalar_int op asserted without scalar_op");

scalar_fp_without_scalar_op: assert property ( @(posedge clk)
    !(is_scalar_fp_op_id && ~is_scalar_op_id)
) else $fatal(1, "scalar_fp op asserted without scalar_op");

compare_without_is_set_op: assert property ( @(posedge clk)
    is_compare_id |-> |{is_set_equal_id, is_set_nequal_id, is_set_less_id, is_set_greater_id}
) else $fatal(1, $sformatf("is_compare, without is_set op: {equal, nequal, less, greater} : %0b", {is_set_equal_id, is_set_nequal_id, is_set_less_id, is_set_greater_id}));

scalar_src_mutex: assert property ( @(posedge clk)
    $onehot0({is_scalar_vector_op_id, is_scalar_imm_op_id, is_scalar_int_op_id, is_scalar_fp_op_id})
) else $fatal(1, $sformatf("scalar source is not mutex {vec,imm,int,fp}: %0b", {is_scalar_vector_op_id, is_scalar_imm_op_id, is_scalar_int_op_id, is_scalar_fp_op_id}));

use_mask_dest_reg: assert property ( @(posedge clk)
    !(use_mask_id && (vd_id == 0))
) else $fatal(1, "Vector destination can't be 0 if mask is used");

endmodule: riscv_v_ctrl
