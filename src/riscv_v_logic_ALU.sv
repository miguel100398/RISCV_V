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
    input  osize_vector_t     osize_vector,
    //Input sources
    input  riscv_v_alu_data_t srca,
    input  riscv_v_alu_data_t srcb,
    //Output result
    output riscv_v_wb_data_t  result
);

    //Bitwise AND results
    riscv_v_src_byte_vector_t and_result;

    riscv_v_bw_and bw_and(
        .is_reduct(is_reduct),
        .is_and(is_and),
        .osize_vector(osize_vector),
        .srca(srca),
        .srcb(srcb),
        .result(and_result)
    );


    //Final Mux result
    assign result.data  = and_result;
    assign result.valid = srca.valid;

endmodule: riscv_v_logic_ALU
