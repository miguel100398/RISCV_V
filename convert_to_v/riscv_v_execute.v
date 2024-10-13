module riscv_v_execute (
	clk,
	rst,
	int_data_exe,
	imm_exe,
	int_data_result_exe,
	srca_exe,
	srcb_exe,
	mask_exe,
	mask_merge_exe,
	alu_result_exe,
	rf_wr_en_mem,
	rf_wr_en_wb,
	rf_rd_addr_srca_exe,
	rf_rd_addr_srcb_exe,
	rf_wr_addr_exe,
	rf_wr_addr_mem,
	rf_wr_addr_wb,
	rf_wr_data_mem,
	rf_wr_data_wb,
	is_scalar_op_exe,
	is_vector_vector_op_exe,
	is_scalar_vector_op_exe,
	is_scalar_imm_op_exe,
	is_scalar_int_op_exe,
	is_scalar_fp_op_exe,
	is_i2v_exe,
	is_v2i_exe,
	is_and_exe,
	is_or_exe,
	is_xor_exe,
	is_negate_srca_exe,
	is_negate_srcb_exe,
	is_negate_result_exe,
	is_mask_exe,
	use_mask_exe,
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
	is_compare_exe,
	is_set_nequal_exe,
	is_set_less_exe,
	is_set_greater_exe,
	is_max_exe,
	is_min_exe,
	is_high_exe,
	is_signed_exe,
	use_carry_exe,
	vtype_exe,
	vl_exe,
	vstart_exe
);
	input wire clk;
	input wire rst;
	localparam signed [31:0] riscv_pkg_DWORD_WIDTH = 32;
	localparam signed [31:0] riscv_pkg_RISCV_DATA_WIDTH = riscv_pkg_DWORD_WIDTH;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	localparam signed [31:0] riscv_pkg_RISCV_NUM_BYTES_DATA = riscv_pkg_RISCV_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	localparam signed [31:0] riscv_pkg_DQWORD_WIDTH = 128;
	localparam signed [31:0] riscv_pkg_RISCV_NUM_DQWORDS_DATA = riscv_pkg_RISCV_DATA_WIDTH / riscv_pkg_DQWORD_WIDTH;
	localparam signed [31:0] riscv_pkg_RISCV_NUM_DWORDS_DATA = riscv_pkg_RISCV_DATA_WIDTH / riscv_pkg_DWORD_WIDTH;
	localparam signed [31:0] riscv_pkg_QWORD_WIDTH = 64;
	localparam signed [31:0] riscv_pkg_RISCV_NUM_QWORDS_DATA = riscv_pkg_RISCV_DATA_WIDTH / riscv_pkg_QWORD_WIDTH;
	localparam signed [31:0] riscv_pkg_WORD_WIDTH = 16;
	localparam signed [31:0] riscv_pkg_RISCV_NUM_WORDS_DATA = riscv_pkg_RISCV_DATA_WIDTH / riscv_pkg_WORD_WIDTH;
	input wire [31:0] int_data_exe;
	localparam riscv_v_pkg_RISCV_V_IMM_WIDTH = 5;
	input wire [4:0] imm_exe;
	output wire [31:0] int_data_result_exe;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [127:0] srca_exe;
	input wire [127:0] srcb_exe;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_exe;
	input wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_merge_exe;
	output wire [(128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] alu_result_exe;
	input wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] rf_wr_en_mem;
	input wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] rf_wr_en_wb;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_RS_WIDTH = 5;
	input wire [4:0] rf_rd_addr_srca_exe;
	input wire [4:0] rf_rd_addr_srcb_exe;
	input wire [4:0] rf_wr_addr_exe;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_RD_WIDTH = 5;
	input wire [4:0] rf_wr_addr_mem;
	input wire [4:0] rf_wr_addr_wb;
	input wire [127:0] rf_wr_data_mem;
	input wire [127:0] rf_wr_data_wb;
	input wire is_scalar_op_exe;
	input wire is_vector_vector_op_exe;
	input wire is_scalar_vector_op_exe;
	input wire is_scalar_imm_op_exe;
	input wire is_scalar_int_op_exe;
	input wire is_scalar_fp_op_exe;
	input wire is_i2v_exe;
	input wire is_v2i_exe;
	input wire is_and_exe;
	input wire is_or_exe;
	input wire is_xor_exe;
	input wire is_negate_srca_exe;
	input wire is_negate_srcb_exe;
	input wire is_negate_result_exe;
	input wire is_mask_exe;
	input wire use_mask_exe;
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
	input wire is_compare_exe;
	input wire is_set_nequal_exe;
	input wire is_set_less_exe;
	input wire is_set_greater_exe;
	input wire is_max_exe;
	input wire is_min_exe;
	input wire is_high_exe;
	input wire is_signed_exe;
	input wire use_carry_exe;
	input wire [8:0] vtype_exe;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_MAX_LMUL = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_MAX_VLEN = riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG * riscv_v_pkg_RISCV_V_MAX_LMUL;
	input wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vl_exe;
	input wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vstart_exe;
	wire [127:0] srca_byp;
	wire [127:0] srcb_byp;
	wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_byp;
	wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_alu;
	wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_merge_byp;
	wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_merge_alu;
	wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_result_valid_alu;
	wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srca_alu;
	wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srcb_alu;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES = 5;
	wire [4:0] dst_osize_vector;
	wire [4:0] src_osize_vector;
	wire [4:0] is_greater_osize_vector;
	wire [4:0] is_less_osize_vector;
	wire [(128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] alu_result_pre_swizzle_exe;
	wire [127:0] alu_result_data_exe;
	wire [127:0] result_swizzle_exe;
	riscv_v_exe_alu exe_alu(
		.clk(clk),
		.rst(rst),
		.srca_exe(srca_alu),
		.srcb_exe(srcb_alu),
		.is_mask_exe(is_mask_exe),
		.mask_result_valid_exe(mask_result_valid_alu),
		.mask_exe(mask_alu),
		.mask_merge_exe(mask_merge_alu),
		.dst_osize_vector_exe(dst_osize_vector),
		.src_osize_vector_exe(src_osize_vector),
		.is_greater_osize_vector_exe(is_greater_osize_vector),
		.is_less_osize_vector_exe(is_less_osize_vector),
		.is_i2v_exe(is_i2v_exe),
		.is_v2i_exe(is_v2i_exe),
		.is_and_exe(is_and_exe),
		.is_or_exe(is_or_exe),
		.is_xor_exe(is_xor_exe),
		.is_negate_srca_exe(is_negate_srca_exe),
		.is_negate_srcb_exe(is_negate_srcb_exe),
		.is_negate_result_exe(is_negate_result_exe),
		.is_shift_exe(is_shift_exe),
		.is_left_exe(is_left_exe),
		.is_arith_exe(is_arith_exe),
		.is_reduct_exe(is_reduct_exe),
		.is_add_exe(is_add_exe),
		.is_sub_exe(is_sub_exe),
		.is_mul_exe(is_mul_exe),
		.is_zero_ext_exe(is_zero_ext_exe),
		.is_sign_ext_exe(is_sign_ext_exe),
		.is_set_equal_exe(is_set_equal_exe),
		.is_set_nequal_exe(is_set_nequal_exe),
		.is_set_less_exe(is_set_less_exe),
		.is_set_greater_exe(is_set_greater_exe),
		.is_max_exe(is_max_exe),
		.is_min_exe(is_min_exe),
		.is_high_exe(is_high_exe),
		.is_signed_exe(is_signed_exe),
		.use_carry_exe(use_carry_exe),
		.int_result_exe(int_data_result_exe),
		.vec_result_exe(alu_result_pre_swizzle_exe)
	);
	riscv_v_decode_element decode_element(
		.srca_addr(rf_rd_addr_srca_exe),
		.srca(srca_byp),
		.srcb(srcb_byp),
		.vtype(vtype_exe),
		.vl(vl_exe),
		.vstart(vstart_exe),
		.is_i2v(is_i2v_exe),
		.is_v2i(is_v2i_exe),
		.is_compare(is_compare_exe),
		.use_mask(use_mask_exe),
		.mask(mask_byp),
		.mask_merge(mask_merge_byp),
		.mask_osize_sel(mask_alu),
		.mask_merge_qual(mask_merge_alu),
		.mask_result_valid(mask_result_valid_alu),
		.is_mask(is_mask_exe),
		.is_zero_ext(is_zero_ext_exe),
		.is_sign_ext(is_sign_ext_exe),
		.is_reduct(is_reduct_exe),
		.srca_alu(srca_alu),
		.srcb_alu(srcb_alu),
		.dst_osize_vector(dst_osize_vector),
		.src_osize_vector(src_osize_vector),
		.is_greater_osize_vector(is_greater_osize_vector),
		.is_less_osize_vector(is_less_osize_vector)
	);
	riscv_v_bypass v_bypass(
		.integer_data(int_data_exe),
		.imm(imm_exe),
		.srca(srca_exe),
		.srcb(srcb_exe),
		.mask(mask_exe),
		.mask_merge(mask_merge_exe),
		.osize_vector(src_osize_vector),
		.is_shift(is_shift_exe),
		.is_scalar_int(is_scalar_int_op_exe),
		.is_scalar_imm(is_scalar_imm_op_exe),
		.is_scalar_vec(is_scalar_vector_op_exe),
		.is_scalar_fp(is_scalar_fp_op_exe),
		.is_scalar(is_scalar_op_exe),
		.rf_wr_en_mem(rf_wr_en_mem),
		.rf_wr_en_wb(rf_wr_en_wb),
		.rf_rd_addr_srca_exe(rf_rd_addr_srca_exe),
		.rf_rd_addr_srcb_exe(rf_rd_addr_srcb_exe),
		.rf_merge_mask_addr_exe(rf_wr_addr_exe),
		.rf_wr_addr_mem(rf_wr_addr_mem),
		.rf_wr_addr_wb(rf_wr_addr_wb),
		.rf_wr_data_mem(rf_wr_data_mem),
		.rf_wr_data_wb(rf_wr_data_wb),
		.srca_byp(srca_byp),
		.srcb_byp(srcb_byp),
		.mask_byp(mask_byp),
		.mask_merge_byp(mask_merge_byp)
	);
	assign alu_result_data_exe = alu_result_pre_swizzle_exe[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127-:((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) ? ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127)) + 1)];
	riscv_v_swizzle v_swizzle(
		.src_data(alu_result_data_exe),
		.invert(is_reduct_exe),
		.osize_vec(dst_osize_vector),
		.result(result_swizzle_exe)
	);
	assign alu_result_exe[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127-:((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) ? ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127)) + 1)] = result_swizzle_exe;
	assign alu_result_exe[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] = alu_result_pre_swizzle_exe[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA];
endmodule
