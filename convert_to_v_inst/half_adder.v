module half_adder (
	A,
	B,
	S,
	cout
);
	input wire A;
	input wire B;
	output wire S;
	output wire cout;
	assign S = A ^ B;
	assign cout = A & B;
endmodule
