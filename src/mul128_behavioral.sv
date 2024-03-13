//File: mul128_behavioral
//Author: Miguel Bucio
//Date: 20/09/23
//Description: 128 Bit multiplier behavioral
`timescale 1ns/1ps

module mul128_behavioral(
    input  logic [127:0] srca,
    input  logic [127:0] srcb,
    input  logic         is_mul,
    input  logic         is_high,
    input  logic         is_signed,
    output logic [127:0] result
);

mul_array#(
    .WIDTH(128)
) mul(
    .srca(srca),
    .srcb(srcb),
    .is_mul(is_mul),
    .is_high(is_high),
    .is_signed(is_signed),
    .result(result)
);

endmodule: mul128_behavioral