//File: riscv_v_mul_wrapper
//Author: Miguel Bucio
//Date: 20/09/23
//Description: riscv-v Vector extension multiplier (Using vedic multiplier) wrapper with clock to generate timing analysis
`timescale 1ns/1ps

module riscv_v_mul_wrapper
import riscv_v_pkg::*, riscv_pkg::*;
(
    input  logic                        is_mul_in,
    input  logic                        is_high_in,
    input  logic                        is_signed_in,
    input  logic[1:0]                   sel_half,
    input  osize_vector_t               osize_vector_in,
    input  riscv_v_alu_data_t           srca_in,
    input  riscv_v_alu_data_t           srcb_in,
    output logic [31:0]                 result_out
);

    logic is_mul;
    logic is_high;
    logic is_signed;
    osize_vector_t osize_vector;
    riscv_v_alu_data_t srca;
    riscv_v_alu_data_t srcb;
    riscv_v_src_byte_vector_t result;

always_comb begin
    is_mul          = is_mul_in;
    is_high         = is_high_in;
    is_signed       = is_signed_in;
    osize_vector    = osize_vector_in;
    srca            = srca_in;
    srcb            = srcb_in;
    case(sel_half)
        0: result_out = result[0 +: 4];
        1: result_out = result[4 +: 4];
        2: result_out = result[8 +: 4];
        3: result_out = result[12 +: 4];
    endcase
end

riscv_v_mul mul(
    .is_mul(is_mul),
    .is_high(is_high),
    .is_signed(is_signed),
    .osize_vector(osize_vector),
    .srca(srca),
    .srcb(srcb),
    .result(result)
);

endmodule: riscv_v_mul_wrapper