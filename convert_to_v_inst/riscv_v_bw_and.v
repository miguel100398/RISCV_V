module riscv_v_bw_and (
	is_reduct,
	is_reduct_n,
	is_and,
	is_mask,
	osize_vector,
	is_greater_osize_vector,
	srca,
	srcb,
	result
);
	input wire is_reduct;
	input wire is_reduct_n;
	input wire is_and;
	input wire is_mask;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES = 5;
	input wire [4:0] osize_vector;
	input wire [4:0] is_greater_osize_vector;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srca;
	input wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srcb;
	output wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] result;
	localparam NUM_BW_BLOCKS = riscv_v_pkg_RISCV_V_NUM_BYTES_DATA;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] srca_gated;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] srca_bw;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] srcb_bw;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] result_bw;
	genvar _gv_i_1;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < NUM_BW_BLOCKS; _gv_i_1 = _gv_i_1 + 1) begin : gen_is_and_srcA_gating
			localparam i = _gv_i_1;
			assign srca_gated[i * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = srca[(128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (127 - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (i * riscv_pkg_BYTE_WIDTH))))+:riscv_pkg_BYTE_WIDTH] & {riscv_pkg_BYTE_WIDTH {is_and}};
		end
	endgenerate
	riscv_v_reduct_src reduct_srca(
		.src(srca_gated),
		.is_reduct(is_reduct),
		.is_reduct_n(is_reduct_n),
		.osize_vector(osize_vector),
		.is_greater_osize_vector(is_greater_osize_vector),
		.result(result_bw),
		.src_o(srca_bw)
	);
	genvar _gv_i_2;
	generate
		for (_gv_i_2 = 0; _gv_i_2 < NUM_BW_BLOCKS; _gv_i_2 = _gv_i_2 + 1) begin : gen_srcb_bw
			localparam i = _gv_i_2;
			assign srcb_bw[i * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = srcb[(128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (127 - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (i * riscv_pkg_BYTE_WIDTH))))+:riscv_pkg_BYTE_WIDTH] | {riscv_pkg_BYTE_WIDTH {~srcb[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - i)] & ~is_mask}};
		end
	endgenerate
	genvar _gv_block_1;
	generate
		for (_gv_block_1 = 0; _gv_block_1 < NUM_BW_BLOCKS; _gv_block_1 = _gv_block_1 + 1) begin : gen_bitwise_and
			localparam block = _gv_block_1;
			riscv_v_bitwise_and #(.DATA_WIDTH(riscv_pkg_BYTE_WIDTH)) bitwise_and(
				.A(srca_bw[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH]),
				.B(srcb_bw[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH]),
				.S(result_bw[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH])
			);
		end
	endgenerate
	genvar _gv_i_3;
	generate
		for (_gv_i_3 = 0; _gv_i_3 < NUM_BW_BLOCKS; _gv_i_3 = _gv_i_3 + 1) begin : gen_and_result
			localparam i = _gv_i_3;
			assign result[i * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = result_bw[i * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH];
		end
	endgenerate
endmodule
