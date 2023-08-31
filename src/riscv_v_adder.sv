//File: riscv_v_adder.sv
//Author: Miguel Bucio
//Date: 31/08/23
//Description: RISC-V Vector adder

module riscv_v_adder
import riscv_v_pkg::*;
(
    input  logic                       is_reduct,
    input  logic                       is_reduct_n,
    input  logic                       is_add,
    input  logic                       is_sub,
    input  logic                       is_signed,
    input  logic                       use_carry,
    input  osize_vector_t              osize_vector,
    input  osize_vector_t              is_greater_osize_vector,
    input  riscv_v_alu_data_t          srca,
    input  riscv_v_alu_data_t          srcb,
    input  riscv_v_carry_in_t          carry_in,
    output riscv_v_src_byte_vector_t   result,
    output riscv_v_zf_t                zf,
    output riscv_v_of_t                of,
    output riscv_v_cf_t                cf
);

localparam NUM_ADD_BLOCKS = RISCV_V_NUM_BYTES_DATA;

logic valid_adder;
//Srca and srcb gated with is_add or is_sub
riscv_v_src_byte_vector_t srca_gated;
riscv_v_src_byte_vector_t srcb_gated;
//SrcB xor with is_sub
riscv_v_src_byte_vector_t srcb_xor_sub;
//Srca input to adder block
riscv_v_src_byte_vector_t srca_adder;
//Srcb input to adder block
riscv_v_src_byte_vector_t srcb_adder;
//Carry in to adder block
riscv_v_carry_in_t        cin_adder;
//Previous Carry out of addder block
riscv_v_carry_in_t        prev_cout_adder;
//Carry out of addder block
riscv_v_carry_in_t        cout_adder;
//Result of adder block
riscv_v_src_byte_vector_t result_adder;
//Merge carry in
riscv_v_carry_in_t        merge_carry_in;

assign valid_adder = is_add || is_sub;

generate
    //Gate sources
    for (genvar block=0; block < NUM_ADD_BLOCKS; block++) begin
        assign srca_gated[block] = srca.data.Byte[block] & {BYTE_WIDTH{valid_adder}};
        assign srcb_gated[block] = srcb.data.Byte[block] & {BYTE_WIDTH{valid_adder}};
    end

    //Xor srcb with is_sub
    for (genvar block=0; block < NUM_ADD_BLOCKS; block++) begin
        assign srcb_xor_sub[block] = srcb_gated[block] ^ {BYTE_WIDTH{is_sub}};
    end

    //Srca input to BW block
    //Input to Most significant Block is only srca
    assign srca_adder[NUM_ADD_BLOCKS-1] = srca_gated[NUM_ADD_BLOCKS-1];
    for (genvar block=NUM_ADD_BLOCKS-2; block>=0; block--) begin : gen_srca_adder
         always_comb begin
            //Fisrt input is srca
            srca_adder[block] = srca_gated[block] & {BYTE_WIDTH{is_reduct_n | is_greater_osize_vector[$clog2(NUM_ADD_BLOCKS-block)]}};        //Select this source if op is not reduct or osize is greater than
            for (int reduct_input=0; reduct_input < $clog2(NUM_ADD_BLOCKS-block); reduct_input++) begin
                srca_adder[block] |= result_adder[block+(2**reduct_input)] & {BYTE_WIDTH{(is_reduct & osize_vector[reduct_input])}};
            end
        end
    end

    //Srcb input to BW block
    //Second input is srcb & ~srcb.valid
    //If srcb is not valid set input to all 0 to do not affect result in reduct operations
    //In not reduct operations invalid bytes will be discarded with srca.valid in the register file
    for (genvar block=0; block < NUM_ADD_BLOCKS; block++) begin : gen_srcb_adder
        assign srcb_adder[block] = srcb_xor_sub[block] & {BYTE_WIDTH{srcb.valid[block]}};
    end

    //Merge carry in
    //First merge_carry_in is 0
    assign merge_carry_in[0] = 1'b0;
    for (genvar block=1; block < NUM_ADD_BLOCKS; block++) begin : gen_merge_cin 
        assign merge_carry_in[block] = cout_adder[block-1] & srca.merge[block-1];
    end 

    assign cin_adder = merge_carry_in;

    //Adder blocks
    for (genvar block=0; block<NUM_ADD_BLOCKS; block++) begin : gen_adder
        ripple_carry_adder #(
            .WIDTH(BYTE_WIDTH)
        )adder(
            .A(srca_adder[block]),
            .B(srcb_adder[block]),
            .cin(cin_adder[block]),
            .S(result_adder[block]),
            .prev_cout(prev_cout_adder[block]),
            .cout(cout_adder[block])
        );
    end

    //Final result
    for (genvar block=0; block < NUM_ADD_BLOCKS; block++) begin : gen_adder_result
        assign result[block] = result_adder[block];
    end

    //Flags
    for (genvar block=0; block < NUM_ADD_BLOCKS; block++) begin : gen_flags
        assign zf[block] = (result_adder[block] == 0);
        assign cf[block] = (cout_adder[block]);
        assign of[block] = cout_adder[block] ^ (prev_cout_adder[block] & is_signed);
    end

endgenerate

endmodule: riscv_v_adder