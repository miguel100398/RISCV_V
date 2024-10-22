//File: mul_vedic_test_latency
//Author: Miguel Bucio
//Date: 20/09/23
//Description: N Bit multiplier behavioral
`timescale 1ns/1ps

module mul_vedic_test_latency
import riscv_pkg::*, riscv_v_pkg::*;
#(
    parameter WIDTH = 8,
    parameter vedic_mul_idx_t MUL_IDX               = VEDIC_LA_LB,
    parameter                 MIN_MUL_LEVEL         = $clog2(16),
    parameter bit             GET_MID_PREV_RESULTS  = 1'b0, 
    localparam                RESULT_WIDTH          = (2*WIDTH),
    localparam                MUL_LEVEL             = $clog2(WIDTH),
    localparam                NUM_PREV_RESULTS      = f_vedic_mul_get_prev_results(MUL_LEVEL, MIN_MUL_LEVEL, MUL_IDX, GET_MID_PREV_RESULTS)
)(
    input  logic clk,
    input  logic[WIDTH-1:0] srca_in,
    input  logic[WIDTH-1:0] srcb_in,
    output logic[RESULT_WIDTH-1:0] result,
    output logic [WIDTH-1:0]  prev_result[NUM_PREV_RESULTS-1:0]
);


    typedef logic [WIDTH-1:0] data_t;
    typedef logic [RESULT_WIDTH-1:0] result_t;

    data_t srca;
    data_t srcb;
    result_t mul_result;
    logic [WIDTH-1:0]  mul_prev_result[NUM_PREV_RESULTS-1:0];

    always_ff @(posedge clk) begin
        srca <= srca_in;
        srcb <= srcb_in;
    end

    vedic_mul_unsigned #(
        .WIDTH(WIDTH),
        .MUL_IDX(MUL_IDX),
        .MIN_MUL_LEVEL(MIN_MUL_LEVEL),
        .GET_MID_PREV_RESULTS(GET_MID_PREV_RESULTS)
    ) vedic_mul(
        .A(srca),
        .B(srcb),
        .Z(mul_result),
        .prev_result(mul_prev_result)
    );

    always_ff @(posedge clk) begin
        result <= mul_result;
        prev_result <= mul_prev_result;
    end

endmodule: mul_vedic_test_latency