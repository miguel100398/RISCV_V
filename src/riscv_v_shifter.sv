//File: riscv_v_shifter.sv
//Author: Miguel Bucio
//Date: 13/08/23
//Description: RISC-V Vector extension shifter

module riscv_v_shifter
import riscv_v_pkg::*;
(
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
    output riscv_v_src_byte_vector_t  result
);
localparam NUM_SHIFT_BLOCKS     = RISCV_V_NUM_BYTES_DATA;
localparam BLOCK_SELECTOR_WIDTH = $clog2(BYTE_WIDTH);
localparam BYTE_SELECTOR_WIDTH  = $clog2(NUM_SHIFT_BLOCKS);
localparam SELECTOR_WIDTH       = BLOCK_SELECTOR_WIDTH+BYTE_SELECTOR_WIDTH;

typedef logic[SELECTOR_WIDTH-1:0] byte_selector_t;

//Srca A gated with is_shift
riscv_v_src_byte_vector_t srca_gated;
//Srca A swizzle
riscv_v_src_byte_vector_t    srca_swizzle;
riscv_v_src_byte_vector_t    srcb_swizzle;
riscv_v_merge_data_t         srca_merge_swizzle;
riscv_v_merge_data_t         selected_merge;
logic [NUM_SHIFT_BLOCKS-1:0] shifter_arith_vector;
//Select between srca and srca swizzle
riscv_v_src_byte_vector_t srca_shift_selected;
//Muxes to shift blocks
Byte_t mux_shift_block[BYTE_SELECTOR_WIDTH-1:0][NUM_SHIFT_BLOCKS-1:0];
riscv_v_src_byte_vector_t shifter_shift_in;

//Mux Byte selector
byte_selector_t mux_byte_selector[NUM_SHIFT_BLOCKS-1:0];
//Shifter result
riscv_v_src_byte_vector_t shifter_result;
riscv_v_src_byte_vector_t shifter_result_swizzle;

generate
    //Gate srca with is_shift
    for (genvar block=0; block < NUM_SHIFT_BLOCKS; block++) begin : gen_srca_gated
        assign srca_gated[block] = srca.data.Byte[block] & {BYTE_WIDTH{is_shift}};
    end
    //Swizzle srca A
    for (genvar block=0; block < NUM_SHIFT_BLOCKS; block++) begin : gen_srca_swizzle
        assign srca_swizzle[block]       = srca_gated[NUM_SHIFT_BLOCKS-1-block];
        assign srca_merge_swizzle[block] = srca.merge[NUM_SHIFT_BLOCKS-1-block];
        assign srcb_swizzle[block]       = srcb.data.Byte[NUM_SHIFT_BLOCKS-1-block];
    end
    //Select between srca and srca swizzle
    assign srca_shift_selected = (is_left) ? srca_swizzle : srca_gated;

    for (genvar block=0; block < NUM_SHIFT_BLOCKS; block++) begin : gen_byte_selector
        always_comb begin
            if (is_left) begin
                //Most significant block is always srcb[0] | srcb_swizzle[MSB]
                if (block == NUM_SHIFT_BLOCKS-1) begin
                    mux_byte_selector[block] = srcb_swizzle[block][0 +: BYTE_SELECTOR_WIDTH + BLOCK_SELECTOR_WIDTH];
                end else begin
                    //First input, same block
                    mux_byte_selector[block]  = srcb_swizzle[block][0 +: BYTE_SELECTOR_WIDTH + BLOCK_SELECTOR_WIDTH]                  & {SELECTOR_WIDTH{is_less_osize_vector[f_count_trailing_ones_osize(block)]}};
                    //Select Block Zero
                    mux_byte_selector[block] |= srcb_swizzle[NUM_SHIFT_BLOCKS-1][0 +: BYTE_SELECTOR_WIDTH + BLOCK_SELECTOR_WIDTH]     & {SELECTOR_WIDTH{is_greater_osize_vector[$clog2(NUM_SHIFT_BLOCKS-block)]}};
                    //Select osize specific entry
                    for (int osize_idx=0; osize_idx < RISCV_V_NUM_VALID_OSIZES-1; osize_idx++) begin
                        if ((NUM_SHIFT_BLOCKS-1-block) % (2**osize_idx)) begin
                            mux_byte_selector[block] |= srcb_swizzle[block+((NUM_SHIFT_BLOCKS-1-block) % (2**osize_idx))][0 +: BYTE_SELECTOR_WIDTH + BLOCK_SELECTOR_WIDTH] & {SELECTOR_WIDTH{osize_vector[osize_idx]}};
                        end
                    end
                end
            end else begin
                //Block 0 is always srcb[0]
                if (block == 0) begin
                    mux_byte_selector[block]  = srcb.data.Byte[block][0 +: BYTE_SELECTOR_WIDTH + BLOCK_SELECTOR_WIDTH];
                end else begin
                    //First input, same block
                    mux_byte_selector[block]  = srcb.data.Byte[block][0 +: BYTE_SELECTOR_WIDTH + BLOCK_SELECTOR_WIDTH] & {SELECTOR_WIDTH{is_less_osize_vector[f_count_trailing_zeroes_osize(block)]}};
                    //Select Block Zero
                    mux_byte_selector[block] |= srcb.data.Byte[0][0 +: BYTE_SELECTOR_WIDTH + BLOCK_SELECTOR_WIDTH]     & {SELECTOR_WIDTH{is_greater_osize_vector[$clog2(block+1)]}};
                    //Select osize specific entry
                    for (int osize_idx=1; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin
                        if (block % (2**osize_idx)) begin
                            mux_byte_selector[block] |= srcb.data.Byte[block-(block % (2**osize_idx))][0 +: BYTE_SELECTOR_WIDTH + BLOCK_SELECTOR_WIDTH] & {SELECTOR_WIDTH{osize_vector[osize_idx]}};
                        end
                    end
                end
            end
        end
    end

    //Select merge
    for (genvar block=0; block < NUM_SHIFT_BLOCKS-1; block++) begin
        always_comb begin
            if (is_left) begin
                selected_merge[block] = srca_merge_swizzle[block+1];
            end else begin
                selected_merge[block] = srca.merge[block];
            end
        end
    end
    assign selected_merge[NUM_SHIFT_BLOCKS-1] = 1'b0;

    //Multiplexors to shift Bytes
    //First stage
    for (genvar mux_idx=0; mux_idx < NUM_SHIFT_BLOCKS; mux_idx++) begin : gen_mux_first_stage 
        if (mux_idx < (NUM_SHIFT_BLOCKS-1)) begin           //Lower muxes that can get data from previous stage
            always_comb begin
                if (mux_byte_selector[mux_idx][0+BLOCK_SELECTOR_WIDTH] & is_greater_osize_vector[1]) begin      //Osize enables Mux shift
                    if (selected_merge[mux_idx]) begin      //Data can be shifted from previous stage
                        mux_shift_block[0][mux_idx] = srca_shift_selected[mux_idx+1];
                    end else begin           //Data can't be shifted from previous stage, is out of range
                        mux_shift_block[0][mux_idx] = {BYTE_WIDTH{srca_shift_selected[(((mux_idx/2)+1)*2)-1][BYTE_WIDTH-1]}} & {BYTE_WIDTH{is_arith}};      //Set Data to Zero or MSB depending on is_arith
                    end
                end else begin              //Mux is not enabled by osize, don't shift data
                    mux_shift_block[0][mux_idx]     =  srca_shift_selected[mux_idx];
                end
            end
        end else begin
            always_comb begin               //Higher muxes that can't get data from previous stage and should select between sign or zero in case of shift
                if (mux_byte_selector[mux_idx][0+BLOCK_SELECTOR_WIDTH] & is_greater_osize_vector[1]) begin
                    mux_shift_block[0][mux_idx] = {BYTE_WIDTH{srca_shift_selected[(((mux_idx/2)+1)*2)-1][BYTE_WIDTH-1]}} & {BYTE_WIDTH{is_arith}};      //Select between zero or MSB
                end else begin          //Don't shift
                    mux_shift_block[0][mux_idx] = srca_shift_selected[mux_idx];
                end
            end
        end
    end
    
    for (genvar mux_stage=1; mux_stage < BYTE_SELECTOR_WIDTH; mux_stage++) begin : gen_mux_stage 
        for (genvar mux_idx=0; mux_idx < NUM_SHIFT_BLOCKS; mux_idx++) begin : gen_mux_idx 
            if (mux_idx < (NUM_SHIFT_BLOCKS-(2**mux_stage))) begin      //Lower muxes that can get data from previous stage
                always_comb begin
                    if (mux_byte_selector[mux_idx][mux_stage+BLOCK_SELECTOR_WIDTH] & is_greater_osize_vector[mux_stage+1]) begin        //Osize enables Mux shift
                        if (&selected_merge[mux_idx +: (2**mux_stage)]) begin       //Data can be shifted from previous stage
                            mux_shift_block[mux_stage][mux_idx] = mux_shift_block[mux_stage-1][mux_idx+(2**mux_stage)];
                        end else begin                                              //Data can't be shifted from previous stage, is out of range
                             mux_shift_block[mux_stage][mux_idx] = {BYTE_WIDTH{mux_shift_block[mux_stage-1][(((mux_idx/(2**mux_stage))+1)*(2**mux_stage))-1][BYTE_WIDTH-1]}} & {BYTE_WIDTH{is_arith}};  //Set Data to Zero or MSB depending on is_arith
                        end
                    end else begin                                                  //Mux is not enabled by osize, don't shift data
                        mux_shift_block[mux_stage][mux_idx] = mux_shift_block[mux_stage-1][mux_idx];
                    end
                end
            end else begin              //Higher muxes that can't get data from previous stage and should select between sign or zero in case of shift
                always_comb begin
                    if (mux_byte_selector[mux_idx][mux_stage+BLOCK_SELECTOR_WIDTH] & is_greater_osize_vector[mux_stage+1]) begin        //Shift Mux outside of range
                        mux_shift_block[mux_stage][mux_idx] = {BYTE_WIDTH{mux_shift_block[mux_stage-1][(((mux_idx/(2**mux_stage))+1)*(2**mux_stage))-1][BYTE_WIDTH-1]}} & {BYTE_WIDTH{is_arith}};   //Select between zero or MSB
                    end else begin      //Don't shift
                        mux_shift_block[mux_stage][mux_idx] = mux_shift_block[mux_stage-1][mux_idx];
                    end
                end
            end
        end
    end

    //Select shift in
    for (genvar block=0; block < NUM_SHIFT_BLOCKS-1; block++) begin : gen_shift_in 
        assign shifter_shift_in[block] = mux_shift_block[BYTE_SELECTOR_WIDTH-1][block+1] & {BYTE_WIDTH{selected_merge[block]}};
    end
    assign shifter_shift_in[NUM_SHIFT_BLOCKS-1] = {BYTE_WIDTH{1'b0}};

    //Shifters
    for (genvar block=0; block < NUM_SHIFT_BLOCKS; block++) begin : gen_shifters
    
        assign shifter_arith_vector[block] = ~selected_merge[block] & is_arith;

        shifter#(
            .WIDTH(BYTE_WIDTH)
        ) byte_shifter(
            .src(mux_shift_block[BYTE_SELECTOR_WIDTH-1][block]),
            .shift(mux_byte_selector[block][0 +: BLOCK_SELECTOR_WIDTH]),
            .shift_left(is_left),
            .shift_arith(shifter_arith_vector[block]),
            .shift_in(shifter_shift_in[block]),
            .result(shifter_result[block])
        );
        
    end

    //Swizzle shifter result
    for (genvar block=0; block<NUM_SHIFT_BLOCKS; block++) begin : swizzle_shifter_result
        assign shifter_result_swizzle[block] = shifter_result[NUM_SHIFT_BLOCKS-1-block];
    end

    //Final result
    for (genvar block=0; block<NUM_SHIFT_BLOCKS; block++) begin : gen_shift_result
        assign result[block] = (is_left) ? shifter_result_swizzle[block] : shifter_result[block];
    end

endgenerate


endmodule: riscv_v_shifter