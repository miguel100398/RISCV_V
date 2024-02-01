//File: vedic_mul
//Author: Miguel Bucio
//Date: 20/09/23
//Description: Signed/Unsigned vedic multiplier

module vedic_mul
import riscv_v_pkg::*, riscv_pkg::*;
#(
    parameter                   WIDTH                   = 2,
    parameter vedic_mul_idx_t   MUL_IDX                 = VEDIC_LA_LB,
    parameter                   MIN_MUL_LEVEL           = $clog2(16),
    parameter bit               GET_MID_PREV_RESULTS    = 1'b0, 
    localparam                  RESULT_WIDTH            = (2*WIDTH),
    localparam                  MUL_LEVEL               = $clog2(WIDTH),
    localparam                  NUM_PREV_RESULTS        = f_vedic_mul_get_prev_results(MUL_LEVEL, MIN_MUL_LEVEL, MUL_IDX, GET_MID_PREV_RESULTS)
) (
    input  logic [WIDTH-1:0]                A,
    input  logic [WIDTH-1:0]                B,
    input  logic                            is_signed,
    input  osize_vector_t                   osize_vector,
    input  riscv_v_merge_data_t             merge,
    output logic [RESULT_WIDTH-1:0]         Z,
    //Previous results
    output logic [WIDTH-1:0]        prev_result[NUM_PREV_RESULTS-1:0]
);
 
//Sources after twos complement
riscv_v_src_byte_vector_t mul_srcA;
riscv_v_src_byte_vector_t mul_srcB;

//Twos complement control
riscv_v_complement_t srcA_comp;
riscv_v_complement_t srcB_comp;
riscv_v_complement_t result_comp;

riscv_v_sign_t srcA_sign_osize [RISCV_V_NUM_VALID_OSIZES-1:0];
riscv_v_sign_t srcA_sign;

riscv_v_sign_t srcB_sign_osize [RISCV_V_NUM_VALID_OSIZES-1:0];
riscv_v_sign_t srcB_sign;

//Multiplier result before twos complement
logic[RESULT_WIDTH-1:0] mul_result;

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
                srcA_sign_osize[osize_idx][sign_idx*JUMP_SIZE] = A[(sign_idx*OSIZE_WIDTH)+(OSIZE_WIDTH-1)];
                srcB_sign_osize[osize_idx][sign_idx*JUMP_SIZE] = B[(sign_idx*OSIZE_WIDTH)+(OSIZE_WIDTH-1)];
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


//Twos complement
riscv_v_twos_comp_sel #(
    .BLOCK_WIDTH(BYTE_WIDTH)
)twos_comp_srcA(
    .in(A),
    .complement(srcA_comp),
    .osize_vector(osize_vector),
    .merge(merge),
    .out(mul_srcA)
);

riscv_v_twos_comp_sel #(
    .BLOCK_WIDTH(BYTE_WIDTH)
)twos_comp_srcB(
    .in(B),
    .complement(srcB_comp),
    .osize_vector(osize_vector),
    .merge(merge),
    .out(mul_srcB)
);

//Unsigned vedic multiplier
vedic_mul_unsigned#(
    .WIDTH(WIDTH),
    .MUL_IDX(MUL_IDX),
    .MIN_MUL_LEVEL(MIN_MUL_LEVEL),
    .GET_MID_PREV_RESULTS(GET_MID_PREV_RESULTS)
) vedic_mul_unsigned(
    .A(mul_srcA),
    .B(mul_srcB),
    .Z(mul_result),
    .prev_result(prev_result)
);

riscv_v_twos_comp_sel #(
    .BLOCK_WIDTH(WORD_WIDTH)
)twos_comp_result(
    .in(mul_result),
    .complement(result_comp),
    .osize_vector(osize_vector),
    .merge(merge),
    .out(Z)
);


//Check Parameter
`ifndef SYNTHESIS
    initial begin
        if (WIDTH%2) begin
            $fatal("WIDTH should be a power of 2, WIDTH:%0d", WIDTH);
        end
    end
`endif //SYNTHESIS

endmodule: vedic_mul
