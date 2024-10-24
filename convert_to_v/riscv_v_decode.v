module riscv_v_decode (
	clk,
	rst,
	clear_pipe,
	riscv_stall,
	riscv_v_stall,
	instruction_id,
	int_rf_rd_data_id,
	int_rf_wr_data_wb,
	int_rf_wr_en_wb,
	rf_wr_en_mem,
	rf_wr_en_wb,
	rf_rd_addr_srca_exe,
	rf_rd_addr_srcb_exe,
	rf_wr_addr_exe,
	rf_wr_addr_mem,
	rf_wr_addr_wb,
	rf_wr_data_mem,
	rf_wr_data_wb,
	imm_exe,
	int_rf_rd_data_exe,
	int_rf_wr_data_exe,
	rf_rd_data_srca_exe,
	rf_rd_data_srcb_exe,
	mask_exe,
	mask_merge_exe,
	alu_result_exe,
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
	is_compare_exe,
	is_set_equal_exe,
	is_set_nequal_exe,
	is_set_less_exe,
	is_set_greater_exe,
	is_max_exe,
	is_min_exe,
	is_high_exe,
	is_signed_exe,
	use_carry_exe,
	ext_data_in_exe,
	ext_wr_vsstatus_id,
	ext_wr_vtype_id,
	ext_wr_vl_id,
	ext_wr_vstart_id,
	ext_wr_vxrm_id,
	ext_wr_vxsat_id,
	vsstatus_exe,
	vtype_exe,
	vl_exe,
	vlenb_exe,
	vstart_exe,
	vxrm_exe,
	vxsat_exe,
	vcsr_exe,
	syn_addr,
	syn_data
);
	input wire clk;
	input wire rst;
	input wire clear_pipe;
	input wire riscv_stall;
	output wire riscv_v_stall;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_WIDTH = 32;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_FUNCT3_WIDTH = 3;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_IMM_12_10_5_WIDTH = 7;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_IMM_4_1_11_WIDTH = 5;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_OP_WIDTH = 7;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_RS_WIDTH = 5;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_IMM_11_0_WIDTH = 12;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_RD_WIDTH = 5;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_IMM_JUMP_WIDTH = 20;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_FUNCT7_WIDTH = 7;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_IMM_11_5_WIDTH = 7;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_IMM_4_0_WIDTH = 5;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_IMM_31_12_WIDTH = 20;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_FUNCT6_WIDTH = 6;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_MASK_WIDTH = 1;
	input wire [(((((riscv_pkg_RISCV_INSTR_FUNCT7_WIDTH + riscv_pkg_RISCV_INSTR_RS_WIDTH) + riscv_pkg_RISCV_INSTR_RS_WIDTH) + riscv_pkg_RISCV_INSTR_FUNCT3_WIDTH) + riscv_pkg_RISCV_INSTR_RD_WIDTH) + riscv_pkg_RISCV_INSTR_OP_WIDTH) - 1:0] instruction_id;
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
	input wire [31:0] int_rf_rd_data_id;
	output wire [31:0] int_rf_wr_data_wb;
	output wire int_rf_wr_en_wb;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	output wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] rf_wr_en_mem;
	output wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] rf_wr_en_wb;
	output wire [4:0] rf_rd_addr_srca_exe;
	output wire [4:0] rf_rd_addr_srcb_exe;
	output wire [4:0] rf_wr_addr_exe;
	output wire [4:0] rf_wr_addr_mem;
	output wire [4:0] rf_wr_addr_wb;
	output wire [127:0] rf_wr_data_mem;
	output wire [127:0] rf_wr_data_wb;
	localparam riscv_v_pkg_RISCV_V_IMM_WIDTH = 5;
	output wire [4:0] imm_exe;
	output wire [31:0] int_rf_rd_data_exe;
	input wire [31:0] int_rf_wr_data_exe;
	output wire [127:0] rf_rd_data_srca_exe;
	output wire [127:0] rf_rd_data_srcb_exe;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	output wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_exe;
	output wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_merge_exe;
	input wire [(128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] alu_result_exe;
	output wire is_scalar_op_exe;
	output wire is_vector_vector_op_exe;
	output wire is_scalar_vector_op_exe;
	output wire is_scalar_imm_op_exe;
	output wire is_scalar_int_op_exe;
	output wire is_scalar_fp_op_exe;
	output wire is_i2v_exe;
	output wire is_v2i_exe;
	output wire is_and_exe;
	output wire is_or_exe;
	output wire is_xor_exe;
	output wire is_negate_srca_exe;
	output wire is_negate_srcb_exe;
	output wire is_negate_result_exe;
	output wire is_mask_exe;
	output wire use_mask_exe;
	output wire is_shift_exe;
	output wire is_left_exe;
	output wire is_arith_exe;
	output wire is_reduct_exe;
	output wire is_add_exe;
	output wire is_sub_exe;
	output wire is_mul_exe;
	output wire is_zero_ext_exe;
	output wire is_sign_ext_exe;
	output wire is_compare_exe;
	output wire is_set_equal_exe;
	output wire is_set_nequal_exe;
	output wire is_set_less_exe;
	output wire is_set_greater_exe;
	output wire is_max_exe;
	output wire is_min_exe;
	output wire is_high_exe;
	output wire is_signed_exe;
	output wire use_carry_exe;
	input wire [31:0] ext_data_in_exe;
	input wire ext_wr_vsstatus_id;
	input wire ext_wr_vtype_id;
	input wire ext_wr_vl_id;
	input wire ext_wr_vstart_id;
	input wire ext_wr_vxrm_id;
	input wire ext_wr_vxsat_id;
	output wire [10:0] vsstatus_exe;
	output wire [8:0] vtype_exe;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_MAX_LMUL = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_MAX_VLEN = riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG * riscv_v_pkg_RISCV_V_MAX_LMUL;
	output wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vl_exe;
	output wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vlenb_exe;
	output wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vstart_exe;
	output wire [1:0] vxrm_exe;
	output wire [0:0] vxsat_exe;
	output wire [2:0] vcsr_exe;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_RF_NUM_REGS = 32;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_RF_ADDR_WIDTH = 5;
	input wire [4:0] syn_addr;
	output wire [127:0] syn_data;
	wire stall;
	wire flush;
	wire [4:0] rf_rd_addr_srca_id;
	wire [4:0] rf_rd_addr_srcb_id;
	wire [4:0] rf_wr_addr_id;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] rf_wr_en_exe;
	wire [127:0] rf_wr_data_exe;
	wire [127:0] rf_rd_data_srca_id;
	wire [127:0] rf_rd_data_srcb_id;
	wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_id;
	wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_merge_id;
	wire int_rf_wr_en_id;
	wire [127:0] vec_data_in_exe;
	wire vec_wr_vsstatus_id;
	wire vec_wr_vtype_id;
	wire vec_wr_vl_id;
	wire vec_wr_vstart_id;
	wire vec_wr_vxrm_id;
	wire vec_wr_vxsat_id;
	wire csr_wr_en_vsstatus_exe;
	wire csr_wr_en_vtype_exe;
	wire csr_wr_en_vl_exe;
	wire csr_wr_en_vstart_exe;
	wire csr_wr_en_vxrm_exe;
	wire csr_wr_en_vxsat_exe;
	wire [10:0] csr_wr_data_vsstatus_exe;
	wire [8:0] csr_wr_data_vtype_exe;
	wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] csr_wr_data_vl_exe;
	wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] csr_wr_data_vstart_exe;
	wire [1:0] csr_wr_data_vxrm_exe;
	wire [0:0] csr_wr_data_vxsat_exe;
	wire [10:0] vsstatus_id;
	wire [8:0] vtype_id;
	wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vl_id;
	wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vlenb_id;
	wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vstart_id;
	wire [1:0] vxrm_id;
	wire [0:0] vxsat_id;
	wire [2:0] vcsr_id;
	assign riscv_v_stall = stall;
	assign vec_wr_vsstatus_id = 1'b0;
	assign vec_wr_vtype_id = 1'b0;
	assign vec_wr_vl_id = 1'b0;
	assign vec_wr_vstart_id = 1'b0;
	assign vec_wr_vxrm_id = 1'b0;
	assign vec_wr_vxsat_id = 1'b0;
	riscv_v_ctrl v_ctrl(
		.clk(clk),
		.rst(rst),
		.clear_pipe(clear_pipe),
		.riscv_stall(riscv_stall),
		.stall(stall),
		.flush(flush),
		.instruction_id(instruction_id),
		.imm_exe(imm_exe),
		.vs1_id(rf_rd_addr_srca_id),
		.vs1_exe(rf_rd_addr_srca_exe),
		.vs2_id(rf_rd_addr_srcb_id),
		.vs2_exe(rf_rd_addr_srcb_exe),
		.vd_id(rf_wr_addr_id),
		.is_scalar_op_exe(is_scalar_op_exe),
		.is_vector_vector_op_exe(is_vector_vector_op_exe),
		.is_scalar_vector_op_exe(is_scalar_vector_op_exe),
		.is_scalar_imm_op_exe(is_scalar_imm_op_exe),
		.is_scalar_int_op_exe(is_scalar_int_op_exe),
		.is_scalar_fp_op_exe(is_scalar_fp_op_exe),
		.is_i2v_exe(is_i2v_exe),
		.is_v2i_exe(is_v2i_exe),
		.int_rf_wr_en_id(int_rf_wr_en_id),
		.is_and_exe(is_and_exe),
		.is_or_exe(is_or_exe),
		.is_xor_exe(is_xor_exe),
		.is_negate_srca_exe(is_negate_srca_exe),
		.is_negate_srcb_exe(is_negate_srcb_exe),
		.is_negate_result_exe(is_negate_result_exe),
		.is_mask_exe(is_mask_exe),
		.use_mask_exe(use_mask_exe),
		.is_shift_exe(is_shift_exe),
		.is_left_exe(is_left_exe),
		.is_arith_exe(is_arith_exe),
		.is_reduct_exe(is_reduct_exe),
		.is_add_exe(is_add_exe),
		.is_sub_exe(is_sub_exe),
		.is_mul_exe(is_mul_exe),
		.is_zero_ext_exe(is_zero_ext_exe),
		.is_sign_ext_exe(is_sign_ext_exe),
		.is_compare_exe(is_compare_exe),
		.is_set_equal_exe(is_set_equal_exe),
		.is_set_nequal_exe(is_set_nequal_exe),
		.is_set_less_exe(is_set_less_exe),
		.is_set_greater_exe(is_set_greater_exe),
		.is_max_exe(is_max_exe),
		.is_min_exe(is_min_exe),
		.is_high_exe(is_high_exe),
		.is_signed_exe(is_signed_exe),
		.use_carry_exe(use_carry_exe)
	);
	assign vec_data_in_exe = alu_result_exe[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127-:((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) ? ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127)) + 1)];
	riscv_v_csr_ctrl v_csr_ctrl(
		.clk(clk),
		.rst(rst),
		.stall(stall),
		.flush(flush),
		.ext_data_in_exe(ext_data_in_exe),
		.ext_wr_vsstatus_id(ext_wr_vsstatus_id),
		.ext_wr_vtype_id(ext_wr_vtype_id),
		.ext_wr_vl_id(ext_wr_vl_id),
		.ext_wr_vstart_id(ext_wr_vstart_id),
		.ext_wr_vxrm_id(ext_wr_vxrm_id),
		.ext_wr_vxsat_id(ext_wr_vxsat_id),
		.vec_data_in_exe(vec_data_in_exe),
		.vec_wr_vsstatus_id(vec_wr_vsstatus_id),
		.vec_wr_vtype_id(vec_wr_vtype_id),
		.vec_wr_vl_id(vec_wr_vl_id),
		.vec_wr_vstart_id(vec_wr_vstart_id),
		.vec_wr_vxrm_id(vec_wr_vxrm_id),
		.vec_wr_vxsat_id(vec_wr_vxsat_id),
		.csr_wr_en_vsstatus_exe(csr_wr_en_vsstatus_exe),
		.csr_wr_en_vtype_exe(csr_wr_en_vtype_exe),
		.csr_wr_en_vl_exe(csr_wr_en_vl_exe),
		.csr_wr_en_vstart_exe(csr_wr_en_vstart_exe),
		.csr_wr_en_vxrm_exe(csr_wr_en_vxrm_exe),
		.csr_wr_en_vxsat_exe(csr_wr_en_vxsat_exe),
		.csr_wr_data_vsstatus_exe(csr_wr_data_vsstatus_exe),
		.csr_wr_data_vtype_exe(csr_wr_data_vtype_exe),
		.csr_wr_data_vl_exe(csr_wr_data_vl_exe),
		.csr_wr_data_vstart_exe(csr_wr_data_vstart_exe),
		.csr_wr_data_vxrm_exe(csr_wr_data_vxrm_exe),
		.csr_wr_data_vxsat_exe(csr_wr_data_vxsat_exe),
		.vsstatus_id(vsstatus_id),
		.vtype_id(vtype_id),
		.vl_id(vl_id),
		.vstart_id(vstart_id),
		.vxrm_id(vxrm_id),
		.vxsat_id(vxsat_id),
		.vsstatus_exe(vsstatus_exe),
		.vtype_exe(vtype_exe),
		.vl_exe(vl_exe),
		.vstart_exe(vstart_exe),
		.vxrm_exe(vxrm_exe),
		.vxsat_exe(vxsat_exe)
	);
	riscv_v_csr v_csr(
		.clk(clk),
		.rst(rst),
		.vsstatus_data_in(csr_wr_data_vsstatus_exe),
		.vsstatus_wr_en(csr_wr_en_vsstatus_exe),
		.vsstatus_data_out(vsstatus_id),
		.vtype_data_in(csr_wr_data_vtype_exe),
		.vtype_wr_en(csr_wr_en_vtype_exe),
		.vtype_data_out(vtype_id),
		.vl_data_in(csr_wr_data_vl_exe),
		.vl_wr_en(csr_wr_en_vl_exe),
		.vl_data_out(vl_id),
		.vlenb_data_out(vlenb_id),
		.vstart_data_in(csr_wr_data_vstart_exe),
		.vstart_wr_en(csr_wr_en_vstart_exe),
		.vstart_data_out(vstart_id),
		.vxrm_data_in(csr_wr_data_vxrm_exe),
		.vxrm_wr_en(csr_wr_en_vxrm_exe),
		.vxrm_data_out(vxrm_id),
		.vxsat_data_in(csr_wr_data_vxsat_exe),
		.vxsat_wr_en(csr_wr_en_vxsat_exe),
		.vxsat_data_out(vxsat_id),
		.vcsr_data_out(vcsr_id)
	);
	assign rf_wr_data_exe = alu_result_exe[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127-:((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) ? ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127)) + 1)];
	assign rf_wr_en_exe = alu_result_exe[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA];
	riscv_v_rf_ctrl v_rf_ctrl(
		.clk(clk),
		.rst(rst),
		.stall(stall),
		.flush(flush),
		.rf_wr_addr_id(rf_wr_addr_id),
		.rf_wr_addr_exe(rf_wr_addr_exe),
		.rf_wr_addr_mem(rf_wr_addr_mem),
		.rf_wr_addr_wb(rf_wr_addr_wb),
		.rf_wr_en_exe(rf_wr_en_exe),
		.rf_wr_en_mem(rf_wr_en_mem),
		.rf_wr_en_wb(rf_wr_en_wb),
		.rf_wr_data_exe(rf_wr_data_exe),
		.rf_wr_data_mem(rf_wr_data_mem),
		.rf_wr_data_wb(rf_wr_data_wb),
		.rf_rd_data_srca_id(rf_rd_data_srca_id),
		.rf_rd_data_srca_exe(rf_rd_data_srca_exe),
		.rf_rd_data_srcb_id(rf_rd_data_srcb_id),
		.rf_rd_data_srcb_exe(rf_rd_data_srcb_exe),
		.mask_id(mask_id),
		.mask_exe(mask_exe),
		.mask_merge_id(mask_merge_id),
		.mask_merge_exe(mask_merge_exe),
		.int_rf_rd_data_id(int_rf_rd_data_id),
		.int_rf_rd_data_exe(int_rf_rd_data_exe),
		.int_rf_wr_data_exe(int_rf_wr_data_exe),
		.int_rf_wr_data_wb(int_rf_wr_data_wb),
		.int_rf_wr_en_id(int_rf_wr_en_id),
		.int_rf_wr_en_wb(int_rf_wr_en_wb)
	);
	localparam [0:0] riscv_v_pkg_RISCV_V_RF_RD_ASYNC = 1'b1;
	localparam [0:0] riscv_v_pkg_RISCV_V_RF_REG_INPUTS = 1'b0;
	localparam [0:0] riscv_v_pkg_RISCV_V_RF_USE_BYPASS = 1'b1;
	riscv_v_rf  v_rf(
		.clk(clk),
		.wr_addr(rf_wr_addr_wb),
		.mask_merge_addr(rf_wr_addr_id),
		.rd_addr_A(rf_rd_addr_srca_id),
		.rd_addr_B(rf_rd_addr_srcb_id),
		.data_in(rf_wr_data_wb),
		.wr_en(rf_wr_en_wb),
		.data_out_A(rf_rd_data_srca_id),
		.data_out_B(rf_rd_data_srcb_id),
		.mask(mask_id),
		.mask_merge(mask_merge_id),
		.syn_addr(syn_addr),
		.syn_data(syn_data)
	);
endmodule
