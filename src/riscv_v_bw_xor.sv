//File: riscv_v_bw_xor.sv
//Author: Miguel Bucio
//Date: 17/08/23
//Description: RISC-V Vector extension Bitwise and
`timescale 1ns/1ps

module riscv_v_bw_xor
import riscv_v_pkg::*, riscv_pkg::*;
(
    input  logic              is_reduct,
    input  logic              is_reduct_n,
    input  logic              is_xor,
    input  logic              is_mask,
    input  osize_vector_t     osize_vector,
    input  osize_vector_t     is_greater_osize_vector,
    //Input sources
    input  riscv_v_alu_data_t srca,
    input  riscv_v_alu_data_t srcb,
    //Output result
    output riscv_v_src_byte_vector_t  result
);

localparam NUM_BW_BLOCKS = RISCV_V_NUM_BYTES_DATA;

//Srca gated with is_xor
riscv_v_src_byte_vector_t srca_gated;
//Srcb gated with is_xor
riscv_v_src_byte_vector_t srcb_gated;
//Src A input to BW block
riscv_v_src_byte_vector_t srca_bw;
//Src B input to BW block
riscv_v_src_byte_vector_t srcb_bw;
//Bitwisee result
riscv_v_src_byte_vector_t result_bw;

generate
        //Gate (is_or & srcA), (is_or & srcB)
        for (genvar i=0; i<NUM_BW_BLOCKS; i++) begin : gen_is_xor_gating
            assign srca_gated[i] = srca.data.Byte[i] & {BYTE_WIDTH{(is_xor)}};
            assign srcb_gated[i] = srcb.data.Byte[i] & {BYTE_WIDTH{(is_xor)}};
        end
        //Srca input to BW block
        riscv_v_reduct_src reduct_srca(
            .src(srca_gated),
            .is_reduct(is_reduct),
            .is_reduct_n(is_reduct_n),
            .osize_vector(osize_vector),
            .is_greater_osize_vector(is_greater_osize_vector),
            .result(result_bw),
            .src_o(srca_bw)
        );
        //Srcb input to BW block
        //Second input is srcb & ~srcb.valid
        //If srcb is not valid set input to all 0 to do not affect result in reduct operations
        //In bitwise operations invalid bytes will be discarded with srca.valid in the register file
        for (genvar i=0; i<NUM_BW_BLOCKS; i++) begin : gen_srcb_bw
            assign srcb_bw[i] = srcb_gated[i] & {BYTE_WIDTH{(srcb.valid[i] | is_mask)}};
        end

        //Biwtise OR blocks
        for (genvar block=0; block<NUM_BW_BLOCKS; block++) begin : gen_bitwise_xor
            riscv_v_bitwise_xor #(
                .DATA_WIDTH(BYTE_WIDTH)
            )bitwise_xor(
                .A(srca_bw[block]),
                .B(srcb_bw[block]),
                .S(result_bw[block])
            );
        end

        //Final result
        for (genvar i=0; i<NUM_BW_BLOCKS; i++) begin : gen_xor_result
            assign result[i] = result_bw[i];
        end

endgenerate

endmodule: riscv_v_bw_xor