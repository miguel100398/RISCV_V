module riscv_v_bitwise_or (
	A,
	B,
	S
);
	parameter signed [31:0] DATA_WIDTH = 8;
	input wire [DATA_WIDTH - 1:0] A;
	input wire [DATA_WIDTH - 1:0] B;
	output wire [DATA_WIDTH - 1:0] S;
	assign S = A | B;
endmodule
