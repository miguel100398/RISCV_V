//File: riscv_v_logic_ALU.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector extension logical ALU

module riscv_v_logic_ALU
import riscv_v_pkg::*;
(
    //Control signals
    input  logic              is_reduct,
    input  logic              is_and,
    input  logic              is_or,
    input  osize_vector_t     osize_vector,
    //Input sources
    input  riscv_v_alu_data_t srca,
    input  riscv_v_alu_data_t srcb,
    //Output result
    output riscv_v_wb_data_t  result
);
    logic is_reduct_n;
    logic is_greater_osize8;
    logic is_greater_osize16;
    logic is_greater_osize32;
    logic is_greater_osize64;
    logic [4:1] is_greater_osize_vector;

    //Bitwise results
    riscv_v_src_byte_vector_t and_result;
    riscv_v_src_byte_vector_t or_result;

    assign is_reduct_n = ~is_reduct;

    assign is_greater_osize8  = ~osize_vector[0];
    assign is_greater_osize16 = ~osize_vector[1] & ~osize_vector[0];
    assign is_greater_osize32 = |osize_vector[4:3];
    assign is_greater_osize64 = osize_vector[4];

    assign is_greater_osize_vector = {is_greater_osize64, is_greater_osize32, is_greater_osize16, is_greater_osize8};   

    riscv_v_bw_and bw_and(
        .is_reduct(is_reduct),
        .is_reduct_n(is_reduct_n),
        .is_and(is_and),
        .osize_vector(osize_vector),
        .is_greater_osize_vector(is_greater_osize_vector),
        .srca(srca),
        .srcb(srcb),
        .result(and_result)
    );

    riscv_v_bw_or bw_or(
        .is_reduct(is_reduct),
        .is_reduct_n(is_reduct_n),
        .is_or(is_or),
        .osize_vector(osize_vector),
        .is_greater_osize_vector(is_greater_osize_vector),
        .srca(srca),
        .srcb(srcb),
        .result(or_result)
    );


    //Final Mux result
    assign result.data  = and_result | or_result;
    assign result.valid = srca.valid;

endmodule: riscv_v_logic_ALU
