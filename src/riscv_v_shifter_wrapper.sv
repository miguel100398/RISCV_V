//File: riscv_v_shifter_wrapper.sv
//Author: Miguel Bucio
//Date: 13/08/23
//Description: RISC-V Vector extension shifter

module riscv_v_shifter_wrapper
import riscv_v_pkg::*;
(
    input  logic[1:0]         sel_half,
    input  logic              is_shift,
    input  logic              is_left,
    input  logic              is_arith,
    input  osize_vector_t     osize_vector,
    input  osize_vector_t     is_less_osize_vector,
    input  osize_vector_t     is_greater_osize_vector,
    //Input sources
    input  riscv_v_alu_data_t srca,
    input  riscv_v_alu_data_t srcb,
    //Output result
    output logic [31:0]  result_out
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

riscv_v_shifter shifter(
    .is_shift(is_shift),
    .is_left(is_left),
    .is_arith(is_arith),
    .osize_vector(osize_vector),
    .is_less_osize_vector(is_less_osize_vector),
    .is_greater_osize_vector(is_greater_osize_vector),
    .srca(srca),
    .srcb(srcb),
    .result(result)
);

endmodule: riscv_v_shifter_wrapper