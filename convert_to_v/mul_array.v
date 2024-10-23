module mul_array#(
    parameter WIDTH=8,
    parameter BEHAVIORAL = 1'b0,
    parameter RIPPLE_CARRY = 1'b1,
    parameter RESULT_WIDTH = (2*WIDTH)
)(
    input wire [WIDTH-1:0] A,
    input wire [WIDTH-1:0] B,
    output wire [RESULT_WIDTH-1:0] mul_result
);

    wire [WIDTH-1:0] partial_product_and [WIDTH-1:0];
    wire [WIDTH - 1:0] partial_product_add [WIDTH - 2:0];
    wire carry_out_add [WIDTH - 2:0];

    genvar gen_and_pp;
    generate
        for (gen_and_pp = 0; gen_and_pp < WIDTH; gen_and_pp = gen_and_pp+1) begin : gen_partian_and
            bw_and #(
                .WIDTH(WIDTH)    
            )bw_and_i(
                .A(A),
                .B({WIDTH{B[gen_and_pp]}}),
                .S(partial_product_and[gen_and_pp])
            );
        end 
    endgenerate

    adder_nbit#(
        .WIDTH(WIDTH),
        .BEHAVIORAL(BEHAVIORAL),
        .RIPPLE_CARRY(RIPPLE_CARRY)
    ) adder0(
        .A(partial_product_and[0]),
        .B({1'b0,partial_product_and[1][WIDTH-1:1]}),
        .cin(1'b0),
        .S(partial_product_add[0]),
        .cout(carry_out_add[0])
    );

    genvar gen_adder;
    generate
        for (gen_adder = 1; gen_adder < WIDTH-1; gen_adder = gen_adder+1) begin : gen_partial_adder
            adder_nbit#(
                .WIDTH(WIDTH),
                .BEHAVIORAL(BEHAVIORAL),
                .RIPPLE_CARRY(RIPPLE_CARRY)
            ) addern(
                .A({carry_out_add[gen_adder - 1], partial_product_add[gen_adder - 1][WIDTH - 1:1]}),
                .B(partial_product_and[gen_adder+1]),
                .cin(1'b0),
                .S(partial_product_add[gen_adder]),
                .cout(carry_out_add[gen_adder])
            );
        end 
    endgenerate

    assign mul_result[0] = partial_product_and[0][0];
	genvar _gv_i_3;
	generate
		for (_gv_i_3 = 1; _gv_i_3 < (WIDTH - 1); _gv_i_3 = _gv_i_3 + 1) begin : gen_result
			localparam i = _gv_i_3;
			assign mul_result[i] = partial_product_add[i - 1][0];
		end
	endgenerate
	assign mul_result[WIDTH - 1+:WIDTH + 1] = {carry_out_add[WIDTH - 2], partial_product_add[WIDTH - 2]};

endmodule