//File: mul_behavioral
//Author: Miguel Bucio
//Date: 20/09/23
//Description: N Bit multiplier behavioral

module mul_behavioral#(
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

assign mul_result =  srca_mul * srcb_mul;

assign result_comp = srca_comp ^ srcb_comp;

twos_comp_sel #(
    .WIDTH(RESULT_WIDTH)
)twos_comp_result(
    .in(mul_result),
    .complement(result_comp),
    .out(mul_result_comp)
);

assign result = (is_high) ? mul_result_comp[WIDTH +: WIDTH] : mul_result_comp[0 +: WIDTH];

endmodule: mul_behavioral