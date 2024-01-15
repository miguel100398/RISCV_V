//File: riscv_v_bw_xor.sv
//Author: Miguel Bucio
//Date: 17/08/23
//Description: RISC-V Vector extension Bitwise and

module riscv_v_bw_xor
import riscv_v_pkg::*;
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
            assign srca_gated[i] = srca.data.Byte[i] & {BYTE_WIDTH{(is_xor & ~is_mask)}};
            assign srcb_gated[i] = srcb.data.Byte[i] & {BYTE_WIDTH{(is_xor & ~is_mask)}};
        end
        //Srca input to BW block
        //Input to Most significant Block is only srca
        assign srca_bw[NUM_BW_BLOCKS-1] = srca_gated[NUM_BW_BLOCKS-1];
        for (genvar block=NUM_BW_BLOCKS-2; block>=0; block--) begin : gen_srca_bw
            always_comb begin
                //Fisrt input is srca
                srca_bw[block] = srca_gated[block] & {BYTE_WIDTH{is_reduct_n | is_greater_osize_vector[$clog2(NUM_BW_BLOCKS-block)]}};        //Select this source if op is not reduct or osize is greater than
                for (int reduct_input=0; reduct_input < $clog2(NUM_BW_BLOCKS-block); reduct_input++) begin
                    srca_bw[block] |= result_bw[block+(2**reduct_input)] & {BYTE_WIDTH{(is_reduct & osize_vector[reduct_input])}};
                end
            end
        end
        //Srcb input to BW block
        //Second input is srcb & ~srcb.valid
        //If srcb is not valid set input to all 0 to do not affect result in reduct operations
        //In bitwise operations invalid bytes will be discarded with srca.valid in the register file
        for (genvar i=0; i<NUM_BW_BLOCKS; i++) begin : gen_srcb_bw
            assign srcb_bw[i] = srcb_gated[i] & {BYTE_WIDTH{srcb.valid[i]}};
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