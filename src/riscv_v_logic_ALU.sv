//File: riscv_v_logic_ALU.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector extension logical ALU

module riscv_v_logic_ALU
import riscv_v_pkg::*, riscv_pkg::*;
(
    //Control signals
    input  logic              is_reduct,
    input  logic              is_and,
    input  logic              is_or,
    input  logic              is_xor,
    input  logic              is_mask,
    input  logic              is_shift,
    input  logic              is_left,
    input  logic              is_arith,
    input  osize_vector_t     dst_osize_vector,
    input  osize_vector_t     is_greater_osize_vector,
    input  osize_vector_t     is_less_osize_vector,
    `ifdef RISCV_V_INST 
        input riscv_v_osize_e   osize,
        input riscv_v_opcode_e  opcode,
        input riscv_v_src_len_t len,
    `endif //RISCV_V_INST
    //Input sources
    input  riscv_v_alu_data_t srca,
    input  riscv_v_alu_data_t srcb,
    //Output result
    output riscv_v_wb_data_t  result
);
    logic is_reduct_n;

    logic valid_result;

    //Bitwise results
    riscv_v_src_byte_vector_t and_result;
    riscv_v_src_byte_vector_t or_result;
    riscv_v_src_byte_vector_t xor_result;
    riscv_v_src_byte_vector_t shifter_result;

    assign valid_result = is_and || is_or || is_xor || is_mask || is_shift;

    assign is_reduct_n = ~is_reduct;

    riscv_v_bw_and bw_and(
        .is_reduct(is_reduct),
        .is_reduct_n(is_reduct_n),
        .is_and(is_and),
        .is_mask(is_mask),
        .osize_vector(dst_osize_vector),
        .is_greater_osize_vector(is_greater_osize_vector),
        .srca(srca),
        .srcb(srcb),
        .result(and_result)
    );

    riscv_v_bw_or bw_or(
        .is_reduct(is_reduct),
        .is_reduct_n(is_reduct_n),
        .is_or(is_or),
        .is_mask(is_mask),
        .osize_vector(dst_osize_vector),
        .is_greater_osize_vector(is_greater_osize_vector),
        .srca(srca),
        .srcb(srcb),
        .result(or_result)
    );

    riscv_v_bw_xor bw_xor(
        .is_reduct(is_reduct),
        .is_reduct_n(is_reduct_n),
        .is_xor(is_xor),
        .is_mask(is_mask),
        .osize_vector(dst_osize_vector),
        .is_greater_osize_vector(is_greater_osize_vector),
        .srca(srca),
        .srcb(srcb),
        .result(xor_result)
    );

    riscv_v_shifter shifter(
        .is_shift(is_shift),
        .is_left(is_left),
        .is_arith(is_arith),
        .osize_vector(dst_osize_vector),
        .is_less_osize_vector(is_less_osize_vector),
        .is_greater_osize_vector(is_greater_osize_vector),
        .srca(srca),
        .srcb(srcb),
        .result(shifter_result)
    );



    //Final Mux result
    assign result.data  = and_result | or_result | xor_result | shifter_result;
    assign result.valid = srca.valid & {$bits(srca.valid){valid_result}};

endmodule: riscv_v_logic_ALU
