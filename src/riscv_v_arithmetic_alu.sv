//File: riscv_v_arithmetic_ALU.sv
//Author: Miguel Bucio
//Date: 31/08/23
//Description: RISC-V Vector extension arithmetic ALU

module riscv_v_arithmetic_ALU
import riscv_v_pkg::*;
(
    //Control signals
    input  logic              is_reduct,
    input  logic              is_add,
    input  logic              is_sub,
    input  logic              is_zero_ext,
    input  logic              is_sign_ext,
    input  logic              is_max,
    input  logic              is_min,
    input  logic              is_signed,
    input  logic              use_carry,
    input  osize_vector_t     osize_vector,
    input  osize_vector_t     is_greater_osize_vector,
    input  osize_vector_t     is_less_osize_vector,
    //Input sources
    input  riscv_v_alu_data_t srca,
    input  riscv_v_alu_data_t srcb,
    input  riscv_v_carry_in_t carry_in,
    //Output result
    output riscv_v_wb_data_t  result,
    output riscv_v_zf_t       zf,
    output riscv_v_of_t       of,
    output riscv_v_cf_t       cf
);

    logic adder_result_valid;
    logic is_reduct_n;

    //Results
    riscv_v_src_byte_vector_t adder_result;
    riscv_v_src_byte_vector_t adder_result_qual;

    riscv_v_zf_t              zf_adder;
    riscv_v_zf_t              of_adder;
    riscv_v_zf_t              cf_adder;

    riscv_v_zf_t              zf_qual;
    riscv_v_of_t              of_qual;
    riscv_v_cf_t              cf_qual;

    assign adder_result_valid = (is_add || is_sub) && (~is_max || ~is_min);
    assign is_reduct_n = ~is_reduct;

    riscv_v_adder adder(
        .is_reduct                  (is_reduct),
        .is_reduct_n                (is_reduct_n),
        .is_add                     (is_add),
        .is_sub                     (is_sub),
        .is_signed                  (is_signed),
        .use_carry                  (use_carry),
        .osize_vector               (osize_vector),
        .is_greater_osize_vector    (is_greater_osize_vector),
        .srca                       (srca),
        .srcb                       (srcb),
        .carry_in                   (carry_in),
        .result                     (adder_result),
        .zf                         (zf_adder),
        .of                         (of_adder),
        .cf                         (cf_adder)
    );


    //Qualify adder result
    assign adder_result_qual = adder_result      & {RISCV_V_DATA_WIDTH{adder_result_valid}};
    assign zf_qual           = zf_adder          & {RISCV_V_NUM_BYTES_DATA{adder_result_valid}};
    assign of_qual           = of_adder          & {RISCV_V_NUM_BYTES_DATA{adder_result_valid}};
    assign cf_qual           = cf_adder          & {RISCV_V_NUM_BYTES_DATA{adder_result_valid}};

    //Final Mux result
    assign result.data = adder_result_qual;
    assign zf          = zf_qual;
    assign of          = of_qual;
    assign cf          = cf_qual;

    assign result.valid = srca.valid;

endmodule: riscv_v_arithmetic_ALU