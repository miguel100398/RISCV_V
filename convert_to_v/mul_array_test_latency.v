module mul_array_test_latency (
	clk,
	srca_in,
	srcb_in,
	result
);
	parameter WIDTH = 16;
	input wire clk;
	input wire [WIDTH - 1:0] srca_in;
	input wire [WIDTH - 1:0] srcb_in;
	output reg [(2 * WIDTH) - 1:0] result;
	localparam RESULT_WIDTH = 2 * WIDTH;
	reg [WIDTH - 1:0] srca;
	reg [WIDTH - 1:0] srcb;
	wire [RESULT_WIDTH - 1:0] mul_result;


	always @(posedge clk) begin
		srca <= srca_in;
		srcb <= srcb_in;
	end

	mul_array#(
		.WIDTH(WIDTH),
		.BEHAVIORAL(1'b0),
		.RIPPLE_CARRY(1'b1)
	) mul_array_i(
		.A(srca_in),
		.B(srcb_in),
		.mul_result(mul_result)
	);

	
	always @(posedge clk) begin
		result <= mul_result;
	end
endmodule
