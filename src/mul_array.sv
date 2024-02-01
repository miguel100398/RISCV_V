//File: mul_array
//Author: Miguel Bucio
//Date: 20/09/23
//Description: N Bit multiplier behavioral

module mul_array#(
    parameter WIDTH = 8 
) (
    input  logic [WIDTH-1:0] srca,
    input  logic [WIDTH-1:0] srcb,
    input  logic             is_mul,
    input  logic             is_high,
    input  logic             is_signed,
    output logic [WIDTH-1:0] result
);

localparam RESULT_WIDTH = 2*WIDTH;

typedef logic [WIDTH-1:0] data_t;
typedef logic [RESULT_WIDTH-1:0] result_t;

logic  srca_sign;
logic  srca_comp;
data_t srca_gated;
data_t srca_mul;

logic  srcb_sign;
logic  srcb_comp;
data_t srcb_mul;

result_t mul_result;
logic    result_comp;
result_t mul_result_comp;

data_t partial_product_and [WIDTH-1:0];
data_t partial_prduct_add [WIDTH-2:0];
logic  carry_out_add [WIDTH-2:0];

assign srca_gated = srca & {WIDTH{is_mul}};

//Twos complement
assign srca_sign = srca[WIDTH-1];
assign srcb_sign = srcb[WIDTH-1];

assign srca_comp = is_signed & srca_sign;
assign srcb_comp = is_signed & srcb_sign;

twos_comp_sel #(
    .WIDTH(WIDTH)
)twos_comp_srcA(
    .in(srca_gated),
    .complement(srca_comp),
    .out(srca_mul)
);

twos_comp_sel #(
    .WIDTH(WIDTH)
)twos_comp_srcB(
    .in(srcb),
    .complement(srcb_comp),
    .out(srcb_mul)
);

generate
    //Partial products and
    for (genvar i=0; i < WIDTH; i++) begin : gen_partial_and
        assign partial_product_and[i] = srca & {WIDTH{srcb[i]}};
    end
    //Adders
    assign {carry_out_add[0], partial_prduct_add[0]} = partial_product_and[0] + partial_product_and[1];

    for (genvar i=1; i < WIDTH-1; i++) begin : gen_partial_add
        assign {carry_out_add[i], partial_prduct_add[i]} = partial_product_and[i+1] + {carry_out_add[i-1], partial_prduct_add[i-1][WIDTH-1:1]};
    end

    //Result
    assign mul_result[0] = partial_product_and[0][0];
    for (genvar i=1; i < WIDTH-1; i++) begin : gen_result
        assign mul_result[i] = partial_prduct_add[i-1][0];
    end

    assign mul_result[WIDTH-1] = carry_out_add[WIDTH-2];

endgenerate

assign result_comp = srca_comp ^ srcb_comp;

twos_comp_sel #(
    .WIDTH(RESULT_WIDTH)
)twos_comp_result(
    .in(mul_result),
    .complement(result_comp),
    .out(mul_result_comp)
);

assign result = (is_high) ? mul_result_comp[WIDTH +: WIDTH] : mul_result_comp[0 +: WIDTH];

endmodule: mul_array