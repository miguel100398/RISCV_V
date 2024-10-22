//File: mul_array_test_latency
//Author: Miguel Bucio
//Date: 20/09/23
//Description: N Bit multiplier behavioral
`timescale 1ns/1ps

module mul_array_test_latency
import riscv_pkg::*, riscv_v_pkg::*;
#(
    parameter WIDTH = 128 
) (
    input  logic                 clk,
    input  logic [WIDTH-1:0]     srca_in,
    input  logic [WIDTH-1:0]     srcb_in,
    output logic [(2*WIDTH)-1:0] result
);

localparam RESULT_WIDTH = 2*WIDTH;

typedef logic [WIDTH-1:0] data_t;
typedef logic [RESULT_WIDTH-1:0] result_t;

data_t srca;
data_t srcb;



result_t mul_result;

data_t partial_product_and [WIDTH-1:0];
data_t partial_product_add [WIDTH-2:0];
logic  carry_out_add [WIDTH-2:0];


always_ff @(posedge clk) begin
    srca <= srca_in;
    srcb <= srcb_in;
end


generate
    //Partial products and
    for (genvar i=0; i < WIDTH; i++) begin : gen_partial_and
        assign partial_product_and[i] = srca & {WIDTH{srcb[i]}};
    end
    //Adders
    assign {carry_out_add[0], partial_product_add[0]} = partial_product_and[0] + partial_product_and[1];

    for (genvar i=1; i < WIDTH-1; i++) begin : gen_partial_add
        assign {carry_out_add[i], partial_product_add[i]} = partial_product_and[i+1] + {carry_out_add[i-1], partial_product_add[i-1][WIDTH-1:1]};
    end

    //Result
    assign mul_result[0] = partial_product_and[0][0];
    for (genvar i=1; i < WIDTH-1; i++) begin : gen_result
        assign mul_result[i] = partial_product_add[i-1][0];
    end

    assign mul_result[WIDTH-1 +: WIDTH+1] = {carry_out_add[WIDTH-2], partial_product_add[WIDTH-2]};

endgenerate


always_ff @(posedge clk) begin
    result <= mul_result;
end

endmodule: mul_array_test_latency