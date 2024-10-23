module mul_array_test_latency (
	clk,
	srca_in,
	srcb_in,
	result
);
	parameter WIDTH = 128;
	input wire clk;
	input wire [WIDTH - 1:0] srca_in;
	input wire [WIDTH - 1:0] srcb_in;
	output reg [(2 * WIDTH) - 1:0] result;
	localparam RESULT_WIDTH = 2 * WIDTH;
	reg [WIDTH - 1:0] srca;
	reg [WIDTH - 1:0] srcb;
	wire [RESULT_WIDTH - 1:0] mul_result;
	wire [WIDTH - 1:0] partial_product_and [WIDTH - 1:0];
	wire [WIDTH - 1:0] partial_product_add [WIDTH - 2:0];
	wire carry_out_add [WIDTH - 2:0];

	always @(posedge clk) begin
		srca <= srca_in;
		srcb <= srcb_in;
	end

	genvar _gv_i_1;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < WIDTH; _gv_i_1 = _gv_i_1 + 1) begin : gen_partial_and
			localparam i = _gv_i_1;
			assign partial_product_and[i] = srca & {WIDTH {srcb[i]}};
		end
	endgenerate


	ripple_carry_adder #(
		.WIDTH(WIDTH)
	)adder0(
		.A({1'b0, partial_product_and[0][WIDTH-1:1]}),
		.B(partial_product_and[1]),
		.cin(1'b0),
		.S(partial_product_add[0]),
		.cout(carry_out_add[0])
	);

	genvar _gv_i_2;

	generate
		for (_gv_i_2 = 1; _gv_i_2 < (WIDTH - 1); _gv_i_2 = _gv_i_2 + 1) begin : gen_partial_add
			localparam i = _gv_i_2;
			ripple_carry_adder #(
				.WIDTH(WIDTH)
			)addern(
				.A({carry_out_add[i - 1], partial_product_add[i - 1][WIDTH - 1:1]}),
				.B(partial_product_and[i+1]),
				.cin(1'b0),
				.S(partial_product_add[i]),
				.cout(carry_out_add[i])
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
	always @(posedge clk) result <= mul_result;
endmodule
