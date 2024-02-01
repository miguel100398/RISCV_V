//File: riscv_v_adder_wrapper.sv
//Author: Miguel Bucio
//Date: 31/08/23
//Description: RISC-V Vector adder

module riscv_v_adder_wrapper
import riscv_v_pkg::*, riscv_pkg::*;
(
    input  logic[1:0]                  sel_half,
    input  logic                       valid_adder,
    input  logic                       is_reduct,
    input  logic                       is_reduct_n,
    input  logic                       is_add,
    input  logic                       is_sub,
    input  logic                       is_max,
    input  logic                       is_arithmetic,
    input  logic                       is_compare,
    input  logic                       is_signed,
    input  logic                       use_carry,
    input  osize_vector_t              osize_vector,
    input  osize_vector_t              is_greater_osize_vector,
    input  riscv_v_alu_data_t          srca,
    input  riscv_v_alu_data_t          srcb,
    input  riscv_v_carry_in_t          carry_in,
    output logic[31:0]                 result_out,
    output riscv_v_zf_t                zf,
    output riscv_v_of_t                of,
    output riscv_v_cf_t                cf
);

riscv_v_src_byte_vector_t result;

always_comb begin
    case(sel_half)
        0: result_out = result[0 +: 4];
        1: result_out = result[4 +: 4];
        2: result_out = result[8 +: 4];
        3: result_out = result[12 +: 4];
    endcase

end

riscv_v_adder adder(
    .valid_adder(valid_adder),
    .is_reduct(is_reduct),
    .is_reduct_n(is_reduct_n),
    .is_add(is_add),
    .is_sub(is_sub),
    .is_max(is_max),
    .is_arithmetic(is_arithmetic),
    .is_compare(is_compare),
    .is_signed(is_signed),
    .use_carry(use_carry),
    .osize_vector(osize_vector),
    .is_greater_osize_vector(is_greater_osize_vector),
    .srca(srca),
    .srcb(srcb),
    .carry_in(carry_in),
    .result(result),
    .zf(zf),
    .of(of),
    .cf(cf)
);


endmodule: riscv_v_adder_wrapper