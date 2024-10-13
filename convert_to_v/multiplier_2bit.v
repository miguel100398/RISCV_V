module multiplier_2bit (
	A,
	B,
	Z
);
	reg _sv2v_0;
	input wire [1:0] A;
	input wire [1:0] B;
	output wire [3:0] Z;
	reg partial [1:0][1:0];
	wire cout_ha;
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_1
			reg signed [31:0] idx_A;
			for (idx_A = 0; idx_A < 2; idx_A = idx_A + 1)
				begin : sv2v_autoblock_2
					reg signed [31:0] idx_B;
					for (idx_B = 0; idx_B < 2; idx_B = idx_B + 1)
						partial[idx_A][idx_B] = A[idx_A] & B[idx_B];
				end
		end
	end
	assign Z[0] = partial[0][0];
	half_adder ha0(
		.A(partial[0][1]),
		.B(partial[1][0]),
		.S(Z[1]),
		.cout(cout_ha)
	);
	half_adder ha1(
		.A(cout_ha),
		.B(partial[1][1]),
		.S(Z[2]),
		.cout(Z[3])
	);
	initial _sv2v_0 = 0;
endmodule
