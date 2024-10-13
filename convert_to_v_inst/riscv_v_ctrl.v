module riscv_v_ctrl (
	clk,
	rst,
	clear_pipe,
	riscv_stall,
	stall,
	flush,
	instruction_id,
	vs1_id,
	vs1_exe,
	vs2_id,
	vs2_exe,
	vd_id,
	imm_exe,
	is_scalar_op_exe,
	is_vector_vector_op_exe,
	is_scalar_vector_op_exe,
	is_scalar_imm_op_exe,
	is_scalar_int_op_exe,
	is_scalar_fp_op_exe,
	is_i2v_exe,
	is_v2i_exe,
	int_rf_wr_en_id,
	is_and_exe,
	is_or_exe,
	is_xor_exe,
	is_negate_srca_exe,
	is_negate_srcb_exe,
	is_negate_result_exe,
	use_mask_exe,
	is_mask_exe,
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
	use_carry_exe
);
	input wire clk;
	input wire rst;
	input wire clear_pipe;
	input wire riscv_stall;
	output wire stall;
	output wire flush;
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
	output wire [4:0] vs1_id;
	output wire [4:0] vs1_exe;
	output wire [4:0] vs2_id;
	output wire [4:0] vs2_exe;
	output wire [4:0] vd_id;
	localparam riscv_v_pkg_RISCV_V_IMM_WIDTH = 5;
	output wire [4:0] imm_exe;
	output wire is_scalar_op_exe;
	output wire is_vector_vector_op_exe;
	output wire is_scalar_vector_op_exe;
	output wire is_scalar_imm_op_exe;
	output wire is_scalar_int_op_exe;
	output wire is_scalar_fp_op_exe;
	output wire is_i2v_exe;
	output wire is_v2i_exe;
	output wire int_rf_wr_en_id;
	output wire is_and_exe;
	output wire is_or_exe;
	output wire is_xor_exe;
	output wire is_negate_srca_exe;
	output wire is_negate_srcb_exe;
	output wire is_negate_result_exe;
	output wire use_mask_exe;
	output wire is_mask_exe;
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
	wire en_stage;
	wire [6:0] riscv_v_op_code_id;
	wire [2:0] riscv_v_funct3_id;
	wire [5:0] riscv_v_funct6_id;
	wire [((((((riscv_pkg_RISCV_INSTR_FUNCT6_WIDTH + riscv_pkg_RISCV_INSTR_MASK_WIDTH) + riscv_pkg_RISCV_INSTR_RS_WIDTH) + riscv_pkg_RISCV_INSTR_RS_WIDTH) + riscv_pkg_RISCV_INSTR_FUNCT3_WIDTH) + riscv_pkg_RISCV_INSTR_RD_WIDTH) + riscv_pkg_RISCV_INSTR_OP_WIDTH) - 1:0] riscv_vector_instr_id;
	wire vm_id;
	wire is_vector_op_id;
	wire is_scalar_op_id;
	wire is_vector_vector_op_id;
	wire is_scalar_vector_op_id;
	wire is_scalar_imm_op_id;
	wire is_scalar_int_op_id;
	wire is_scalar_fp_op_id;
	wire funct3_is_OPIVV_id;
	wire funct3_is_OPIVX_id;
	wire funct3_is_OPIVI_id;
	wire funct3_is_OPMVV_id;
	wire funct3_is_OPMVX_id;
	wire funct3_is_OPFVV_id;
	wire funct3_is_OPFVF_id;
	wire funct3_is_OPI_id;
	wire funct3_is_OPM_id;
	wire funct3_is_OPIVV_OPIVX_id;
	wire funct3_is_OPIVX_OPIVI_id;
	wire is_i2v_id;
	wire is_v2i_id;
	wire is_and_id;
	wire is_or_id;
	wire is_xor_id;
	wire is_negate_srca_id;
	wire is_negate_srcb_id;
	wire is_negate_result_id;
	wire use_mask_id;
	wire is_mask_id;
	wire is_shift_id;
	wire is_left_id;
	wire is_arith_id;
	wire is_reduct_id;
	wire is_add_id;
	wire is_sub_id;
	wire is_mul_id;
	wire is_zero_ext_id;
	wire is_sign_ext_id;
	wire is_set_equal_id;
	wire is_set_nequal_id;
	wire is_set_less_id;
	wire is_set_greater_id;
	wire is_compare_id;
	wire is_max_id;
	wire is_min_id;
	wire is_high_id;
	wire is_signed_id;
	wire use_carry_id;
	wire [4:0] imm_id;
	wire riscv_v_stall;
	assign riscv_v_stall = 1'b0;
	assign stall = riscv_v_stall || riscv_stall;
	assign en_stage = ~stall;
	assign flush = clear_pipe;
	assign riscv_vector_instr_id = instruction_id[((((((riscv_pkg_RISCV_INSTR_FUNCT6_WIDTH + riscv_pkg_RISCV_INSTR_MASK_WIDTH) + riscv_pkg_RISCV_INSTR_RS_WIDTH) + riscv_pkg_RISCV_INSTR_RS_WIDTH) + riscv_pkg_RISCV_INSTR_FUNCT3_WIDTH) + riscv_pkg_RISCV_INSTR_RD_WIDTH) + riscv_pkg_RISCV_INSTR_OP_WIDTH) - 1-:(((((riscv_pkg_RISCV_INSTR_FUNCT6_WIDTH + riscv_pkg_RISCV_INSTR_MASK_WIDTH) + riscv_pkg_RISCV_INSTR_RS_WIDTH) + riscv_pkg_RISCV_INSTR_RS_WIDTH) + riscv_pkg_RISCV_INSTR_FUNCT3_WIDTH) + riscv_pkg_RISCV_INSTR_RD_WIDTH) + riscv_pkg_RISCV_INSTR_OP_WIDTH];
	assign riscv_v_op_code_id = riscv_vector_instr_id[6-:riscv_pkg_RISCV_INSTR_OP_WIDTH];
	function automatic [2:0] sv2v_cast_3;
		input reg [2:0] inp;
		sv2v_cast_3 = inp;
	endfunction
	assign riscv_v_funct3_id = sv2v_cast_3(riscv_vector_instr_id[14-:3]);
	assign riscv_v_funct6_id = riscv_vector_instr_id[31-:6];
	assign vs1_id = riscv_vector_instr_id[19-:5];
	assign vs2_id = riscv_vector_instr_id[24-:5];
	assign vd_id = riscv_vector_instr_id[11-:5];
	assign imm_id = riscv_vector_instr_id[19-:5];
	assign vm_id = riscv_vector_instr_id[25-:1];
	localparam [6:0] riscv_v_pkg_RISCV_V_TYPE_OP_CODE = 7'b1010111;
	function automatic riscv_v_pkg_f_is_vector_op;
		input reg [6:0] opcode;
		riscv_v_pkg_f_is_vector_op = opcode == riscv_v_pkg_RISCV_V_TYPE_OP_CODE;
	endfunction
	assign is_vector_op_id = riscv_v_pkg_f_is_vector_op(riscv_v_op_code_id);
	function automatic riscv_v_pkg_f_is_vector_vector_op;
		input reg [2:0] funct3;
		riscv_v_pkg_f_is_vector_vector_op = ~funct3[2] && ~(&funct3[1:0]);
	endfunction
	assign is_vector_vector_op_id = riscv_v_pkg_f_is_vector_vector_op(riscv_v_funct3_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_is_scalar_fp_op;
		input reg [2:0] funct3;
		riscv_v_pkg_f_is_scalar_fp_op = funct3 == 3'b101;
	endfunction
	function automatic riscv_v_pkg_f_is_scalar_imm_op;
		input reg [2:0] funct3;
		riscv_v_pkg_f_is_scalar_imm_op = funct3 == 3'b011;
	endfunction
	function automatic riscv_v_pkg_f_is_scalar_int_op;
		input reg [2:0] funct3;
		riscv_v_pkg_f_is_scalar_int_op = ((funct3 == 3'b100) || (funct3 == 3'b110)) || (funct3 == 3'b111);
	endfunction
	function automatic riscv_v_pkg_f_is_scalar_vector_op;
		input reg [2:0] funct3;
		riscv_v_pkg_f_is_scalar_vector_op = 1'b0;
	endfunction
	function automatic riscv_v_pkg_f_is_scalar_op;
		input reg [2:0] funct3;
		riscv_v_pkg_f_is_scalar_op = ((riscv_v_pkg_f_is_scalar_vector_op(funct3) || riscv_v_pkg_f_is_scalar_imm_op(funct3)) || riscv_v_pkg_f_is_scalar_int_op(funct3)) || riscv_v_pkg_f_is_scalar_fp_op(funct3);
	endfunction
	assign is_scalar_op_id = riscv_v_pkg_f_is_scalar_op(riscv_v_funct3_id) && is_vector_op_id;
	assign is_scalar_vector_op_id = riscv_v_pkg_f_is_scalar_vector_op(riscv_v_funct3_id) && is_vector_op_id;
	assign is_scalar_imm_op_id = riscv_v_pkg_f_is_scalar_imm_op(riscv_v_funct3_id) && is_vector_op_id;
	assign is_scalar_int_op_id = riscv_v_pkg_f_is_scalar_int_op(riscv_v_funct3_id) && is_vector_op_id;
	assign is_scalar_fp_op_id = riscv_v_pkg_f_is_scalar_fp_op(riscv_v_funct3_id) && is_vector_op_id;
	assign funct3_is_OPIVV_id = (riscv_v_funct3_id == 3'b000) && is_vector_op_id;
	assign funct3_is_OPIVX_id = (riscv_v_funct3_id == 3'b100) && is_vector_op_id;
	assign funct3_is_OPIVI_id = (riscv_v_funct3_id == 3'b011) && is_vector_op_id;
	assign funct3_is_OPMVV_id = (riscv_v_funct3_id == 3'b010) && is_vector_op_id;
	assign funct3_is_OPMVX_id = (riscv_v_funct3_id == 3'b110) && is_vector_op_id;
	assign funct3_is_OPFVV_id = (riscv_v_funct3_id == 3'b001) && is_vector_op_id;
	assign funct3_is_OPFVF_id = (riscv_v_funct3_id == 3'b101) && is_vector_op_id;
	assign funct3_is_OPI_id = (funct3_is_OPIVV_id || funct3_is_OPIVX_id) || funct3_is_OPIVI_id;
	assign funct3_is_OPM_id = funct3_is_OPMVV_id || funct3_is_OPMVX_id;
	assign funct3_is_OPIVV_OPIVX_id = funct3_is_OPIVV_id || funct3_is_OPIVX_id;
	assign funct3_is_OPIVX_OPIVI_id = funct3_is_OPIVX_id || funct3_is_OPIVI_id;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VRXUNARY0 = 6'b010000;
	function automatic riscv_v_pkg_f_is_i2v;
		input reg [5:0] funct6;
		input reg funct3_is_OPMVX;
		input reg [4:0] vs2;
		riscv_v_pkg_f_is_i2v = ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VRXUNARY0) && funct3_is_OPMVX) && (vs2 == 0);
	endfunction
	assign is_i2v_id = riscv_v_pkg_f_is_i2v(riscv_v_funct6_id, funct3_is_OPMVX_id, vs2_id) && is_vector_op_id;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VWXUNARY0 = 6'b010000;
	function automatic riscv_v_pkg_f_is_v2i;
		input reg [5:0] funct6;
		input reg funct3_is_OPMVV;
		input reg [4:0] vs1;
		riscv_v_pkg_f_is_v2i = ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VWXUNARY0) && funct3_is_OPMVV) && (vs1 == 0);
	endfunction
	assign is_v2i_id = riscv_v_pkg_f_is_v2i(riscv_v_funct6_id, funct3_is_OPMVV_id, vs1_id) && is_vector_op_id;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VAND = 6'b001001;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMAND = 6'b011001;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMANDN = 6'b011000;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMNAND = 6'b011101;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VREDAND = 6'b000001;
	function automatic riscv_v_pkg_f_is_and;
		input reg [5:0] funct6;
		input reg funct3_is_OPMVV;
		input reg funct3_is_OPI;
		reg is_and;
		begin
			is_and = 1'b0;
			is_and = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMAND) && funct3_is_OPMVV;
			is_and = is_and | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMNAND) && funct3_is_OPMVV);
			is_and = is_and | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMANDN) && funct3_is_OPMVV);
			is_and = is_and | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VAND) && funct3_is_OPI);
			is_and = is_and | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDAND) && funct3_is_OPMVV);
			riscv_v_pkg_f_is_and = is_and;
		end
	endfunction
	assign is_and_id = riscv_v_pkg_f_is_and(riscv_v_funct6_id, funct3_is_OPMVV_id, funct3_is_OPI_id) && is_vector_op_id;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMNOR = 6'b011110;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMOR = 6'b011010;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMORN = 6'b011100;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VOR = 6'b001010;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VREDOR = 6'b000010;
	function automatic riscv_v_pkg_f_is_or;
		input reg [5:0] funct6;
		input reg funct3_is_OPMVV;
		input reg funct3_is_OPI;
		reg is_or;
		begin
			is_or = 1'b0;
			is_or = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMOR) && funct3_is_OPMVV;
			is_or = is_or | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMNOR) && funct3_is_OPMVV);
			is_or = is_or | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMORN) && funct3_is_OPMVV);
			is_or = is_or | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VOR) && funct3_is_OPI);
			is_or = is_or | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDOR) && funct3_is_OPMVV);
			riscv_v_pkg_f_is_or = is_or;
		end
	endfunction
	assign is_or_id = riscv_v_pkg_f_is_or(riscv_v_funct6_id, funct3_is_OPMVV_id, funct3_is_OPI_id) && is_vector_op_id;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMXNOR = 6'b011111;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMXOR = 6'b011011;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VREDXOR = 6'b000011;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VXOR = 6'b001011;
	function automatic riscv_v_pkg_f_is_xor;
		input reg [5:0] funct6;
		input reg funct3_is_OPMVV;
		input reg funct3_is_OPI;
		reg is_xor;
		begin
			is_xor = 1'b0;
			is_xor = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMXOR) && funct3_is_OPMVV;
			is_xor = is_xor | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMXNOR) && funct3_is_OPMVV);
			is_xor = is_xor | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VXOR) && funct3_is_OPI);
			is_xor = is_xor | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDXOR) && funct3_is_OPMVV);
			riscv_v_pkg_f_is_xor = is_xor;
		end
	endfunction
	assign is_xor_id = riscv_v_pkg_f_is_xor(riscv_v_funct6_id, funct3_is_OPMVV_id, funct3_is_OPI_id) && is_vector_op_id;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMSEQ = 6'b011000;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMSGT = 6'b011111;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMSGTU = 6'b011110;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMSLE = 6'b011101;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMSLEU = 6'b011100;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMSLT = 6'b011011;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMSLTU = 6'b011010;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMSNE = 6'b011001;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VSBC = 6'b010010;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VSUB = 6'b000010;
	function automatic riscv_v_pkg_f_is_negate_srca;
		input reg [5:0] funct6;
		input reg funct3_is_OPMVV;
		input reg funct3_is_OPI;
		input reg funct3_is_OPIVV_OPIVX;
		input reg funct3_is_OPIVX_OPIVI;
		reg is_negate_srca;
		begin
			is_negate_srca = 1'b0;
			is_negate_srca = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMANDN) && funct3_is_OPMVV;
			is_negate_srca = is_negate_srca | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMORN) && funct3_is_OPMVV);
			is_negate_srca = is_negate_srca | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSEQ) && funct3_is_OPI);
			is_negate_srca = is_negate_srca | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSNE) && funct3_is_OPI);
			is_negate_srca = is_negate_srca | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLTU) && funct3_is_OPIVV_OPIVX);
			is_negate_srca = is_negate_srca | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLT) && funct3_is_OPIVV_OPIVX);
			is_negate_srca = is_negate_srca | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLE) && funct3_is_OPI);
			is_negate_srca = is_negate_srca | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLEU) && funct3_is_OPI);
			is_negate_srca = is_negate_srca | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSGT) && funct3_is_OPIVX_OPIVI);
			is_negate_srca = is_negate_srca | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSGTU) && funct3_is_OPIVX_OPIVI);
			is_negate_srca = is_negate_srca | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VSUB) && funct3_is_OPIVV_OPIVX);
			is_negate_srca = is_negate_srca | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VSBC) && funct3_is_OPIVV_OPIVX);
			riscv_v_pkg_f_is_negate_srca = is_negate_srca;
		end
	endfunction
	assign is_negate_srca_id = riscv_v_pkg_f_is_negate_srca(riscv_v_funct6_id, funct3_is_OPMVV_id, funct3_is_OPI_id, funct3_is_OPIVV_OPIVX_id, funct3_is_OPIVX_OPIVI_id) && is_vector_op_id;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMAX = 6'b000111;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMAXU = 6'b000110;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMIN = 6'b000101;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMINU = 6'b000100;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VREDMAX = 6'b000111;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VREDMAXU = 6'b000110;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VREDMIN = 6'b000101;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VREDMINU = 6'b000100;
	function automatic riscv_v_pkg_f_is_negate_srcb;
		input reg [5:0] funct6;
		input reg funct3_is_OPMVV;
		input reg funct3_is_OPMVX;
		input reg funct3_is_OPIVV_OPIVX;
		reg is_negate_srcb;
		begin
			is_negate_srcb = 1'b0;
			is_negate_srcb = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMIN) && funct3_is_OPIVV_OPIVX;
			is_negate_srcb = is_negate_srcb | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMINU) && funct3_is_OPIVV_OPIVX);
			is_negate_srcb = is_negate_srcb | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMIN) && (funct3_is_OPMVV | funct3_is_OPMVX));
			is_negate_srcb = is_negate_srcb | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMINU) && (funct3_is_OPMVV | funct3_is_OPMVX));
			is_negate_srcb = is_negate_srcb | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMAX) && funct3_is_OPIVV_OPIVX);
			is_negate_srcb = is_negate_srcb | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMAXU) && funct3_is_OPIVV_OPIVX);
			is_negate_srcb = is_negate_srcb | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMAX) && (funct3_is_OPMVV | funct3_is_OPMVX));
			is_negate_srcb = is_negate_srcb | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMAXU) && (funct3_is_OPMVV | funct3_is_OPMVX));
			riscv_v_pkg_f_is_negate_srcb = is_negate_srcb;
		end
	endfunction
	assign is_negate_srcb_id = riscv_v_pkg_f_is_negate_srcb(riscv_v_funct6_id, funct3_is_OPMVV_id, funct3_is_OPMVX_id, funct3_is_OPIVV_OPIVX_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_is_negate_result;
		input reg [5:0] funct6;
		input reg funct3_is_OPMVV;
		reg is_negate_result;
		begin
			is_negate_result = 1'b0;
			is_negate_result = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMNAND) && funct3_is_OPMVV;
			is_negate_result = is_negate_result | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMNOR) && funct3_is_OPMVV);
			is_negate_result = is_negate_result | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMXNOR) && funct3_is_OPMVV);
			riscv_v_pkg_f_is_negate_result = is_negate_result;
		end
	endfunction
	assign is_negate_result_id = riscv_v_pkg_f_is_negate_result(riscv_v_funct6_id, funct3_is_OPMVV_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_use_mask;
		input reg vm;
		input reg use_carry;
		riscv_v_pkg_f_use_mask = ~vm && ~use_carry;
	endfunction
	assign use_mask_id = riscv_v_pkg_f_use_mask(vm_id, use_carry_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_is_mask;
		input reg [5:0] funct6;
		input reg funct3_is_OPMVV;
		input reg funct3_is_OPI;
		input reg funct3_is_OPIVV_OPIVX;
		input reg funct3_is_OPIVX_OPIVI;
		reg is_mask;
		begin
			is_mask = 1'b0;
			is_mask = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMAND) && funct3_is_OPMVV;
			is_mask = is_mask | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMNAND) && funct3_is_OPMVV);
			is_mask = is_mask | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMANDN) && funct3_is_OPMVV);
			is_mask = is_mask | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMOR) && funct3_is_OPMVV);
			is_mask = is_mask | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMNOR) && funct3_is_OPMVV);
			is_mask = is_mask | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMORN) && funct3_is_OPMVV);
			is_mask = is_mask | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMXNOR) && funct3_is_OPMVV);
			is_mask = is_mask | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMXOR) && funct3_is_OPMVV);
			is_mask = is_mask | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSEQ) && funct3_is_OPI);
			is_mask = is_mask | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSNE) && funct3_is_OPI);
			is_mask = is_mask | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLE) && funct3_is_OPI);
			is_mask = is_mask | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLEU) && funct3_is_OPI);
			is_mask = is_mask | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLT) && funct3_is_OPIVV_OPIVX);
			is_mask = is_mask | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLTU) && funct3_is_OPIVV_OPIVX);
			is_mask = is_mask | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSGT) && funct3_is_OPIVX_OPIVI);
			is_mask = is_mask | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSGTU) && funct3_is_OPIVX_OPIVI);
			riscv_v_pkg_f_is_mask = is_mask;
		end
	endfunction
	assign is_mask_id = riscv_v_pkg_f_is_mask(riscv_v_funct6_id, funct3_is_OPMVV_id, funct3_is_OPI_id, funct3_is_OPIVV_OPIVX_id, funct3_is_OPIVX_OPIVI_id) && is_vector_op_id;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VSLL = 6'b100101;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VSRA = 6'b101001;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VSRL = 6'b101000;
	function automatic riscv_v_pkg_f_is_shift;
		input reg [5:0] funct6;
		input reg funct3_is_OPI;
		reg is_shift;
		begin
			is_shift = 1'b0;
			is_shift = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VSLL) && funct3_is_OPI;
			is_shift = is_shift | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VSRL) && funct3_is_OPI);
			is_shift = is_shift | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VSRA) && funct3_is_OPI);
			riscv_v_pkg_f_is_shift = is_shift;
		end
	endfunction
	assign is_shift_id = riscv_v_pkg_f_is_shift(riscv_v_funct6_id, funct3_is_OPI_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_is_left;
		input reg [5:0] funct6;
		input reg funct3_is_OPI;
		reg is_left;
		begin
			is_left = 1'b0;
			is_left = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VSLL) && funct3_is_OPI;
			riscv_v_pkg_f_is_left = is_left;
		end
	endfunction
	assign is_left_id = riscv_v_pkg_f_is_left(riscv_v_funct6_id, funct3_is_OPI_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_is_arith;
		input reg [5:0] funct6;
		input reg funct3_is_OPI;
		reg is_arith;
		begin
			is_arith = 1'b0;
			is_arith = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VSRA) && funct3_is_OPI;
			riscv_v_pkg_f_is_arith = is_arith;
		end
	endfunction
	assign is_arith_id = riscv_v_pkg_f_is_arith(riscv_v_funct6_id, funct3_is_OPI_id) && is_vector_op_id;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VREDSUM = 6'b000000;
	function automatic riscv_v_pkg_f_is_reduct;
		input reg [5:0] funct6;
		input reg funct3_is_OPMVV;
		input reg funct3_is_OPMVX;
		reg is_reduct;
		begin
			is_reduct = 1'b0;
			is_reduct = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDAND) && (funct3_is_OPMVV | funct3_is_OPMVX);
			is_reduct = is_reduct | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDOR) && (funct3_is_OPMVV | funct3_is_OPMVX));
			is_reduct = is_reduct | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDXOR) && (funct3_is_OPMVV | funct3_is_OPMVX));
			is_reduct = is_reduct | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDSUM) && (funct3_is_OPMVV | funct3_is_OPMVX));
			is_reduct = is_reduct | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMAX) && (funct3_is_OPMVV | funct3_is_OPMVX));
			is_reduct = is_reduct | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMAXU) && (funct3_is_OPMVV | funct3_is_OPMVX));
			is_reduct = is_reduct | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMIN) && (funct3_is_OPMVV | funct3_is_OPMVX));
			is_reduct = is_reduct | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMINU) && (funct3_is_OPMVV | funct3_is_OPMVX));
			riscv_v_pkg_f_is_reduct = is_reduct;
		end
	endfunction
	assign is_reduct_id = riscv_v_pkg_f_is_reduct(riscv_v_funct6_id, funct3_is_OPMVV_id, funct3_is_OPMVX_id) && is_vector_op_id;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VADC = 6'b010000;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VADD = 6'b000000;
	function automatic riscv_v_pkg_f_is_add;
		input reg [5:0] funct6;
		input reg funct3_is_OPI;
		input reg funct3_is_OPMVV;
		input reg funct3_is_OPMVX;
		reg is_add;
		begin
			is_add = 1'b0;
			is_add = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VADD) && funct3_is_OPI;
			is_add = is_add | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDSUM) && (funct3_is_OPMVV | funct3_is_OPMVX));
			is_add = is_add | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VADC) && funct3_is_OPI);
			riscv_v_pkg_f_is_add = is_add;
		end
	endfunction
	assign is_add_id = riscv_v_pkg_f_is_add(riscv_v_funct6_id, funct3_is_OPI_id, funct3_is_OPMVV_id, funct3_is_OPMVX_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_is_sub;
		input reg [5:0] funct6;
		input reg funct3_is_OPI;
		input reg funct3_is_OPMVV;
		input reg funct3_is_OPIVV_OPIVX;
		input reg funct3_is_OPIVX_OPIVI;
		input reg funct3_is_OPMVX;
		reg is_sub;
		begin
			is_sub = 1'b0;
			is_sub = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VSUB) && funct3_is_OPIVV_OPIVX;
			is_sub = is_sub | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VSBC) && funct3_is_OPIVV_OPIVX);
			is_sub = is_sub | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMIN) && funct3_is_OPIVV_OPIVX);
			is_sub = is_sub | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMINU) && funct3_is_OPIVV_OPIVX);
			is_sub = is_sub | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMIN) && (funct3_is_OPMVV | funct3_is_OPMVX));
			is_sub = is_sub | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMINU) && (funct3_is_OPMVV | funct3_is_OPMVX));
			is_sub = is_sub | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMAX) && funct3_is_OPIVV_OPIVX);
			is_sub = is_sub | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMAXU) && funct3_is_OPIVV_OPIVX);
			is_sub = is_sub | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMAX) && (funct3_is_OPMVV | funct3_is_OPMVX));
			is_sub = is_sub | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMAXU) && (funct3_is_OPMVV | funct3_is_OPMVX));
			is_sub = is_sub | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSEQ) && funct3_is_OPI);
			is_sub = is_sub | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSNE) && funct3_is_OPI);
			is_sub = is_sub | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLTU) && funct3_is_OPIVV_OPIVX);
			is_sub = is_sub | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLT) && funct3_is_OPIVV_OPIVX);
			is_sub = is_sub | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLE) && funct3_is_OPI);
			is_sub = is_sub | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLEU) && funct3_is_OPI);
			is_sub = is_sub | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSGT) && funct3_is_OPIVX_OPIVI);
			is_sub = is_sub | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSGTU) && funct3_is_OPIVX_OPIVI);
			riscv_v_pkg_f_is_sub = is_sub;
		end
	endfunction
	assign is_sub_id = riscv_v_pkg_f_is_sub(riscv_v_funct6_id, funct3_is_OPI_id, funct3_is_OPMVV_id, funct3_is_OPIVV_OPIVX_id, funct3_is_OPIVX_OPIVI_id, funct3_is_OPMVX_id) && is_vector_op_id;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMUL = 6'b100101;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMULH = 6'b100111;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VMULHU = 6'b100100;
	function automatic riscv_v_pkg_f_is_mul;
		input reg [5:0] funct6;
		input reg funct3_is_OPM;
		reg is_mul;
		begin
			is_mul = 1'b0;
			is_mul = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMUL) && funct3_is_OPM;
			is_mul = is_mul | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMULH) && funct3_is_OPM);
			is_mul = is_mul | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMULHU) && funct3_is_OPM);
			riscv_v_pkg_f_is_mul = is_mul;
		end
	endfunction
	assign is_mul_id = riscv_v_pkg_f_is_mul(riscv_v_funct6_id, funct3_is_OPM_id) && is_vector_op_id;
	localparam [5:0] riscv_v_pkg_RISCV_V_FUNCT6_VXUNARY0 = 6'b010010;
	function automatic riscv_v_pkg_f_is_zero_ext;
		input reg [5:0] funct6;
		input reg funct3_is_OPMVV;
		input reg [4:0] vs1;
		reg is_zero_ext;
		begin
			is_zero_ext = 1'b0;
			is_zero_ext = ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VXUNARY0) && funct3_is_OPMVV) && ~vs1[0];
			riscv_v_pkg_f_is_zero_ext = is_zero_ext;
		end
	endfunction
	assign is_zero_ext_id = riscv_v_pkg_f_is_zero_ext(riscv_v_funct6_id, funct3_is_OPMVV_id, vs1_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_is_sign_ext;
		input reg [5:0] funct6;
		input reg funct3_is_OPMVV;
		input reg [4:0] vs1;
		reg is_sign_ext;
		begin
			is_sign_ext = 1'b0;
			is_sign_ext = ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VXUNARY0) && funct3_is_OPMVV) && vs1[0];
			riscv_v_pkg_f_is_sign_ext = is_sign_ext;
		end
	endfunction
	assign is_sign_ext_id = riscv_v_pkg_f_is_sign_ext(riscv_v_funct6_id, funct3_is_OPMVV_id, vs1_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_is_set_equal;
		input reg [5:0] funct6;
		input reg funct3_is_OPI;
		reg is_set_equal;
		begin
			is_set_equal = 1'b0;
			is_set_equal = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSEQ) && funct3_is_OPI;
			is_set_equal = is_set_equal | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLE) && funct3_is_OPI);
			is_set_equal = is_set_equal | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLEU) && funct3_is_OPI);
			riscv_v_pkg_f_is_set_equal = is_set_equal;
		end
	endfunction
	assign is_set_equal_id = riscv_v_pkg_f_is_set_equal(riscv_v_funct6_id, funct3_is_OPI_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_is_compare;
		input reg [5:0] funct6;
		input reg funct3_is_OPI;
		input reg funct3_is_OPIVV_OPIVX;
		input reg funct3_is_OPIVX_OPIVI;
		reg is_compare;
		begin
			is_compare = 1'b0;
			is_compare = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSEQ) && funct3_is_OPI;
			is_compare = is_compare | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLE) && funct3_is_OPI);
			is_compare = is_compare | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLEU) && funct3_is_OPI);
			is_compare = is_compare | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSNE) && funct3_is_OPI);
			is_compare = is_compare | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLTU) && funct3_is_OPIVV_OPIVX);
			is_compare = is_compare | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLT) && funct3_is_OPIVV_OPIVX);
			is_compare = is_compare | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLE) && funct3_is_OPI);
			is_compare = is_compare | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLEU) && funct3_is_OPI);
			is_compare = is_compare | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSGT) && funct3_is_OPIVX_OPIVI);
			is_compare = is_compare | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSGTU) && funct3_is_OPIVX_OPIVI);
			riscv_v_pkg_f_is_compare = is_compare;
		end
	endfunction
	assign is_compare_id = riscv_v_pkg_f_is_compare(riscv_v_funct6_id, funct3_is_OPI_id, funct3_is_OPIVV_OPIVX_id, funct3_is_OPIVX_OPIVI_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_is_set_nequal;
		input reg [5:0] funct6;
		input reg funct3_is_OPI;
		reg is_set_nequal;
		begin
			is_set_nequal = 1'b0;
			is_set_nequal = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSNE) && funct3_is_OPI;
			riscv_v_pkg_f_is_set_nequal = is_set_nequal;
		end
	endfunction
	assign is_set_nequal_id = riscv_v_pkg_f_is_set_nequal(riscv_v_funct6_id, funct3_is_OPI_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_is_set_less;
		input reg [5:0] funct6;
		input reg funct3_is_OPIVV_OPIVX;
		input reg funct3_is_OPI;
		reg is_set_less;
		begin
			is_set_less = 1'b0;
			is_set_less = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLTU) && funct3_is_OPIVV_OPIVX;
			is_set_less = is_set_less | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLT) && funct3_is_OPIVV_OPIVX);
			is_set_less = is_set_less | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLE) && funct3_is_OPI);
			is_set_less = is_set_less | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLEU) && funct3_is_OPI);
			riscv_v_pkg_f_is_set_less = is_set_less;
		end
	endfunction
	assign is_set_less_id = riscv_v_pkg_f_is_set_less(riscv_v_funct6_id, funct3_is_OPIVV_OPIVX_id, funct3_is_OPI_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_is_set_greater;
		input reg [5:0] funct6;
		input reg funct3_is_OPIVX_OPIVI;
		reg is_set_greater;
		begin
			is_set_greater = 1'b0;
			is_set_greater = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSGT) && funct3_is_OPIVX_OPIVI;
			is_set_greater = is_set_greater | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSGTU) && funct3_is_OPIVX_OPIVI);
			riscv_v_pkg_f_is_set_greater = is_set_greater;
		end
	endfunction
	assign is_set_greater_id = riscv_v_pkg_f_is_set_greater(riscv_v_funct6_id, funct3_is_OPIVX_OPIVI_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_is_max;
		input reg [5:0] funct6;
		input reg funct3_is_OPIVV_OPIVX;
		input reg funct3_is_OPMVV;
		reg is_max;
		begin
			is_max = 1'b0;
			is_max = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMAX) && funct3_is_OPIVV_OPIVX;
			is_max = is_max | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMAXU) && funct3_is_OPIVV_OPIVX);
			is_max = is_max | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMAX) && funct3_is_OPMVV);
			is_max = is_max | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMAXU) && funct3_is_OPMVV);
			riscv_v_pkg_f_is_max = is_max;
		end
	endfunction
	assign is_max_id = riscv_v_pkg_f_is_max(riscv_v_funct6_id, funct3_is_OPIVV_OPIVX_id, funct3_is_OPMVV_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_is_min;
		input reg [5:0] funct6;
		input reg funct3_is_OPIVV_OPIVX;
		input reg funct3_is_OPMVV;
		reg is_min;
		begin
			is_min = 1'b0;
			is_min = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMIN) && funct3_is_OPIVV_OPIVX;
			is_min = is_min | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMINU) && funct3_is_OPIVV_OPIVX);
			is_min = is_min | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMIN) && funct3_is_OPMVV);
			is_min = is_min | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMINU) && funct3_is_OPMVV);
			riscv_v_pkg_f_is_min = is_min;
		end
	endfunction
	assign is_min_id = riscv_v_pkg_f_is_min(riscv_v_funct6_id, funct3_is_OPIVV_OPIVX_id, funct3_is_OPMVV_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_is_high;
		input reg [5:0] funct6;
		input reg funct3_is_OPM;
		reg is_high;
		begin
			is_high = 1'b0;
			is_high = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMULH) && funct3_is_OPM;
			is_high = is_high | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMULHU) && funct3_is_OPM);
			riscv_v_pkg_f_is_high = is_high;
		end
	endfunction
	assign is_high_id = riscv_v_pkg_f_is_high(riscv_v_funct6_id, funct3_is_OPM_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_is_signed;
		input reg [5:0] funct6;
		input reg funct3_is_OPI;
		input reg funct3_is_OPMVV;
		input reg funct3_is_OPIVV_OPIVX;
		input reg funct3_is_OPIVX_OPIVI;
		input reg funct3_is_OPM;
		reg is_signed;
		begin
			is_signed = 1'b0;
			is_signed = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VADD) && funct3_is_OPI;
			is_signed = is_signed | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VADC) && funct3_is_OPI);
			is_signed = is_signed | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDSUM) && funct3_is_OPMVV);
			is_signed = is_signed | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VSUB) && funct3_is_OPIVV_OPIVX);
			is_signed = is_signed | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VSBC) && funct3_is_OPIVV_OPIVX);
			is_signed = is_signed | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMAX) && funct3_is_OPIVV_OPIVX);
			is_signed = is_signed | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMAX) && funct3_is_OPMVV);
			is_signed = is_signed | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMIN) && funct3_is_OPIVV_OPIVX);
			is_signed = is_signed | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VREDMIN) && funct3_is_OPMVV);
			is_signed = is_signed | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMUL) && funct3_is_OPM);
			is_signed = is_signed | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMULH) && funct3_is_OPM);
			is_signed = is_signed | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLT) && funct3_is_OPIVV_OPIVX);
			is_signed = is_signed | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSLE) && funct3_is_OPI);
			is_signed = is_signed | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VMSGT) && funct3_is_OPIVX_OPIVI);
			riscv_v_pkg_f_is_signed = is_signed;
		end
	endfunction
	assign is_signed_id = riscv_v_pkg_f_is_signed(riscv_v_funct6_id, funct3_is_OPI_id, funct3_is_OPMVV_id, funct3_is_OPIVV_OPIVX_id, funct3_is_OPIVX_OPIVI_id, funct3_is_OPM_id) && is_vector_op_id;
	function automatic riscv_v_pkg_f_use_carry;
		input reg [5:0] funct6;
		input reg funct3_is_OPI;
		input reg funct3_is_OPIVV_OPIVX;
		reg use_carry;
		begin
			use_carry = 1'b0;
			use_carry = (funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VADC) && funct3_is_OPI;
			use_carry = use_carry | ((funct6 == riscv_v_pkg_RISCV_V_FUNCT6_VSBC) && funct3_is_OPIVV_OPIVX);
			riscv_v_pkg_f_use_carry = use_carry;
		end
	endfunction
	assign use_carry_id = riscv_v_pkg_f_use_carry(riscv_v_funct6_id, funct3_is_OPI_id, funct3_is_OPIVV_OPIVX_id) && is_vector_op_id;
	assign int_rf_wr_en_id = is_v2i_id;
	localparam riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY = 1;
	localparam [0:0] sv2v_uu_stage_is_vector_vector_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_vector_vector_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_vector_vector(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_vector_vector_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_vector_vector_ext_flush_val_0),
		.data_in(is_vector_vector_op_id),
		.data_out(is_vector_vector_op_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_scalar_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_scalar_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_scalar(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_scalar_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_scalar_ext_flush_val_0),
		.data_in(is_scalar_op_id),
		.data_out(is_scalar_op_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_vector_scalar_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_vector_scalar_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_vector_scalar(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_vector_scalar_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_vector_scalar_ext_flush_val_0),
		.data_in(is_scalar_vector_op_id),
		.data_out(is_scalar_vector_op_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_scalar_imm_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_scalar_imm_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_scalar_imm(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_scalar_imm_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_scalar_imm_ext_flush_val_0),
		.data_in(is_scalar_imm_op_id),
		.data_out(is_scalar_imm_op_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_scalar_int_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_scalar_int_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_scalar_int(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_scalar_int_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_scalar_int_ext_flush_val_0),
		.data_in(is_scalar_int_op_id),
		.data_out(is_scalar_int_op_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_scalar_fp_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_scalar_fp_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_scalar_fp(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_scalar_fp_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_scalar_fp_ext_flush_val_0),
		.data_in(is_scalar_fp_op_id),
		.data_out(is_scalar_fp_op_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_i2v_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_i2v_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_i2v(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_i2v_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_i2v_ext_flush_val_0),
		.data_in(is_i2v_id),
		.data_out(is_i2v_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_v2i_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_v2i_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_v2i(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_v2i_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_v2i_ext_flush_val_0),
		.data_in(is_v2i_id),
		.data_out(is_v2i_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_and_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_and_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_and(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_and_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_and_ext_flush_val_0),
		.data_in(is_and_id),
		.data_out(is_and_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_or_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_or_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_or(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_or_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_or_ext_flush_val_0),
		.data_in(is_or_id),
		.data_out(is_or_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_xor_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_xor_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_xor(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_xor_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_xor_ext_flush_val_0),
		.data_in(is_xor_id),
		.data_out(is_xor_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_negate_srca_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_negate_srca_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_negate_srca(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_negate_srca_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_negate_srca_ext_flush_val_0),
		.data_in(is_negate_srca_id),
		.data_out(is_negate_srca_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_negate_srcb_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_negate_srcb_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_negate_srcb(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_negate_srcb_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_negate_srcb_ext_flush_val_0),
		.data_in(is_negate_srcb_id),
		.data_out(is_negate_srcb_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_negate_result_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_negate_result_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_negate_result(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_negate_result_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_negate_result_ext_flush_val_0),
		.data_in(is_negate_result_id),
		.data_out(is_negate_result_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_mask_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_mask_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_mask(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_mask_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_mask_ext_flush_val_0),
		.data_in(is_mask_id),
		.data_out(is_mask_exe)
	);
	localparam [0:0] sv2v_uu_stage_use_mask_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_use_mask_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_use_mask(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_use_mask_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_use_mask_ext_flush_val_0),
		.data_in(use_mask_id),
		.data_out(use_mask_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_shift_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_shift_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_shift(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_shift_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_shift_ext_flush_val_0),
		.data_in(is_shift_id),
		.data_out(is_shift_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_left_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_left_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_left(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_left_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_left_ext_flush_val_0),
		.data_in(is_left_id),
		.data_out(is_left_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_arith_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_arith_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_arith(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_arith_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_arith_ext_flush_val_0),
		.data_in(is_arith_id),
		.data_out(is_arith_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_reduct_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_reduct_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_reduct(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_reduct_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_reduct_ext_flush_val_0),
		.data_in(is_reduct_id),
		.data_out(is_reduct_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_add_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_add_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_add(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_add_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_add_ext_flush_val_0),
		.data_in(is_add_id),
		.data_out(is_add_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_sub_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_sub_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_sub(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_sub_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_sub_ext_flush_val_0),
		.data_in(is_sub_id),
		.data_out(is_sub_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_mul_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_mul_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_mul(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_mul_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_mul_ext_flush_val_0),
		.data_in(is_mul_id),
		.data_out(is_mul_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_zero_ext_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_zero_ext_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_zero_ext(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_zero_ext_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_zero_ext_ext_flush_val_0),
		.data_in(is_zero_ext_id),
		.data_out(is_zero_ext_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_sign_ext_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_sign_ext_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_sign_ext(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_sign_ext_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_sign_ext_ext_flush_val_0),
		.data_in(is_sign_ext_id),
		.data_out(is_sign_ext_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_compare_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_compare_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_compare(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_compare_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_compare_ext_flush_val_0),
		.data_in(is_compare_id),
		.data_out(is_compare_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_set_equal_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_set_equal_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_set_equal(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_set_equal_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_set_equal_ext_flush_val_0),
		.data_in(is_set_equal_id),
		.data_out(is_set_equal_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_set_nequal_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_set_nequal_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_set_nequal(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_set_nequal_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_set_nequal_ext_flush_val_0),
		.data_in(is_set_nequal_id),
		.data_out(is_set_nequal_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_set_less_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_set_less_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_set_less(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_set_less_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_set_less_ext_flush_val_0),
		.data_in(is_set_less_id),
		.data_out(is_set_less_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_set_greater_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_set_greater_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_set_greater(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_set_greater_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_set_greater_ext_flush_val_0),
		.data_in(is_set_greater_id),
		.data_out(is_set_greater_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_max_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_max_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_max(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_max_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_max_ext_flush_val_0),
		.data_in(is_max_id),
		.data_out(is_max_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_min_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_min_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_min(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_min_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_min_ext_flush_val_0),
		.data_in(is_min_id),
		.data_out(is_min_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_high_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_high_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_high(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_high_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_high_ext_flush_val_0),
		.data_in(is_high_id),
		.data_out(is_high_exe)
	);
	localparam [0:0] sv2v_uu_stage_is_signed_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_is_signed_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_is_signed(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_is_signed_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_is_signed_ext_flush_val_0),
		.data_in(is_signed_id),
		.data_out(is_signed_exe)
	);
	localparam [0:0] sv2v_uu_stage_use_carry_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_use_carry_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_use_carry(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_use_carry_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_use_carry_ext_flush_val_0),
		.data_in(use_carry_id),
		.data_out(use_carry_exe)
	);
	localparam signed [31:0] sv2v_uu_stage_imm_DATA_T_riscv_v_pkg_RISCV_V_IMM_WIDTH = riscv_v_pkg_RISCV_V_IMM_WIDTH;
	localparam [4:0] sv2v_uu_stage_imm_ext_rst_val_x = 1'sbx;
	localparam [4:0] sv2v_uu_stage_imm_ext_flush_val_x = 1'sbx;
	riscv_v_stage_EE621_F935D #(
		.DATA_T_riscv_v_pkg_RISCV_V_IMM_WIDTH(riscv_v_pkg_RISCV_V_IMM_WIDTH),
		.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)
	) stage_imm(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_imm_ext_rst_val_x),
		.flush_val(sv2v_uu_stage_imm_ext_flush_val_x),
		.data_in(imm_id),
		.data_out(imm_exe)
	);
	localparam signed [31:0] sv2v_uu_stage_vs1_DATA_T_riscv_pkg_RISCV_INSTR_RS_WIDTH = riscv_pkg_RISCV_INSTR_RS_WIDTH;
	localparam [4:0] sv2v_uu_stage_vs1_ext_rst_val_x = 1'sbx;
	localparam [4:0] sv2v_uu_stage_vs1_ext_flush_val_x = 1'sbx;
	riscv_v_stage_A4EAF_A7C6B #(
		.DATA_T_riscv_pkg_RISCV_INSTR_RS_WIDTH(riscv_pkg_RISCV_INSTR_RS_WIDTH),
		.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)
	) stage_vs1(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_vs1_ext_rst_val_x),
		.flush_val(sv2v_uu_stage_vs1_ext_flush_val_x),
		.data_in(vs1_id),
		.data_out(vs1_exe)
	);
	localparam signed [31:0] sv2v_uu_stage_vs2_DATA_T_riscv_pkg_RISCV_INSTR_RS_WIDTH = riscv_pkg_RISCV_INSTR_RS_WIDTH;
	localparam [4:0] sv2v_uu_stage_vs2_ext_rst_val_x = 1'sbx;
	localparam [4:0] sv2v_uu_stage_vs2_ext_flush_val_x = 1'sbx;
	riscv_v_stage_A4EAF_A7C6B #(
		.DATA_T_riscv_pkg_RISCV_INSTR_RS_WIDTH(riscv_pkg_RISCV_INSTR_RS_WIDTH),
		.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)
	) stage_vs2(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_vs2_ext_rst_val_x),
		.flush_val(sv2v_uu_stage_vs2_ext_flush_val_x),
		.data_in(vs2_id),
		.data_out(vs2_exe)
	);
endmodule
