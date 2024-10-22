//File: mul_vec_array_test_latency
//Author: Miguel Bucio
//Date: 20/09/23
//Description: N Bit multiplier behavioral
`timescale 1ns/1ps

module mul_vec_array_test_latency
import riscv_pkg::*, riscv_v_pkg::*;
(
    input  logic clk,
    input  riscv_v_data_t srca,
    input  riscv_v_data_t srcb,
    input  riscv_v_osize_e osize,
    output riscv_v_data_t result [1:0]
);

logic[255:0] mul8_result;
logic[255:0] mul16_result;
logic[255:0] mul32_result;
logic[255:0] mul64_result;
logic[255:0] mul128_result;

generate
    
    for (genvar idx = 0; idx < 16; idx++)begin : gen_mul8
        mul_array_test_latency#(
            .WIDTH(8)
        ) mul8(
            .clk(clk),
            .srca_in(srca[idx*8 +: 8]),
            .srcb_in(srcb[idx*8 +: 8]),
            .result(mul8_result[idx*16 +: 16])
        );
    end 

    for (genvar idx = 0; idx < 8; idx++) begin : gen_mul16
        mul_array_test_latency#(
            .WIDTH(16)
        ) mul8(
            .clk(clk),
            .srca_in(srca[idx*16 +: 16]),
            .srcb_in(srcb[idx*16 +: 16]),
            .result(mul16_result[idx*32 +: 32])
        );
    end 

    for (genvar idx = 0; idx < 4; idx++) begin : gen_mul32
        mul_array_test_latency#(
            .WIDTH(32)
        ) mul8(
            .clk(clk),
            .srca_in(srca[idx*32 +: 32]),
            .srcb_in(srcb[idx*32 +: 32]),
            .result(mul32_result[idx*64 +: 64])
        );
    end 

    for (genvar idx = 0; idx < 2; idx++) begin : gen_mul64
        mul_array_test_latency#(
            .WIDTH(64)
        ) mul8(
            .clk(clk),
            .srca_in(srca[idx*64 +: 64]),
            .srcb_in(srcb[idx*64 +: 64]),
            .result(mul64_result[idx*128 +: 128])
        );
    end 

    for (genvar idx = 0; idx < 1; idx++) begin : gen_mul128
        mul_array_test_latency#(
            .WIDTH(128)
        ) mul8(
            .clk(clk),
            .srca_in(srca[idx*128 +: 128]),
            .srcb_in(srcb[idx*128 +: 128]),
            .result(mul128_result[idx*256 +: 256])
        );
    end 

endgenerate

always_comb begin
    case(osize)
        OSIZE_8 : {result[1], result[0]} = mul8_result;
        OSIZE_16 : {result[1], result[0]}  = mul16_result;
        OSIZE_32 : {result[1], result[0]}  = mul32_result;
        OSIZE_64 : {result[1], result[0]}  = mul64_result;
        OSIZE_128 : {result[1], result[0]}  = mul128_result;
        default : result = '{default:'x};
    endcase
end

endmodule: mul_vec_array_test_latency