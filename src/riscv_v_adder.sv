//File: riscv_v_adder.sv
//Author: Miguel Bucio
//Date: 31/08/23
//Description: RISC-V Vector adder

module riscv_v_adder
import riscv_v_pkg::*, riscv_pkg::*;
(
    input  logic                       valid_adder,
    input  logic                       is_reduct,
    input  logic                       is_reduct_n,
    input  logic                       is_add,
    input  logic                       is_sub,
    input  logic                       is_max,
    input  logic                       is_set_equal,
    input  logic                       is_set_nequal,
    input  logic                       is_set_less,
    input  logic                       is_set_greater,
    input  logic                       is_arithmetic,
    input  logic                       is_min_max,
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
//Sub Carry in
riscv_v_carry_in_t        sub_carry_in;
//Use carry in
riscv_v_carry_in_t        use_carry_in;
//zero flag previous osize
riscv_v_zf_t              zf_prev_osize;
//zero flag by osize
riscv_v_zf_t              zf_osize  [RISCV_V_NUM_VALID_OSIZES-1:0];
//Signed Overflow
riscv_v_of_t              signed_of;
//Unsigned Overflow
riscv_v_of_t              unsigned_of;
//Sign
riscv_v_sign_t            sign_result;
//Less than vector
riscv_v_less_than_t       result_less_than_signed;
riscv_v_less_than_t       result_less_than_unsigned;
riscv_v_less_than_t       result_less_than_prev_osize;
riscv_v_less_than_t       result_less_than_osize    [RISCV_V_NUM_VALID_OSIZES-1:0];
riscv_v_less_than_t       result_less_than;
//Select between A and B in is_max or is_min
riscv_v_src_byte_vector_t result_min_max;
//Compare result
riscv_v_num_byte_vector_t result_set_equal_osize [RISCV_V_NUM_VALID_OSIZES-1:0];
riscv_v_num_byte_vector_t result_set_equal_block;
riscv_v_num_byte_vector_t result_set_equal_block_qual;
riscv_v_src_byte_vector_t result_set_equal;
riscv_v_num_byte_vector_t result_set_nequal_osize [RISCV_V_NUM_VALID_OSIZES-1:0];
riscv_v_num_byte_vector_t result_set_nequal_block;
riscv_v_num_byte_vector_t result_set_nequal_block_qual;
riscv_v_src_byte_vector_t result_set_nequal;
riscv_v_num_byte_vector_t result_set_less_osize  [RISCV_V_NUM_VALID_OSIZES-1:0];
riscv_v_num_byte_vector_t result_set_less_block;
riscv_v_num_byte_vector_t result_set_less_block_qual;
riscv_v_src_byte_vector_t result_set_less;
riscv_v_num_byte_vector_t result_set_greater_osize [RISCV_V_NUM_VALID_OSIZES-1:0];
riscv_v_num_byte_vector_t result_set_greater_block;
riscv_v_num_byte_vector_t result_set_greater_block_qual;
riscv_v_src_byte_vector_t result_set_greater;

generate
    //Gate sources
    for (genvar block=0; block < NUM_ADD_BLOCKS; block++) begin  : gen_gate_sources
        assign srca_gated[block] = srca.data.Byte[block] & {BYTE_WIDTH{valid_adder}};
        assign srcb_gated[block] = srcb.data.Byte[block] & {BYTE_WIDTH{valid_adder}};
    end

    //Xor srcb with is_sub
    for (genvar block=0; block < NUM_ADD_BLOCKS; block++) begin : gen_xor_is_sub
        assign srcb_xor_sub[block] = srcb_gated[block] ^ {BYTE_WIDTH{is_sub}};
    end

    //Srca input to BW block
    //Input to Least significant Block is only srca
    assign srca_adder[0] = srca_gated[0];
    for (genvar block=1; block < NUM_ADD_BLOCKS; block++) begin : gen_srca_adder
         always_comb begin
            //Fisrt input is srca
            srca_adder[block] = srca_gated[block] & {BYTE_WIDTH{is_reduct_n | is_greater_osize_vector[$clog2(NUM_ADD_BLOCKS-block)]}};        //Select this source if op is not reduct or osize is greater than
            for (int reduct_input=0; reduct_input <= (($clog2(block+1))-1); reduct_input++) begin
                srca_adder[block] |= result_adder[block-(2**reduct_input)] & {BYTE_WIDTH{(is_reduct & osize_vector[reduct_input])}};
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
    assign sub_carry_in[0]   = is_sub;
    assign use_carry_in[0]   = use_carry & carry_in[0];
    for (genvar block=1; block < NUM_ADD_BLOCKS; block++) begin : gen_merge_cin 
        assign merge_carry_in[block] = cout_adder[block-1] & srca.merge[block-1];
        assign sub_carry_in[block]   = is_sub    & srcb.valid[block] & ~srca.merge[block-1];
        assign use_carry_in[block]   = use_carry & carry_in[block]   & ~srca.merge[block-1];
    end 

    assign cin_adder = (merge_carry_in | sub_carry_in) ^ use_carry_in;

    //Adder blocks
    for (genvar block=0; block<NUM_ADD_BLOCKS; block++) begin : gen_adder
        adder_nbit #(
            .WIDTH(BYTE_WIDTH),
            .RIPPLE_CARRY(1'b1),
	    .BEHAVIORAL(1'b0)
        ) adder (
            .A(srca_adder[block]),
            .B(srcb_adder[block]),
            .cin(cin_adder[block]),
            .S(result_adder[block]),
            .prev_cout(prev_cout_adder[block]),
            .cout(cout_adder[block])
        );
    end

    //Min max result
    for (genvar block=0; block < NUM_ADD_BLOCKS; block++) begin : gen_result_min_max
        assign result_min_max[block] = ((is_max ^ result_less_than[block]) | ~srcb.valid[block]) ? srca_adder[block] : srcb_gated[block];
    end

    //Compare result
    for (genvar block=0;  block < NUM_ADD_BLOCKS; block++) begin :  gen_result_compare 
        //Set Equal
        assign result_set_equal_block_qual[block]   = result_set_equal_block[block] & is_set_equal;
        assign result_set_equal[block]              = {{(BYTE_WIDTH-1){1'b0}}, result_set_equal_block_qual[block]};
        //Set Not equal
        assign result_set_nequal_block_qual[block]  = result_set_nequal_block[block] & is_set_nequal;
        assign result_set_nequal[block]             = {{(BYTE_WIDTH-1){1'b0}}, result_set_nequal_block_qual[block]}; 
        //Set Less than
        assign result_set_less_block_qual[block]    = result_set_less_block[block] & is_set_less;
        assign result_set_less[block]               = {{(BYTE_WIDTH-1){1'b0}}, result_set_less_block_qual[block]};
        //Set greater than
        assign result_set_greater_block_qual[block] = result_set_greater_block[block] & is_set_greater;
        assign result_set_greater[block]            = {{(BYTE_WIDTH-1){1'b0}}, result_set_greater_block_qual[block]};
    end

    //Final result
    for (genvar block=0; block < NUM_ADD_BLOCKS; block++) begin : gen_adder_result
        assign result[block] = result_adder[block]       & {BYTE_WIDTH{is_arithmetic}}
                             | result_min_max[block]     & {BYTE_WIDTH{is_min_max}}
                             | result_set_equal[block]   & {BYTE_WIDTH{is_set_equal}}
                             | result_set_nequal[block]  & {BYTE_WIDTH{is_set_nequal}}
                             | result_set_less[block]    & {BYTE_WIDTH{is_set_less}}
                             | result_set_greater[block] & {BYTE_WIDTH{is_set_greater}};

    end

    //Flags
    for (genvar block=0; block < NUM_ADD_BLOCKS; block++) begin : gen_flags
        assign zf_prev_osize[block]               = (result_adder[block] == 0);
        assign cf[block]                          = (cout_adder[block]);
        assign signed_of[block]                   = (cout_adder[block] ^ prev_cout_adder[block]) & is_signed;
        assign unsigned_of[block]                 = (cout_adder[block] ^ is_sub)                 & ~is_signed;
        assign of[block]                          = signed_of[block] | unsigned_of[block];
        assign sign_result[block]                 = result_adder[block][BYTE_WIDTH-1];
        assign result_less_than_signed[block]     = (sign_result[block] ^ signed_of[block])      & is_signed;
        assign result_less_than_unsigned[block]   = unsigned_of[block];
        assign result_less_than_prev_osize[block] = result_less_than_signed[block] | result_less_than_unsigned[block];
    end

    //Flags per osize
    for (genvar osize_idx=0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin : gen_zf_osize 
        always_comb begin
            zf_osize[osize_idx] = '0;
            if (osize_idx==0) begin
                for (int zf_idx=0; zf_idx < NUM_ADD_BLOCKS; zf_idx++) begin
                    zf_osize[osize_idx][zf_idx] = zf_prev_osize[zf_idx] & osize_vector[osize_idx];
                end
            end else begin
                for (int zf_idx=(2**osize_idx)-1; zf_idx < NUM_ADD_BLOCKS; zf_idx=zf_idx+(2**osize_idx)) begin
                    zf_osize[osize_idx][zf_idx] = (&zf_prev_osize[zf_idx -: (2**osize_idx)]) & osize_vector[osize_idx];
                end
            end
        end
    end

    for (genvar osize_idx=0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin : gen_compare_osize
        always_comb begin
            result_set_equal_osize[osize_idx]   = '0;
            result_set_nequal_osize[osize_idx]  = '0;
            result_set_less_osize[osize_idx]    = '0;
            result_set_greater_osize[osize_idx] = '0;
            for  (int cmp_idx = 0; cmp_idx < NUM_ADD_BLOCKS; cmp_idx = cmp_idx+(2**osize_idx)) begin
                result_set_equal_osize[osize_idx][cmp_idx]   = (&zf_prev_osize[cmp_idx  +: (2**osize_idx)]) & osize_vector[osize_idx];
                result_set_nequal_osize[osize_idx][cmp_idx]  = ~(&zf_prev_osize[cmp_idx +: (2**osize_idx)]) & osize_vector[osize_idx];
                result_set_less_osize[osize_idx][cmp_idx]    = result_less_than_osize[osize_idx][cmp_idx];
                result_set_greater_osize[osize_idx][cmp_idx] = ~(result_set_less_osize[osize_idx][cmp_idx] | result_set_equal_osize[osize_idx][cmp_idx]) & osize_vector[osize_idx];
            end
        end
    end

    for (genvar osize_idx=0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin : gen_result_less_than_osize 
        localparam NUM_BLOCKS_OSIZE = NUM_ADD_BLOCKS/(2**osize_idx);
        localparam NUM_BITS_OSIZE   = 2**osize_idx;
        always_comb begin
            result_less_than_osize[osize_idx] = '0;
            for (int lt_idx=0; lt_idx < NUM_BLOCKS_OSIZE; lt_idx++) begin
                result_less_than_osize[osize_idx][lt_idx*NUM_BITS_OSIZE +: NUM_BITS_OSIZE] = {NUM_BITS_OSIZE{(result_less_than_prev_osize[((lt_idx+1)*NUM_BITS_OSIZE)-1] &  osize_vector[osize_idx])}};
            end
        end
    end

    //Final flags
    always_comb begin
        zf                       = '0;
        result_less_than         = '0;
        result_set_equal_block   = '0;
        result_set_nequal_block  = '0;
        result_set_less_block    = '0;
        result_set_greater_block = '0;
        for (int osize_idx=0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin
            zf                       |= zf_osize[osize_idx];
            result_less_than         |= result_less_than_osize[osize_idx];
            result_set_equal_block   |= result_set_equal_osize[osize_idx];
            result_set_nequal_block  |= result_set_nequal_osize[osize_idx];
            result_set_less_block    |= result_set_less_osize[osize_idx];
            result_set_greater_block |= result_set_greater_osize[osize_idx];
        end
    end

endgenerate

endmodule: riscv_v_adder
