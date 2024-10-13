module behavioral_adder (
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
	assign {prev_cout, S[WIDTH - 2:0]} = (A[WIDTH - 2:0] + B[WIDTH - 2:0]) + cin;
	assign {cout, S[WIDTH - 1-:1]} = (A[WIDTH - 1-:1] + B[WIDTH - 1-:1]) + prev_cout;
endmodule
