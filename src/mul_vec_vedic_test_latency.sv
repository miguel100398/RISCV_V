//File: mul_vec_vedic_test_latency
//Author: Miguel Bucio
//Date: 20/09/23
//Description: N Bit multiplier behavioral
`timescale 1ns/1ps

module mul_vec_vedic_test_latency
import riscv_pkg::*, riscv_v_pkg::*;
(
    input  logic clk,
    input  riscv_v_data_t srca,
    input  riscv_v_data_t srcb,
    input  riscv_v_osize_e osize,
    output riscv_v_data_t result [1:0]
);

localparam NUM_MUL_BLOCKS   = RISCV_V_NUM_BYTES_DATA;
localparam MAX_MUL_LEVEL    = $clog2(RISCV_V_DATA_WIDTH);
localparam MIN_MUL_LEVEL    = $clog2(16);
localparam NUM_PREV_RESULTS = f_vedic_mul_get_prev_results(MAX_MUL_LEVEL, MIN_MUL_LEVEL, VEDIC_LA_LB, 1'b0);
localparam MUL_RESULT_WIDTH = (2*RISCV_V_DATA_WIDTH);


logic[RISCV_V_DATA_WIDTH-1:0] prev_results[NUM_PREV_RESULTS-1:0];     //Level0 -> 1bit     Level4-> 8bits    MAX_LEVEL ->  RISCV_V_DATA_WIDTH/2
logic[MUL_RESULT_WIDTH-1:0]   mul_result_osize           [RISCV_V_NUM_VALID_OSIZES-1:0];


mul_vedic_test_latency#(
    .WIDTH(RISCV_V_DATA_WIDTH),
    .MUL_IDX(VEDIC_LA_LB),
    .MIN_MUL_LEVEL(MIN_MUL_LEVEL),
    .GET_MID_PREV_RESULTS(1'b0)
) vedic_mul(
    .clk(clk),
    .srca_in(srca),
    .srcb_in(srcb),
    .result(mul_result_osize[RISCV_V_NUM_VALID_OSIZES-1]),
    .prev_result(prev_results)
);

generate
    for (genvar osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES-1; osize_idx++) begin : gen_select_prev_result_osize
        localparam OSIZE_WIDTH    = (BYTE_WIDTH*(2**osize_idx));
        localparam RESULT_WIDTH   = (2*OSIZE_WIDTH);
        localparam NUM_RESULTS    = (RISCV_V_DATA_WIDTH/OSIZE_WIDTH);
        localparam START_PREV_IDX = f_vedic_mul_start_prev_idx(osize_idx);
        for (genvar result_idx = 0; result_idx < NUM_RESULTS; result_idx++) begin : gen_select_prev_result_result
            assign mul_result_osize[osize_idx][(result_idx*RESULT_WIDTH) +: (RESULT_WIDTH)] = prev_results[START_PREV_IDX + result_idx][0 +: RESULT_WIDTH];
        end
    end
endgenerate

always_comb begin
    case(osize)
        OSIZE_8    : {result[1], result[0]} = mul_result_osize[0];
        OSIZE_16   : {result[1], result[0]} = mul_result_osize[1];
        OSIZE_32   : {result[1], result[0]} = mul_result_osize[2];
        OSIZE_64   : {result[1], result[0]} = mul_result_osize[3];
        OSIZE_128  : {result[1], result[0]} = mul_result_osize[4];
        default : {result[1], result[0]} = 'x;
    endcase
end

endmodule: mul_vec_vedic_test_latency