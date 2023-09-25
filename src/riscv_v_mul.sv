//File: riscv_v_mul
//Author: Miguel Bucio
//Date: 20/09/23
//Description: riscv-v Vector extension multiplier (Using vedic multiplier)

module riscv_v_mul
import riscv_v_pkg::*;
(
    input  logic                        is_mul,
    input  logic                        is_high,
    input  logic                        is_signed,
    input  osize_vector_t               osize_vector,
    input  riscv_v_alu_data_t           srca,
    input  riscv_v_alu_data_t           srcb,
    output riscv_v_src_byte_vector_t    result
);

localparam NUM_MUL_BLOCKS   = RISCV_V_NUM_BYTES_DATA;
localparam MAX_MUL_LEVEL    = $clog2(RISCV_V_DATA_WIDTH);
localparam MIN_MUL_LEVEL    = $clog2(16);
localparam NUM_PREV_RESULTS = f_vedic_mul_get_prev_results(MAX_MUL_LEVEL, MIN_MUL_LEVEL, VEDIC_LA_LB, 1'b0);
localparam MUL_RESULT_WIDTH = (2*RISCV_V_DATA_WIDTH);


//srcA gated
riscv_v_src_byte_vector_t srca_gated;
//Sources to multiplier
riscv_v_src_byte_vector_t srca_mul;
riscv_v_src_byte_vector_t srcb_mul;
riscv_v_merge_data_t      merge;


//Previous results
logic[RISCV_V_DATA_WIDTH-1:0] prev_results[NUM_PREV_RESULTS-1:0];     //Level0 -> 1bit     Level4-> 8bits    MAX_LEVEL ->  RISCV_V_DATA_WIDTH/2

//Osizes results
logic[MUL_RESULT_WIDTH-1:0] mul_result_osize_prev_comp [RISCV_V_NUM_VALID_OSIZES-1:0];
logic[MUL_RESULT_WIDTH-1:0] mul_result_osize           [RISCV_V_NUM_VALID_OSIZES-1:0];

//Select between low and high part of osizes result
riscv_v_src_byte_vector_t mul_result_osize_sel_lh [RISCV_V_NUM_VALID_OSIZES-1:0];

//Twos complement control
riscv_v_complement_t srcA_comp;
riscv_v_complement_t srcB_comp;
riscv_v_complement_t result_comp;

riscv_v_sign_t srcA_sign_osize [RISCV_V_NUM_VALID_OSIZES-1:0];
riscv_v_sign_t srcA_sign;

riscv_v_sign_t srcB_sign_osize [RISCV_V_NUM_VALID_OSIZES-1:0];
riscv_v_sign_t srcB_sign;

//Multiplier result before twos complement
logic[MUL_RESULT_WIDTH-1:0] mul_result_prev_comp;
logic[MUL_RESULT_WIDTH-1:0] mul_result;

//Get sign of sources

generate
    for (genvar osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin : gen_sign_src
        localparam OSIZE_WIDTH   = (BYTE_WIDTH*(2**osize_idx));
        localparam JUMP_SIZE     = OSIZE_WIDTH/BYTE_WIDTH;
        localparam NUM_BLOCK     = (RISCV_V_DATA_WIDTH/OSIZE_WIDTH);
        always_comb begin
            srcA_sign_osize[osize_idx]    = '0;
            srcB_sign_osize[osize_idx]    = '0;
            for (int sign_idx = 0; sign_idx < NUM_BLOCK; sign_idx++) begin
                srcA_sign_osize[osize_idx][sign_idx*JUMP_SIZE] = srca.data[(sign_idx*OSIZE_WIDTH)+(OSIZE_WIDTH-1)];
                srcB_sign_osize[osize_idx][sign_idx*JUMP_SIZE] = srcb.data[(sign_idx*OSIZE_WIDTH)+(OSIZE_WIDTH-1)];
            end
        end
    end
endgenerate

always_comb begin
    srcA_sign = '0;
    srcB_sign = '0;
    for (int osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin
        srcA_sign |= srcA_sign_osize[osize_idx] & {RISCV_V_NUM_BYTES_DATA{osize_vector[osize_idx]}};
        srcB_sign |= srcB_sign_osize[osize_idx] & {RISCV_V_NUM_BYTES_DATA{osize_vector[osize_idx]}};
    end
end

generate
    for (genvar comp_idx = 0; comp_idx < RISCV_V_NUM_BYTES_DATA; comp_idx++) begin : gen_comp_src 
        //Perform twos complement on sources if is signed and source is negative
        assign srcA_comp[comp_idx]   = is_signed & srcA_sign[comp_idx];
        assign srcB_comp[comp_idx]   = is_signed & srcB_sign[comp_idx];
        //Perform twos complement on result if signed and sources are of different sign
        assign result_comp[comp_idx] = srcA_comp[comp_idx] ^ srcB_comp[comp_idx];
    end
endgenerate

generate
    //Gate source A
    for (genvar block=0; block < NUM_MUL_BLOCKS; block++) begin : gen_gate_srcA
        assign srca_gated[block] = srca.data.Byte[block] & {BYTE_WIDTH{is_mul}};
    end

    //Sources to mult
    for (genvar block=0; block < NUM_MUL_BLOCKS; block++) begin : gen_mul_srcs
        assign merge[block]    = srcb.merge[block];
    end

endgenerate

//Twos complement
riscv_v_twos_comp_sel #(
    .BLOCK_WIDTH(BYTE_WIDTH)
)twos_comp_srcA(
    .in(srca_gated),
    .complement(srcA_comp),
    .osize_vector(osize_vector),
    .merge(merge),
    .out(srca_mul)
);

riscv_v_twos_comp_sel #(
    .BLOCK_WIDTH(BYTE_WIDTH)
)twos_comp_srcB(
    .in(srcb.data),
    .complement(srcB_comp),
    .osize_vector(osize_vector),
    .merge(merge),
    .out(srcb_mul)
);

//Multiplier
vedic_mul_unsigned#(
    .WIDTH(RISCV_V_DATA_WIDTH),
    .MUL_IDX(VEDIC_LA_LB),
    .MIN_MUL_LEVEL(MIN_MUL_LEVEL),
    .GET_MID_PREV_RESULTS(1'b0)
) vedic_mul(
    .A(srca_mul),
    .B(srcb_mul),
    .Z(mul_result_osize_prev_comp[RISCV_V_NUM_VALID_OSIZES-1]),
    .prev_result(prev_results)
);

generate
    for (genvar osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES-1; osize_idx++) begin : gen_select_prev_result_osize
        localparam OSIZE_WIDTH    = (BYTE_WIDTH*(2**osize_idx));
        localparam RESULT_WIDTH   = (2*OSIZE_WIDTH);
        localparam NUM_RESULTS    = (RISCV_V_DATA_WIDTH/OSIZE_WIDTH);
        localparam START_PREV_IDX = f_vedic_mul_start_prev_idx(osize_idx);
        for (genvar result_idx = 0; result_idx < NUM_RESULTS; result_idx++) begin : gen_select_prev_result_result
            assign mul_result_osize_prev_comp[osize_idx][(result_idx*RESULT_WIDTH) +: (RESULT_WIDTH)] = prev_results[START_PREV_IDX + result_idx][0 +: RESULT_WIDTH];
        end
    end
endgenerate

//Get result depending on osize
generate
    always_comb begin
        mul_result_prev_comp = '0;
        for (int osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin
            mul_result_prev_comp |= mul_result_osize_prev_comp[osize_idx] & {MUL_RESULT_WIDTH{osize_vector[osize_idx]}};
        end
    end
endgenerate

riscv_v_twos_comp_sel #(
    .BLOCK_WIDTH(WORD_WIDTH)
)twos_comp_result(
    .in(mul_result_prev_comp),
    .complement(result_comp),
    .osize_vector(osize_vector),
    .merge(merge),
    .out(mul_result)
);

//Split mul_result per osize
generate
    for (genvar osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin : gen_select_result_osize
        localparam OSIZE_WIDTH    = (BYTE_WIDTH*(2**osize_idx));
        localparam RESULT_WIDTH   = (2*OSIZE_WIDTH);
        localparam NUM_RESULTS    = (RISCV_V_DATA_WIDTH/OSIZE_WIDTH);
        localparam JUMP_SIZE      = (BYTE_WIDTH/OSIZE_WIDTH);
        for (genvar result_idx = 0; result_idx < NUM_RESULTS; result_idx++) begin : gen_select_result
            assign mul_result_osize[osize_idx] = mul_result;
        end
    end
endgenerate

//Select between low and high part of osizes result
generate
    for (genvar osize_idx=0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin : gen_select_hl_osize 
        localparam OSIZE_WIDTH   = (BYTE_WIDTH*(2**osize_idx));
        localparam RESULT_WIDTH  = (2*OSIZE_WIDTH);
        localparam NUM_RESULTS   = (RISCV_V_DATA_WIDTH/OSIZE_WIDTH);
        localparam NUM_BYTES     = (OSIZE_WIDTH/BYTE_WIDTH);

        for (genvar result_idx=0; result_idx < NUM_RESULTS; result_idx++) begin : gen_select_hl_result 
            assign mul_result_osize_sel_lh[osize_idx][result_idx*NUM_BYTES +: NUM_BYTES] = (is_high) ? mul_result_osize[osize_idx][((result_idx+1)*RESULT_WIDTH)-1 -: OSIZE_WIDTH] : mul_result_osize[osize_idx][(result_idx*RESULT_WIDTH) +: OSIZE_WIDTH];
        end

    end

endgenerate

//Multiplex final result depending on osize
always_comb begin
    result = '0;
    for (int osize_idx=0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin
        result |= mul_result_osize_sel_lh[osize_idx] & {RISCV_V_DATA_WIDTH{osize_vector[osize_idx]}};
    end
end


endmodule: riscv_v_mul