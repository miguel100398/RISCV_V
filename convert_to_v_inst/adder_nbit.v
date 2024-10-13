module adder_nbit (
	A,
	B,
	cin,
	S,
	prev_cout,
	cout
);
	parameter signed [31:0] WIDTH = 8;
	parameter [0:0] BEHAVIORAL = 1'b1;
	parameter [0:0] RIPPLE_CARRY = 1'b0;
	input wire [WIDTH - 1:0] A;
	input wire [WIDTH - 1:0] B;
	input wire cin;
	output wire [WIDTH - 1:0] S;
	output wire prev_cout;
	output wire cout;
	generate
		if (RIPPLE_CARRY) begin : get_ripple_carry_adder
			ripple_carry_adder #(.WIDTH(WIDTH)) adder(
				.A(A),
				.B(B),
				.cin(cin),
				.S(S),
				.prev_cout(prev_cout),
				.cout(cout)
			);
		end
		else if (BEHAVIORAL) begin : gen_behavioral_adder
			behavioral_adder #(.WIDTH(WIDTH)) adder(
				.A(A),
				.B(B),
				.cin(cin),
				.S(S),
				.prev_cout(prev_cout),
				.cout(cout)
			);
		end
		else begin : gen_default_adder
			behavioral_adder #(.WIDTH(WIDTH)) adder(
				.A(A),
				.B(B),
				.cin(cin),
				.S(S),
				.prev_cout(prev_cout),
				.cout(cout)
			);
		end
	endgenerate
endmodule
