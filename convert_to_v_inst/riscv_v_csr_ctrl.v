module riscv_v_csr_ctrl (
	clk,
	rst,
	stall,
	flush,
	ext_data_in_exe,
	ext_wr_vsstatus_id,
	ext_wr_vtype_id,
	ext_wr_vl_id,
	ext_wr_vstart_id,
	ext_wr_vxrm_id,
	ext_wr_vxsat_id,
	vec_data_in_exe,
	vec_wr_vsstatus_id,
	vec_wr_vtype_id,
	vec_wr_vl_id,
	vec_wr_vstart_id,
	vec_wr_vxrm_id,
	vec_wr_vxsat_id,
	csr_wr_en_vsstatus_exe,
	csr_wr_en_vtype_exe,
	csr_wr_en_vl_exe,
	csr_wr_en_vstart_exe,
	csr_wr_en_vxrm_exe,
	csr_wr_en_vxsat_exe,
	csr_wr_data_vsstatus_exe,
	csr_wr_data_vtype_exe,
	csr_wr_data_vl_exe,
	csr_wr_data_vstart_exe,
	csr_wr_data_vxrm_exe,
	csr_wr_data_vxsat_exe,
	vsstatus_id,
	vtype_id,
	vl_id,
	vstart_id,
	vxrm_id,
	vxsat_id,
	vsstatus_exe,
	vtype_exe,
	vl_exe,
	vlenb_exe,
	vstart_exe,
	vxrm_exe,
	vxsat_exe,
	vcsr_exe
);
	input wire clk;
	input wire rst;
	input wire stall;
	input wire flush;
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
	input wire [31:0] ext_data_in_exe;
	input wire ext_wr_vsstatus_id;
	input wire ext_wr_vtype_id;
	input wire ext_wr_vl_id;
	input wire ext_wr_vstart_id;
	input wire ext_wr_vxrm_id;
	input wire ext_wr_vxsat_id;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [127:0] vec_data_in_exe;
	input wire vec_wr_vsstatus_id;
	input wire vec_wr_vtype_id;
	input wire vec_wr_vl_id;
	input wire vec_wr_vstart_id;
	input wire vec_wr_vxrm_id;
	input wire vec_wr_vxsat_id;
	output wire csr_wr_en_vsstatus_exe;
	output wire csr_wr_en_vtype_exe;
	output wire csr_wr_en_vl_exe;
	output wire csr_wr_en_vstart_exe;
	output wire csr_wr_en_vxrm_exe;
	output wire csr_wr_en_vxsat_exe;
	output wire [10:0] csr_wr_data_vsstatus_exe;
	output wire [8:0] csr_wr_data_vtype_exe;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_MAX_LMUL = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_MAX_VLEN = riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG * riscv_v_pkg_RISCV_V_MAX_LMUL;
	output wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] csr_wr_data_vl_exe;
	output wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] csr_wr_data_vstart_exe;
	output wire [1:0] csr_wr_data_vxrm_exe;
	output wire [0:0] csr_wr_data_vxsat_exe;
	input wire [10:0] vsstatus_id;
	input wire [8:0] vtype_id;
	input wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vl_id;
	input wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vstart_id;
	input wire [1:0] vxrm_id;
	input wire [0:0] vxsat_id;
	output wire [10:0] vsstatus_exe;
	output wire [8:0] vtype_exe;
	output wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vl_exe;
	output wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vlenb_exe;
	output wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vstart_exe;
	output wire [1:0] vxrm_exe;
	output wire [0:0] vxsat_exe;
	output wire [2:0] vcsr_exe;
	wire en_stage;
	wire ext_wr_vsstatus_exe;
	wire ext_wr_vtype_exe;
	wire ext_wr_vl_exe;
	wire ext_wr_vstart_exe;
	wire ext_wr_vxrm_exe;
	wire ext_wr_vxsat_exe;
	wire vec_wr_vsstatus_exe;
	wire vec_wr_vtype_exe;
	wire vec_wr_vl_exe;
	wire vec_wr_vstart_exe;
	wire vec_wr_vxrm_exe;
	wire vec_wr_vxsat_exe;
	assign en_stage = ~stall;
	localparam riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY = 1;
	localparam [0:0] sv2v_uu_ext_stage_wr_vsstatus_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_ext_stage_wr_vsstatus_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) ext_stage_wr_vsstatus(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_ext_stage_wr_vsstatus_ext_rst_val_0),
		.flush_val(sv2v_uu_ext_stage_wr_vsstatus_ext_flush_val_0),
		.data_in(ext_wr_vsstatus_id),
		.data_out(ext_wr_vsstatus_exe)
	);
	localparam [0:0] sv2v_uu_ext_stage_wr_vtype_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_ext_stage_wr_vtype_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) ext_stage_wr_vtype(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_ext_stage_wr_vtype_ext_rst_val_0),
		.flush_val(sv2v_uu_ext_stage_wr_vtype_ext_flush_val_0),
		.data_in(ext_wr_vtype_id),
		.data_out(ext_wr_vtype_exe)
	);
	localparam [0:0] sv2v_uu_ext_stage_wr_vl_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_ext_stage_wr_vl_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) ext_stage_wr_vl(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_ext_stage_wr_vl_ext_rst_val_0),
		.flush_val(sv2v_uu_ext_stage_wr_vl_ext_flush_val_0),
		.data_in(ext_wr_vl_id),
		.data_out(ext_wr_vl_exe)
	);
	localparam [0:0] sv2v_uu_ext_stage_wr_vstart_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_ext_stage_wr_vstart_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) ext_stage_wr_vstart(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_ext_stage_wr_vstart_ext_rst_val_0),
		.flush_val(sv2v_uu_ext_stage_wr_vstart_ext_flush_val_0),
		.data_in(ext_wr_vstart_id),
		.data_out(ext_wr_vstart_exe)
	);
	localparam [0:0] sv2v_uu_ext_stage_wr_vxrm_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_ext_stage_wr_vxrm_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) ext_stage_wr_vxrm(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_ext_stage_wr_vxrm_ext_rst_val_0),
		.flush_val(sv2v_uu_ext_stage_wr_vxrm_ext_flush_val_0),
		.data_in(ext_wr_vxrm_id),
		.data_out(ext_wr_vxrm_exe)
	);
	localparam [0:0] sv2v_uu_ext_stage_wr_vxsat_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_ext_stage_wr_vxsat_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) ext_stage_wr_vxsat(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_ext_stage_wr_vxsat_ext_rst_val_0),
		.flush_val(sv2v_uu_ext_stage_wr_vxsat_ext_flush_val_0),
		.data_in(ext_wr_vxsat_id),
		.data_out(ext_wr_vxsat_exe)
	);
	localparam [0:0] sv2v_uu_vec_stage_wr_vsstatus_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_vec_stage_wr_vsstatus_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) vec_stage_wr_vsstatus(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_vec_stage_wr_vsstatus_ext_rst_val_0),
		.flush_val(sv2v_uu_vec_stage_wr_vsstatus_ext_flush_val_0),
		.data_in(vec_wr_vsstatus_id),
		.data_out(vec_wr_vsstatus_exe)
	);
	localparam [0:0] sv2v_uu_vec_stage_wr_vtype_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_vec_stage_wr_vtype_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) vec_stage_wr_vtype(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_vec_stage_wr_vtype_ext_rst_val_0),
		.flush_val(sv2v_uu_vec_stage_wr_vtype_ext_flush_val_0),
		.data_in(vec_wr_vtype_id),
		.data_out(vec_wr_vtype_exe)
	);
	localparam [0:0] sv2v_uu_vec_stage_wr_vl_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_vec_stage_wr_vl_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) vec_stage_wr_vl(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_vec_stage_wr_vl_ext_rst_val_0),
		.flush_val(sv2v_uu_vec_stage_wr_vl_ext_flush_val_0),
		.data_in(vec_wr_vl_id),
		.data_out(vec_wr_vl_exe)
	);
	localparam [0:0] sv2v_uu_vec_stage_wr_vstart_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_vec_stage_wr_vstart_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) vec_stage_wr_vstart(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_vec_stage_wr_vstart_ext_rst_val_0),
		.flush_val(sv2v_uu_vec_stage_wr_vstart_ext_flush_val_0),
		.data_in(vec_wr_vstart_id),
		.data_out(vec_wr_vstart_exe)
	);
	localparam [0:0] sv2v_uu_vec_stage_wr_vxrm_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_vec_stage_wr_vxrm_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) vec_stage_wr_vxrm(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_vec_stage_wr_vxrm_ext_rst_val_0),
		.flush_val(sv2v_uu_vec_stage_wr_vxrm_ext_flush_val_0),
		.data_in(vec_wr_vxrm_id),
		.data_out(vec_wr_vxrm_exe)
	);
	localparam [0:0] sv2v_uu_vec_stage_wr_vxsat_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_vec_stage_wr_vxsat_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) vec_stage_wr_vxsat(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_vec_stage_wr_vxsat_ext_rst_val_0),
		.flush_val(sv2v_uu_vec_stage_wr_vxsat_ext_flush_val_0),
		.data_in(vec_wr_vxsat_id),
		.data_out(vec_wr_vxsat_exe)
	);
	localparam [10:0] sv2v_uu_stage_vsstatus_ext_rst_val_x = 1'sbx;
	localparam [10:0] sv2v_uu_stage_vsstatus_ext_flush_val_x = 1'sbx;
	riscv_v_stage_7EB58 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_vsstatus(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_vsstatus_ext_rst_val_x),
		.flush_val(sv2v_uu_stage_vsstatus_ext_flush_val_x),
		.data_in(vsstatus_id),
		.data_out(vsstatus_exe)
	);
	localparam [8:0] sv2v_uu_stage_vtype_ext_rst_val_x = 1'sbx;
	localparam [8:0] sv2v_uu_stage_vtype_ext_flush_val_x = 1'sbx;
	riscv_v_stage_A8A75 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_vtype(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_vtype_ext_rst_val_x),
		.flush_val(sv2v_uu_stage_vtype_ext_flush_val_x),
		.data_in(vtype_id),
		.data_out(vtype_exe)
	);
	localparam integer stage_vl_sv2v_pfunc_1B878 = $clog2(riscv_v_pkg_RISCV_V_MAX_VLEN);
	localparam integer sv2v_uu_stage_vl_DATA_T_stage_vl_sv2v_pfunc_1B878 = stage_vl_sv2v_pfunc_1B878;
	localparam [sv2v_uu_stage_vl_DATA_T_stage_vl_sv2v_pfunc_1B878 - 1:0] sv2v_uu_stage_vl_ext_rst_val_x = 1'sbx;
	localparam [sv2v_uu_stage_vl_DATA_T_stage_vl_sv2v_pfunc_1B878 - 1:0] sv2v_uu_stage_vl_ext_flush_val_x = 1'sbx;
	riscv_v_stage_C3F9D_39151 #(
		.DATA_T_stage_vl_sv2v_pfunc_1B878(stage_vl_sv2v_pfunc_1B878),
		.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)
	) stage_vl(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_vl_ext_rst_val_x),
		.flush_val(sv2v_uu_stage_vl_ext_flush_val_x),
		.data_in(vl_id),
		.data_out(vl_exe)
	);
	assign vlenb_exe = vl_exe[$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1-:$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN)] >> 3;
	localparam integer stage_vstart_sv2v_pfunc_1B878 = $clog2(riscv_v_pkg_RISCV_V_MAX_VLEN);
	localparam integer sv2v_uu_stage_vstart_DATA_T_stage_vstart_sv2v_pfunc_1B878 = stage_vstart_sv2v_pfunc_1B878;
	localparam [sv2v_uu_stage_vstart_DATA_T_stage_vstart_sv2v_pfunc_1B878 - 1:0] sv2v_uu_stage_vstart_ext_rst_val_x = 1'sbx;
	localparam [sv2v_uu_stage_vstart_DATA_T_stage_vstart_sv2v_pfunc_1B878 - 1:0] sv2v_uu_stage_vstart_ext_flush_val_x = 1'sbx;
	riscv_v_stage_1F582_5645A #(
		.DATA_T_stage_vstart_sv2v_pfunc_1B878(stage_vstart_sv2v_pfunc_1B878),
		.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)
	) stage_vstart(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_vstart_ext_rst_val_x),
		.flush_val(sv2v_uu_stage_vstart_ext_flush_val_x),
		.data_in(vstart_id),
		.data_out(vstart_exe)
	);
	localparam [1:0] sv2v_uu_stage_vxrm_ext_rst_val_x = 1'sbx;
	localparam [1:0] sv2v_uu_stage_vxrm_ext_flush_val_x = 1'sbx;
	riscv_v_stage_EA379 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_vxrm(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_vxrm_ext_rst_val_x),
		.flush_val(sv2v_uu_stage_vxrm_ext_flush_val_x),
		.data_in(vxrm_id),
		.data_out(vxrm_exe)
	);
	localparam [0:0] sv2v_uu_stage_vxsat_ext_rst_val_x = 1'sbx;
	localparam [0:0] sv2v_uu_stage_vxsat_ext_flush_val_x = 1'sbx;
	riscv_v_stage_300C0 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)) stage_vxsat(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_vxsat_ext_rst_val_x),
		.flush_val(sv2v_uu_stage_vxsat_ext_flush_val_x),
		.data_in(vxsat_id),
		.data_out(vxsat_exe)
	);
	assign vcsr_exe[2-:2] = vxrm_exe[1-:2];
	assign vcsr_exe[0] = vxsat_exe[0];
	assign csr_wr_en_vsstatus_exe = ext_wr_vsstatus_exe || vec_wr_vsstatus_exe;
	assign csr_wr_en_vtype_exe = ext_wr_vtype_exe || vec_wr_vtype_exe;
	assign csr_wr_en_vl_exe = ext_wr_vl_exe || vec_wr_vl_exe;
	assign csr_wr_en_vstart_exe = ext_wr_vstart_exe || vec_wr_vstart_exe;
	assign csr_wr_en_vxrm_exe = ext_wr_vxrm_exe || vec_wr_vxrm_exe;
	assign csr_wr_en_vxsat_exe = ext_wr_vxsat_exe || vec_wr_vxsat_exe;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VSSTATUS_WIDTH = 11;
	assign csr_wr_data_vsstatus_exe = (ext_data_in_exe[10:0] & {riscv_v_pkg_RISCV_V_VSSTATUS_WIDTH {ext_wr_vsstatus_exe}}) | (vec_data_in_exe[10:0] & {riscv_v_pkg_RISCV_V_VSSTATUS_WIDTH {vec_wr_vsstatus_exe}});
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VTYPE_WIDTH = 9;
	assign csr_wr_data_vtype_exe = (ext_data_in_exe[8:0] & {riscv_v_pkg_RISCV_V_VTYPE_WIDTH {ext_wr_vtype_exe}}) | (vec_data_in_exe[8:0] & {riscv_v_pkg_RISCV_V_VTYPE_WIDTH {vec_wr_vtype_exe}});
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VL_WIDTH = $clog2(riscv_v_pkg_RISCV_V_MAX_VLEN);
	assign csr_wr_data_vl_exe = (ext_data_in_exe[riscv_v_pkg_RISCV_V_VL_WIDTH - 1:0] & {riscv_v_pkg_RISCV_V_VL_WIDTH {ext_wr_vl_exe}}) | (vec_data_in_exe[riscv_v_pkg_RISCV_V_VL_WIDTH - 1:0] & {riscv_v_pkg_RISCV_V_VL_WIDTH {vec_wr_vl_exe}});
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VSTART_WIDTH = $clog2(riscv_v_pkg_RISCV_V_MAX_VLEN);
	assign csr_wr_data_vstart_exe = (ext_data_in_exe[riscv_v_pkg_RISCV_V_VSTART_WIDTH - 1:0] & {riscv_v_pkg_RISCV_V_VSTART_WIDTH {ext_wr_vstart_exe}}) | (vec_data_in_exe[riscv_v_pkg_RISCV_V_VSTART_WIDTH - 1:0] & {riscv_v_pkg_RISCV_V_VSTART_WIDTH {vec_wr_vstart_exe}});
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VXRM_WIDTH = 2;
	assign csr_wr_data_vxrm_exe = (ext_data_in_exe[1:0] & {riscv_v_pkg_RISCV_V_VXRM_WIDTH {ext_wr_vxrm_exe}}) | (vec_data_in_exe[1:0] & {riscv_v_pkg_RISCV_V_VXRM_WIDTH {vec_wr_vxrm_exe}});
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VXSAT_WIDTH = 1;
	assign csr_wr_data_vxsat_exe = (ext_data_in_exe[0:0] & {riscv_v_pkg_RISCV_V_VXSAT_WIDTH {ext_wr_vxsat_exe}}) | (vec_data_in_exe[0:0] & {riscv_v_pkg_RISCV_V_VXSAT_WIDTH {vec_wr_vxsat_exe}});
endmodule
