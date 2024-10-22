module mul_vec_array_test_latency (
	clk,
	srca,
	srcb,
	osize,
	result
);
	reg _sv2v_0;
	input wire clk;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [127:0] srca;
	input wire [127:0] srcb;
	input wire [2:0] osize;
	output reg [255:0] result;
	wire [255:0] mul8_result;
	wire [255:0] mul16_result;
	wire [255:0] mul32_result;
	wire [255:0] mul64_result;
	wire [255:0] mul128_result;
	genvar _gv_idx_1;
	generate
		for (_gv_idx_1 = 0; _gv_idx_1 < 16; _gv_idx_1 = _gv_idx_1 + 1) begin : gen_mul8
			localparam idx = _gv_idx_1;
			mul_array_test_latency #(.WIDTH(8)) mul8(
				.clk(clk),
				.srca_in(srca[idx * 8+:8]),
				.srcb_in(srcb[idx * 8+:8]),
				.result(mul8_result[idx * 16+:16])
			);
		end
	endgenerate
	genvar _gv_idx_2;
	generate
		for (_gv_idx_2 = 0; _gv_idx_2 < 8; _gv_idx_2 = _gv_idx_2 + 1) begin : gen_mul16
			localparam idx = _gv_idx_2;
			mul_array_test_latency #(.WIDTH(16)) mul8(
				.clk(clk),
				.srca_in(srca[idx * 16+:16]),
				.srcb_in(srcb[idx * 16+:16]),
				.result(mul16_result[idx * 32+:32])
			);
		end
	endgenerate
	genvar _gv_idx_3;
	generate
		for (_gv_idx_3 = 0; _gv_idx_3 < 4; _gv_idx_3 = _gv_idx_3 + 1) begin : gen_mul32
			localparam idx = _gv_idx_3;
			mul_array_test_latency #(.WIDTH(32)) mul8(
				.clk(clk),
				.srca_in(srca[idx * 32+:32]),
				.srcb_in(srcb[idx * 32+:32]),
				.result(mul32_result[idx * 64+:64])
			);
		end
	endgenerate
	genvar _gv_idx_4;
	generate
		for (_gv_idx_4 = 0; _gv_idx_4 < 2; _gv_idx_4 = _gv_idx_4 + 1) begin : gen_mul64
			localparam idx = _gv_idx_4;
			mul_array_test_latency #(.WIDTH(64)) mul8(
				.clk(clk),
				.srca_in(srca[idx * 64+:64]),
				.srcb_in(srcb[idx * 64+:64]),
				.result(mul64_result[idx * 128+:128])
			);
		end
	endgenerate
	genvar _gv_idx_5;
	generate
		for (_gv_idx_5 = 0; _gv_idx_5 < 1; _gv_idx_5 = _gv_idx_5 + 1) begin : gen_mul128
			localparam idx = _gv_idx_5;
			mul_array_test_latency #(.WIDTH(128)) mul8(
				.clk(clk),
				.srca_in(srca[idx * 128+:128]),
				.srcb_in(srcb[idx * 128+:128]),
				.result(mul128_result[idx * 256+:256])
			);
		end
	endgenerate
	function automatic [127:0] sv2v_cast_C2B51;
		input reg [127:0] inp;
		sv2v_cast_C2B51 = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		case (osize)
			3'd0: {result[128+:128], result[0+:128]} = mul8_result;
			3'd1: {result[128+:128], result[0+:128]} = mul16_result;
			3'd2: {result[128+:128], result[0+:128]} = mul32_result;
			3'd3: {result[128+:128], result[0+:128]} = mul64_result;
			3'd4: {result[128+:128], result[0+:128]} = mul128_result;
			default: result = {2 {sv2v_cast_C2B51(1'sbx)}};
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
