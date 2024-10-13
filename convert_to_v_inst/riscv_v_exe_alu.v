module riscv_v_exe_alu (
	clk,
	rst,
	osize_exe,
	opcode_exe,
	len_exe,
	srca_exe,
	srcb_exe,
	mask_exe,
	mask_merge_exe,
	mask_result_valid_exe,
	dst_osize_vector_exe,
	src_osize_vector_exe,
	is_greater_osize_vector_exe,
	is_less_osize_vector_exe,
	is_i2v_exe,
	is_v2i_exe,
	is_and_exe,
	is_or_exe,
	is_xor_exe,
	is_mask_exe,
	is_negate_srca_exe,
	is_negate_srcb_exe,
	is_negate_result_exe,
	is_shift_exe,
	is_left_exe,
	is_arith_exe,
	is_reduct_exe,
	is_add_exe,
	is_sub_exe,
	is_mul_exe,
	is_zero_ext_exe,
	is_sign_ext_exe,
	is_set_equal_exe,
	is_set_nequal_exe,
	is_set_less_exe,
	is_set_greater_exe,
	is_max_exe,
	is_min_exe,
	is_high_exe,
	is_signed_exe,
	use_carry_exe,
	int_result_exe,
	vec_result_exe
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	input wire [2:0] osize_exe;
	input wire [5:0] opcode_exe;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [$clog2(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA):0] len_exe;
	input wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srca_exe;
	input wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srcb_exe;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_exe;
	input wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_merge_exe;
	input wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_result_valid_exe;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES = 5;
	input wire [4:0] dst_osize_vector_exe;
	input wire [4:0] src_osize_vector_exe;
	input wire [4:0] is_greater_osize_vector_exe;
	input wire [4:0] is_less_osize_vector_exe;
	input wire is_i2v_exe;
	input wire is_v2i_exe;
	input wire is_and_exe;
	input wire is_or_exe;
	input wire is_xor_exe;
	input wire is_mask_exe;
	input wire is_negate_srca_exe;
	input wire is_negate_srcb_exe;
	input wire is_negate_result_exe;
	input wire is_shift_exe;
	input wire is_left_exe;
	input wire is_arith_exe;
	input wire is_reduct_exe;
	input wire is_add_exe;
	input wire is_sub_exe;
	input wire is_mul_exe;
	input wire is_zero_ext_exe;
	input wire is_sign_ext_exe;
	input wire is_set_equal_exe;
	input wire is_set_nequal_exe;
	input wire is_set_less_exe;
	input wire is_set_greater_exe;
	input wire is_max_exe;
	input wire is_min_exe;
	input wire is_high_exe;
	input wire is_signed_exe;
	input wire use_carry_exe;
	localparam signed [31:0] riscv_pkg_DWORD_WIDTH = 32;
	localparam signed [31:0] riscv_pkg_RISCV_DATA_WIDTH = riscv_pkg_DWORD_WIDTH;
	localparam signed [31:0] riscv_pkg_RISCV_NUM_BYTES_DATA = riscv_pkg_RISCV_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	localparam signed [31:0] riscv_pkg_DQWORD_WIDTH = 128;
	localparam signed [31:0] riscv_pkg_RISCV_NUM_DQWORDS_DATA = riscv_pkg_RISCV_DATA_WIDTH / riscv_pkg_DQWORD_WIDTH;
	localparam signed [31:0] riscv_pkg_RISCV_NUM_DWORDS_DATA = riscv_pkg_RISCV_DATA_WIDTH / riscv_pkg_DWORD_WIDTH;
	localparam signed [31:0] riscv_pkg_QWORD_WIDTH = 64;
	localparam signed [31:0] riscv_pkg_RISCV_NUM_QWORDS_DATA = riscv_pkg_RISCV_DATA_WIDTH / riscv_pkg_QWORD_WIDTH;
	localparam signed [31:0] riscv_pkg_WORD_WIDTH = 16;
	localparam signed [31:0] riscv_pkg_RISCV_NUM_WORDS_DATA = riscv_pkg_RISCV_DATA_WIDTH / riscv_pkg_WORD_WIDTH;
	output wire [31:0] int_result_exe;
	output reg [(128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] vec_result_exe;
	wire [(128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] logic_result;
	wire [(128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] arithmetic_result;
	wire [(128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] permutation_result;
	always @(*) begin
		if (_sv2v_0)
			;
		vec_result_exe = logic_result;
		vec_result_exe = vec_result_exe | arithmetic_result;
		vec_result_exe = vec_result_exe | permutation_result;
		vec_result_exe[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127) - (128 - riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG):riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0] = vec_result_exe[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127) - (128 - riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG):riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0] | mask_merge_exe;
	end
	riscv_v_logic_ALU logic_ALU(
		.is_reduct(is_reduct_exe),
		.is_and(is_and_exe),
		.is_or(is_or_exe),
		.is_xor(is_xor_exe),
		.is_mask(is_mask_exe),
		.mask_result_valid(mask_result_valid_exe),
		.is_negate_srca(is_negate_srca_exe),
		.is_negate_result(is_negate_result_exe),
		.is_shift(is_shift_exe),
		.is_left(is_left_exe),
		.is_arith(is_arith_exe),
		.dst_osize_vector(dst_osize_vector_exe),
		.is_greater_osize_vector(is_greater_osize_vector_exe),
		.srca(srca_exe),
		.srcb(srcb_exe),
		.osize(osize_exe),
		.opcode(opcode_exe),
		.len(len_exe),
		.result(logic_result)
	);
	riscv_v_arithmetic_ALU arithmetic_ALU(
		.is_reduct(is_reduct_exe),
		.is_add(is_add_exe),
		.is_sub(is_sub_exe),
		.is_negate_srca(is_negate_srca_exe),
		.is_negate_srcb(is_negate_srcb_exe),
		.is_mul(is_mul_exe),
		.is_zero_ext(is_zero_ext_exe),
		.is_sign_ext(is_sign_ext_exe),
		.is_set_equal(is_set_equal_exe),
		.is_set_nequal(is_set_nequal_exe),
		.is_set_less(is_set_less_exe),
		.is_set_greater(is_set_greater_exe),
		.is_max(is_max_exe),
		.is_min(is_min_exe),
		.is_high(is_high_exe),
		.is_signed(is_signed_exe),
		.use_carry(use_carry_exe),
		.dst_osize_vector(dst_osize_vector_exe),
		.src_osize_vector(src_osize_vector_exe),
		.is_greater_osize_vector(is_greater_osize_vector_exe),
		.is_less_osize_vector(is_less_osize_vector_exe),
		.srca(srca_exe),
		.srcb(srcb_exe),
		.carry_in(mask_exe),
		.osize(osize_exe),
		.opcode(opcode_exe),
		.len(len_exe),
		.result(arithmetic_result)
	);
	riscv_v_permutation_ALU permutation_ALU(
		.is_i2v(is_i2v_exe),
		.is_v2i(is_v2i_exe),
		.srca(srca_exe),
		.srcb(srcb_exe),
		.osize_greater_vector(is_greater_osize_vector_exe),
		.osize_vector(src_osize_vector_exe),
		.osize(osize_exe),
		.opcode(opcode_exe),
		.integer_data_out(int_result_exe),
		.vector_data_out(permutation_result)
	);
	initial _sv2v_0 = 0;
endmodule
