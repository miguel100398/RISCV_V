module full_adder (
	A,
	B,
	cin,
	S,
	cout
);
	input wire A;
	input wire B;
	input wire cin;
	output wire S;
	output wire cout;
	wire a_xor_b;
	wire a_and_b;
	wire a_xor_b_and_cin;
	assign a_xor_b = A ^ B;
	assign a_and_b = A & B;
	assign a_xor_b_and_cin = a_xor_b & cin;
	assign S = a_xor_b ^ cin;
	assign cout = a_and_b | a_xor_b_and_cin;
endmodule
