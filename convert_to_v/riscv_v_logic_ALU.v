module riscv_v_logic_ALU (
	is_reduct,
	is_and,
	is_or,
	is_xor,
	is_mask,
	is_negate_srca,
	is_negate_result,
	is_shift,
	is_left,
	is_arith,
	mask_result_valid,
	dst_osize_vector,
	is_greater_osize_vector,
	srca,
	srcb,
	result
);
	reg _sv2v_0;
	input wire is_reduct;
	input wire is_and;
	input wire is_or;
	input wire is_xor;
	input wire is_mask;
	input wire is_negate_srca;
	input wire is_negate_result;
	input wire is_shift;
	input wire is_left;
	input wire is_arith;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_result_valid;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES = 5;
	input wire [4:0] dst_osize_vector;
	input wire [4:0] is_greater_osize_vector;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srca;
	input wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srcb;
	output wire [(128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] result;
	wire is_reduct_n;
	wire valid_result;
	reg [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srca_bw;
	wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srcb_bw;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] and_result;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] or_result;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] xor_result;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] bw_result_pre_neg;
	reg [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] bw_result;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] shifter_result;
	assign valid_result = ((is_and || is_or) || is_xor) || is_shift;
	assign is_reduct_n = ~is_reduct;
	always @(*) begin
		if (_sv2v_0)
			;
		srca_bw = srca;
		srca_bw[128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))-:((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) ? ((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0))) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) - (128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)))) + 1)] = {riscv_v_pkg_RISCV_V_DATA_WIDTH {is_negate_srca}} ^ srca[128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))-:((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) ? ((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0))) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) - (128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)))) + 1)];
	end
	assign srcb_bw = srcb;
	riscv_v_bw_and bw_and(
		.is_reduct(is_reduct),
		.is_reduct_n(is_reduct_n),
		.is_and(is_and),
		.is_mask(is_mask),
		.osize_vector(dst_osize_vector),
		.is_greater_osize_vector(is_greater_osize_vector),
		.srca(srca_bw),
		.srcb(srcb_bw),
		.result(and_result)
	);
	riscv_v_bw_or bw_or(
		.is_reduct(is_reduct),
		.is_reduct_n(is_reduct_n),
		.is_or(is_or),
		.is_mask(is_mask),
		.osize_vector(dst_osize_vector),
		.is_greater_osize_vector(is_greater_osize_vector),
		.srca(srca_bw),
		.srcb(srcb_bw),
		.result(or_result)
	);
	riscv_v_bw_xor bw_xor(
		.is_reduct(is_reduct),
		.is_reduct_n(is_reduct_n),
		.is_xor(is_xor),
		.is_mask(is_mask),
		.osize_vector(dst_osize_vector),
		.is_greater_osize_vector(is_greater_osize_vector),
		.srca(srca_bw),
		.srcb(srcb_bw),
		.result(xor_result)
	);
	riscv_v_shifter shifter(
		.is_shift(is_shift),
		.is_left(is_left),
		.is_arith(is_arith),
		.osize_vector(dst_osize_vector),
		.is_greater_osize_vector(is_greater_osize_vector),
		.srca(srca),
		.srcb(srcb),
		.result(shifter_result)
	);
	assign bw_result_pre_neg = (and_result | or_result) | xor_result;
	always @(*) begin
		if (_sv2v_0)
			;
		bw_result = {riscv_v_pkg_RISCV_V_DATA_WIDTH {is_negate_result}} ^ bw_result_pre_neg;
		begin : sv2v_autoblock_1
			reg signed [31:0] idx;
			for (idx = 0; idx < riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG; idx = idx + 1)
				bw_result[((idx / riscv_pkg_BYTE_WIDTH) * riscv_pkg_BYTE_WIDTH) + (idx % riscv_pkg_BYTE_WIDTH)] = bw_result[((idx / riscv_pkg_BYTE_WIDTH) * riscv_pkg_BYTE_WIDTH) + (idx % riscv_pkg_BYTE_WIDTH)] & (~is_mask | mask_result_valid[idx]);
		end
	end
	assign result[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127-:((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) ? ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127)) + 1)] = bw_result | shifter_result;
	assign result[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] = srca[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] & {riscv_v_pkg_RISCV_V_NUM_BYTES_DATA {valid_result}};
	initial _sv2v_0 = 0;
endmodule
