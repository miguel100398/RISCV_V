//File: riscv_v_shifter.sv
//Author: Miguel Bucio
//Date: 13/08/23
//Description: RISC-V Vector extension shifter
`timescale 1ns/1ps

module riscv_v_shifter
import riscv_v_pkg::*, riscv_pkg::*;
(
    input  logic              is_shift,
    input  logic              is_left,
    input  logic              is_arith,
    input  osize_vector_t     osize_vector,
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
typedef byte_selector_t byte_selector_vector_t [NUM_SHIFT_BLOCKS-1:0];

//srcb A gated with is_shift
riscv_v_src_byte_vector_t srca_gated;
riscv_v_src_byte_vector_t srcb_gated;
//srcb A swizzle
riscv_v_src_byte_vector_t    srcb_swizzle;
riscv_v_merge_data_t         srcb_merge_swizzle;
riscv_v_merge_data_t         selected_merge;
logic [NUM_SHIFT_BLOCKS-1:0] shifter_arith_vector;
//Select between srcb and srcb swizzle
riscv_v_src_byte_vector_t srcb_shift_selected;
//Muxes to shift blocks
Byte_t mux_shift_block[BYTE_SELECTOR_WIDTH-1:0][NUM_SHIFT_BLOCKS-1:0];
riscv_v_src_byte_vector_t shifter_shift_in;

//Shifter result
riscv_v_src_byte_vector_t shifter_result;
riscv_v_src_byte_vector_t shifter_result_swizzle;

//Shift cnt
//Shift count with data replicated
byte_selector_vector_t shift_cnt_osize [RISCV_V_NUM_VALID_OSIZES-1:0];
//Shihft count qualified with osize
byte_selector_vector_t shift_cnt_osize_qual [RISCV_V_NUM_VALID_OSIZES-1:0];
//Shift count qualified selected
byte_selector_vector_t shift_cnt;
//Shift count selected swizzled
byte_selector_vector_t shift_cnt_swizzle;
//Shhift count selected between qualified and swizzled
byte_selector_vector_t shift_cnt_sel;

//Oisize selector mask
byte_selector_t           selector_mask;

generate

    //Generate selector mask
    assign selector_mask[BLOCK_SELECTOR_WIDTH-1 : 0] = {BLOCK_SELECTOR_WIDTH{1'b1}};    //Bits that affect to Byte shifter are always enabled
    for (genvar block_idx = BLOCK_SELECTOR_WIDTH; block_idx < SELECTOR_WIDTH; block_idx++) begin
        assign selector_mask[block_idx] = is_greater_osize_vector[(block_idx - BLOCK_SELECTOR_WIDTH + 1)];
    end

    //Gate srcb with is_shift
    for (genvar block=0; block < NUM_SHIFT_BLOCKS; block++) begin : gen_srcb_gated
        assign srcb_gated[block] = srcb.data.Byte[block] & {BYTE_WIDTH{is_shift}};
        assign srca_gated[block] = srca.data.Byte[block] & {BYTE_WIDTH{is_shift}};
    end
    //Swizzle srcb A
    for (genvar block=0; block < NUM_SHIFT_BLOCKS; block++) begin : gen_srcb_swizzle
        assign srcb_swizzle[block]       = srcb_gated[NUM_SHIFT_BLOCKS-1-block];
        assign srcb_merge_swizzle[block] = srcb.merge[NUM_SHIFT_BLOCKS-1-block];
        assign shift_cnt_swizzle[block]  = shift_cnt[NUM_SHIFT_BLOCKS-1-block];
    end
    //Select between srcb and srcb swizzle
    assign srcb_shift_selected = (is_left) ? srcb_swizzle : srcb_gated;

    //Generate shift count per osize
    for (genvar osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin : gen_shift_cnt_osize
        localparam OSIZE_WIDTH          = (8 * (2**osize_idx));
        localparam NUM_BLOCKS_OSIZE     = (RISCV_V_DATA_WIDTH / OSIZE_WIDTH);
        localparam NUM_REPLICATE_BLOCKS = (NUM_SHIFT_BLOCKS / NUM_BLOCKS_OSIZE);

        for (genvar block_idx = 0; block_idx < NUM_BLOCKS_OSIZE; block_idx++) begin : gen_shift_cnt_block

            byte_selector_t srca_byte_sel;
            //Get Byte to be replicated
            assign srca_byte_sel = (srca_gated[(block_idx*NUM_REPLICATE_BLOCKS)][0 +: SELECTOR_WIDTH] & selector_mask);
            //Replicate Data to shift_cnt_osize
            assign shift_cnt_osize[osize_idx][(block_idx*NUM_REPLICATE_BLOCKS) +: NUM_REPLICATE_BLOCKS] = ('{NUM_REPLICATE_BLOCKS{srca_byte_sel}});
        end

        for (genvar block_idx = 0; block_idx < NUM_SHIFT_BLOCKS; block_idx++) begin : gen_shift_cnt_qual
            //Qualify with osize to get shift_cnt
            assign shift_cnt_osize_qual[osize_idx][block_idx] = shift_cnt_osize[osize_idx][block_idx] & {SELECTOR_WIDTH{osize_vector[osize_idx]}};
        end
    end

    always_comb begin
        shift_cnt = '{default:'0};
        for (int osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin
            for (int block_idx = 0; block_idx < NUM_SHIFT_BLOCKS; block_idx++) begin
                shift_cnt[block_idx] |= shift_cnt_osize_qual[osize_idx][block_idx];
            end
        end
    end

    //Select between shift_cnt and shift_cnt swizzle
    assign shift_cnt_sel = (is_left) ? shift_cnt_swizzle : shift_cnt;

    //Select merge
    for (genvar block=0; block < NUM_SHIFT_BLOCKS-1; block++) begin : gen_selected_merge
        assign selected_merge[block] = (is_left) ? srcb_merge_swizzle[block+1] : srcb.merge[block];
    end
    assign selected_merge[NUM_SHIFT_BLOCKS-1] = 1'b0;

    //Multiplexors to shift Bytes (Barrel Shifter)
    //First stage
    for (genvar mux_idx=0; mux_idx < NUM_SHIFT_BLOCKS; mux_idx++) begin : gen_mux_first_stage 
        if (mux_idx < (NUM_SHIFT_BLOCKS-1)) begin           //Lower muxes that can get data from previous stage
            always_comb begin
                if (shift_cnt_sel[mux_idx][0+BLOCK_SELECTOR_WIDTH]) begin      //Osize enables Mux shift
                    if (selected_merge[mux_idx]) begin      //Data can be shifted from previous stage
                        mux_shift_block[0][mux_idx] = srcb_shift_selected[mux_idx+1];
                    end else begin           //Data can't be shifted from previous stage, is out of range
                        mux_shift_block[0][mux_idx] = {BYTE_WIDTH{srcb_shift_selected[(((mux_idx/2)+1)*2)-1][BYTE_WIDTH-1]}} & {BYTE_WIDTH{is_arith}};      //Set Data to Zero or MSB depending on is_arith
                    end
                end else begin              //Mux is not enabled by osize, don't shift data
                    mux_shift_block[0][mux_idx]     =  srcb_shift_selected[mux_idx];
                end
            end
        end else begin
            always_comb begin               //Higher muxes that can't get data from previous stage and should select between sign or zero in case of shift
                if (shift_cnt_sel[mux_idx][0+BLOCK_SELECTOR_WIDTH]) begin
                    mux_shift_block[0][mux_idx] = {BYTE_WIDTH{srcb_shift_selected[(((mux_idx/2)+1)*2)-1][BYTE_WIDTH-1]}} & {BYTE_WIDTH{is_arith}};      //Select between zero or MSB
                end else begin          //Don't shift
                    mux_shift_block[0][mux_idx] = srcb_shift_selected[mux_idx];
                end
            end
        end
    end
    
    for (genvar mux_stage=1; mux_stage < BYTE_SELECTOR_WIDTH; mux_stage++) begin : gen_mux_stage 
        for (genvar mux_idx=0; mux_idx < NUM_SHIFT_BLOCKS; mux_idx++) begin : gen_mux_idx 
            if (mux_idx < (NUM_SHIFT_BLOCKS-(2**mux_stage))) begin      //Lower muxes that can get data from previous stage
                always_comb begin
                    if (shift_cnt_sel[mux_idx][mux_stage+BLOCK_SELECTOR_WIDTH]) begin        //Osize enables Mux shift
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
                    if (shift_cnt_sel[mux_idx][mux_stage+BLOCK_SELECTOR_WIDTH]) begin        //Shift Mux outside of range
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
            .shift(shift_cnt_sel[block][0 +: BLOCK_SELECTOR_WIDTH]),
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