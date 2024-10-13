module ripple_carry_adder (
	A,
	B,
	cin,
	S,
	prev_cout,
	cout
);
	parameter WIDTH = 8;
	input wire [WIDTH - 1:0] A;
	input wire [WIDTH - 1:0] B;
	input wire cin;
	output wire [WIDTH - 1:0] S;
	output wire prev_cout;
	output wire cout;
	wire [WIDTH:0] cout_vector;
	assign cout_vector[0] = cin;
	genvar _gv_block_12;
	generate
		for (_gv_block_12 = 0; _gv_block_12 < WIDTH; _gv_block_12 = _gv_block_12 + 1) begin : gen_adder
			localparam block = _gv_block_12;
			full_adder adder(
				.A(A[block]),
				.B(B[block]),
				.cin(cout_vector[block]),
				.S(S[block]),
				.cout(cout_vector[block + 1])
			);
		end
	endgenerate
	assign cout = cout_vector[WIDTH];
	assign prev_cout = cout_vector[WIDTH - 1];
endmodule
