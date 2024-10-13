module riscv_v (
	clk,
	rst,
	clear_pipe,
	riscv_stall,
	riscv_v_stall,
	instruction_id,
	opcode_id,
	int_rf_rd_data_id,
	int_rf_wr_data_wb,
	int_rf_wr_en_wb,
	ext_data_in_exe,
	ext_wr_vsstatus_id,
	ext_wr_vtype_id,
	ext_wr_vl_id,
	ext_wr_vstart_id,
	ext_wr_vxrm_id,
	ext_wr_vxsat_id,
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
	input wire [5:0] opcode_id;
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
	input wire [31:0] ext_data_in_exe;
	input wire ext_wr_vsstatus_id;
	input wire ext_wr_vtype_id;
	input wire ext_wr_vl_id;
	input wire ext_wr_vstart_id;
	input wire ext_wr_vxrm_id;
	input wire ext_wr_vxsat_id;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_RF_NUM_REGS = 32;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_RF_ADDR_WIDTH = 5;
	input wire [4:0] syn_addr;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	output wire [127:0] syn_data;
	wire [31:0] int_rf_rd_data_exe;
	wire [31:0] int_rf_wr_data_exe;
	wire [127:0] rf_rd_data_srca_exe;
	wire [127:0] rf_rd_data_srcb_exe;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_exe;
	wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_merge_exe;
	wire [(128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] alu_result_exe;
	wire is_scalar_op_exe;
	wire is_vector_vector_op_exe;
	wire is_scalar_vector_op_exe;
	wire is_scalar_imm_op_exe;
	wire is_scalar_int_op_exe;
	wire is_scalar_fp_op_exe;
	wire is_i2v_exe;
	wire is_v2i_exe;
	wire is_and_exe;
	wire is_or_exe;
	wire is_xor_exe;
	wire is_negate_srca_exe;
	wire is_negate_srcb_exe;
	wire is_negate_result_exe;
	wire is_mask_exe;
	wire use_mask_exe;
	wire is_shift_exe;
	wire is_left_exe;
	wire is_arith_exe;
	wire is_reduct_exe;
	wire is_add_exe;
	wire is_sub_exe;
	wire is_mul_exe;
	wire is_zero_ext_exe;
	wire is_sign_ext_exe;
	wire is_compare_exe;
	wire is_set_equal_exe;
	wire is_set_nequal_exe;
	wire is_set_less_exe;
	wire is_set_greater_exe;
	wire is_max_exe;
	wire is_min_exe;
	wire is_high_exe;
	wire is_signed_exe;
	wire use_carry_exe;
	localparam riscv_v_pkg_RISCV_V_IMM_WIDTH = 5;
	wire [4:0] imm_exe;
	wire [10:0] vsstatus_exe;
	wire [8:0] vtype_exe;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_MAX_LMUL = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_MAX_VLEN = riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG * riscv_v_pkg_RISCV_V_MAX_LMUL;
	wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vl_exe;
	wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vlenb_exe;
	wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vstart_exe;
	wire [1:0] vxrm_exe;
	wire [0:0] vxsat_exe;
	wire [2:0] vcsr_exe;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] rf_wr_en_mem;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] rf_wr_en_wb;
	wire [4:0] rf_rd_addr_srca_exe;
	wire [4:0] rf_rd_addr_srcb_exe;
	wire [4:0] rf_wr_addr_exe;
	wire [4:0] rf_wr_addr_mem;
	wire [4:0] rf_wr_addr_wb;
	wire [127:0] rf_wr_data_mem;
	wire [127:0] rf_wr_data_wb;
	wire [5:0] opcode_exe;
	wire stall_inst;
	assign stall_inst = riscv_stall || riscv_v_stall;
	localparam riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY = 1;
	riscv_v_stage_21BCA #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) riscv_v_opcode_inst_stage(
		.clk(clk),
		.rst(rst),
		.en(~stall_inst),
		.flush(clear_pipe),
		.rst_val(6'bxxxxxx),
		.flush_val(6'bxxxxxx),
		.data_in(opcode_id),
		.data_out(opcode_exe)
	);
	riscv_v_decode v_decode(
		.clk(clk),
		.rst(rst),
		.clear_pipe(clear_pipe),
		.riscv_stall(riscv_stall),
		.riscv_v_stall(riscv_v_stall),
		.instruction_id(instruction_id),
		.int_rf_rd_data_id(int_rf_rd_data_id),
		.int_rf_wr_data_wb(int_rf_wr_data_wb),
		.int_rf_wr_en_wb(int_rf_wr_en_wb),
		.rf_wr_en_mem(rf_wr_en_mem),
		.rf_wr_en_wb(rf_wr_en_wb),
		.rf_rd_addr_srca_exe(rf_rd_addr_srca_exe),
		.rf_rd_addr_srcb_exe(rf_rd_addr_srcb_exe),
		.rf_wr_addr_exe(rf_wr_addr_exe),
		.rf_wr_addr_mem(rf_wr_addr_mem),
		.rf_wr_addr_wb(rf_wr_addr_wb),
		.rf_wr_data_mem(rf_wr_data_mem),
		.rf_wr_data_wb(rf_wr_data_wb),
		.imm_exe(imm_exe),
		.int_rf_rd_data_exe(int_rf_rd_data_exe),
		.int_rf_wr_data_exe(int_rf_wr_data_exe),
		.rf_rd_data_srca_exe(rf_rd_data_srca_exe),
		.rf_rd_data_srcb_exe(rf_rd_data_srcb_exe),
		.mask_exe(mask_exe),
		.mask_merge_exe(mask_merge_exe),
		.alu_result_exe(alu_result_exe),
		.is_scalar_op_exe(is_scalar_op_exe),
		.is_vector_vector_op_exe(is_vector_vector_op_exe),
		.is_scalar_vector_op_exe(is_scalar_vector_op_exe),
		.is_scalar_imm_op_exe(is_scalar_imm_op_exe),
		.is_scalar_int_op_exe(is_scalar_int_op_exe),
		.is_scalar_fp_op_exe(is_scalar_fp_op_exe),
		.is_i2v_exe(is_i2v_exe),
		.is_v2i_exe(is_v2i_exe),
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
		.use_carry_exe(use_carry_exe),
		.ext_data_in_exe(ext_data_in_exe),
		.ext_wr_vsstatus_id(ext_wr_vsstatus_id),
		.ext_wr_vtype_id(ext_wr_vtype_id),
		.ext_wr_vl_id(ext_wr_vl_id),
		.ext_wr_vstart_id(ext_wr_vstart_id),
		.ext_wr_vxrm_id(ext_wr_vxrm_id),
		.ext_wr_vxsat_id(ext_wr_vxsat_id),
		.vsstatus_exe(vsstatus_exe),
		.vtype_exe(vtype_exe),
		.vl_exe(vl_exe),
		.vlenb_exe(vlenb_exe),
		.vstart_exe(vstart_exe),
		.vxrm_exe(vxrm_exe),
		.vxsat_exe(vxsat_exe),
		.vcsr_exe(vcsr_exe),
		.syn_addr(syn_addr),
		.syn_data(syn_data)
	);
	riscv_v_execute v_execute(
		.clk(clk),
		.rst(rst),
		.opcode_exe(opcode_exe),
		.int_data_exe(int_rf_rd_data_exe),
		.imm_exe(imm_exe),
		.int_data_result_exe(int_rf_wr_data_exe),
		.srca_exe(rf_rd_data_srca_exe),
		.srcb_exe(rf_rd_data_srcb_exe),
		.mask_exe(mask_exe),
		.mask_merge_exe(mask_merge_exe),
		.alu_result_exe(alu_result_exe),
		.rf_wr_en_mem(rf_wr_en_mem),
		.rf_wr_en_wb(rf_wr_en_wb),
		.rf_rd_addr_srca_exe(rf_rd_addr_srca_exe),
		.rf_rd_addr_srcb_exe(rf_rd_addr_srcb_exe),
		.rf_wr_addr_exe(rf_wr_addr_exe),
		.rf_wr_addr_mem(rf_wr_addr_mem),
		.rf_wr_addr_wb(rf_wr_addr_wb),
		.rf_wr_data_mem(rf_wr_data_mem),
		.rf_wr_data_wb(rf_wr_data_wb),
		.is_scalar_op_exe(is_scalar_op_exe),
		.is_vector_vector_op_exe(is_vector_vector_op_exe),
		.is_scalar_vector_op_exe(is_scalar_vector_op_exe),
		.is_scalar_imm_op_exe(is_scalar_imm_op_exe),
		.is_scalar_int_op_exe(is_scalar_int_op_exe),
		.is_scalar_fp_op_exe(is_scalar_fp_op_exe),
		.is_i2v_exe(is_i2v_exe),
		.is_v2i_exe(is_v2i_exe),
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
		.use_carry_exe(use_carry_exe),
		.vtype_exe(vtype_exe),
		.vl_exe(vl_exe),
		.vstart_exe(vstart_exe)
	);
	riscv_v_memory v_memory(
		.clk(clk),
		.rst(rst)
	);
endmodule
