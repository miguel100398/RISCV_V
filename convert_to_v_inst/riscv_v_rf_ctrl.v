module riscv_v_rf_ctrl (
	clk,
	rst,
	stall,
	flush,
	rf_wr_addr_id,
	rf_wr_addr_exe,
	rf_wr_addr_mem,
	rf_wr_addr_wb,
	rf_wr_en_exe,
	rf_wr_en_mem,
	rf_wr_en_wb,
	rf_wr_data_exe,
	rf_wr_data_mem,
	rf_wr_data_wb,
	rf_rd_data_srca_id,
	rf_rd_data_srca_exe,
	rf_rd_data_srcb_id,
	rf_rd_data_srcb_exe,
	mask_id,
	mask_exe,
	mask_merge_id,
	mask_merge_exe,
	int_rf_rd_data_id,
	int_rf_rd_data_exe,
	int_rf_wr_data_exe,
	int_rf_wr_data_wb,
	int_rf_wr_en_id,
	int_rf_wr_en_wb
);
	input wire clk;
	input wire rst;
	input wire stall;
	input wire flush;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_RF_NUM_REGS = 32;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_RF_ADDR_WIDTH = 5;
	input wire [4:0] rf_wr_addr_id;
	output wire [4:0] rf_wr_addr_exe;
	output wire [4:0] rf_wr_addr_mem;
	output wire [4:0] rf_wr_addr_wb;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] rf_wr_en_exe;
	output wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] rf_wr_en_mem;
	output wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] rf_wr_en_wb;
	input wire [127:0] rf_wr_data_exe;
	output wire [127:0] rf_wr_data_mem;
	output wire [127:0] rf_wr_data_wb;
	input wire [127:0] rf_rd_data_srca_id;
	output wire [127:0] rf_rd_data_srca_exe;
	input wire [127:0] rf_rd_data_srcb_id;
	output wire [127:0] rf_rd_data_srcb_exe;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_id;
	output wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_exe;
	input wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_merge_id;
	output wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_merge_exe;
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
	input wire [31:0] int_rf_rd_data_id;
	output wire [31:0] int_rf_rd_data_exe;
	input wire [31:0] int_rf_wr_data_exe;
	output wire [31:0] int_rf_wr_data_wb;
	input wire int_rf_wr_en_id;
	output wire int_rf_wr_en_wb;
	wire en_stage;
	localparam riscv_v_pkg_RISCV_V_EXE_2_MEM_LATENCY = 1;
	localparam riscv_v_pkg_RISCV_V_MEM_2_WB_LATENCY = 1;
	localparam riscv_v_pkg_RISCV_V_EXE_2_WB_LATENCY = 2;
	wire [(3 * riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] rf_wr_en_stages;
	localparam riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY = 1;
	localparam riscv_v_pkg_RISCV_V_ID_2_WB_LATENCY = 3;
	wire [19:0] rf_wr_addr_stages;
	wire [383:0] rf_wr_data_stages;
	assign en_stage = ~stall;
	localparam signed [31:0] sv2v_uu_stage_rf_wr_addr_DATA_T_riscv_v_pkg_RISCV_V_RF_ADDR_WIDTH = riscv_v_pkg_RISCV_V_RF_ADDR_WIDTH;
	localparam [4:0] sv2v_uu_stage_rf_wr_addr_ext_rst_val_x = 1'sbx;
	localparam [4:0] sv2v_uu_stage_rf_wr_addr_ext_flush_val_x = 1'sbx;
	riscv_v_stage_96DA9_C2B4E #(
		.DATA_T_riscv_v_pkg_RISCV_V_RF_ADDR_WIDTH(riscv_v_pkg_RISCV_V_RF_ADDR_WIDTH),
		.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_WB_LATENCY)
	) stage_rf_wr_addr(
		.clk(clk),
		.rst(1'b0),
		.en(en_stage),
		.flush(1'b0),
		.rst_val(sv2v_uu_stage_rf_wr_addr_ext_rst_val_x),
		.flush_val(sv2v_uu_stage_rf_wr_addr_ext_flush_val_x),
		.data_in(rf_wr_addr_id),
		.data_out(rf_wr_addr_wb),
		.internal_data(rf_wr_addr_stages)
	);
	localparam signed [31:0] sv2v_uu_stage_rf_wr_en_DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_NUM_BYTES_DATA;
	localparam [sv2v_uu_stage_rf_wr_en_DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] sv2v_uu_stage_rf_wr_en_ext_rst_val_0 = 1'sb0;
	localparam [sv2v_uu_stage_rf_wr_en_DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] sv2v_uu_stage_rf_wr_en_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_63257_B3D37 #(
		.DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA),
		.NUM_STAGES(riscv_v_pkg_RISCV_V_EXE_2_WB_LATENCY)
	) stage_rf_wr_en(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_rf_wr_en_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_rf_wr_en_ext_flush_val_0),
		.data_in(rf_wr_en_exe),
		.data_out(rf_wr_en_wb),
		.internal_data(rf_wr_en_stages)
	);
	localparam signed [31:0] sv2v_uu_stage_rf_wr_data_DATA_T_riscv_pkg_BYTE_WIDTH = riscv_pkg_BYTE_WIDTH;
	localparam signed [31:0] sv2v_uu_stage_rf_wr_data_DATA_T_riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_DATA_WIDTH;
	localparam signed [31:0] sv2v_uu_stage_rf_wr_data_DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_NUM_BYTES_DATA;
	localparam [127:0] sv2v_uu_stage_rf_wr_data_ext_rst_val_x = 1'sbx;
	localparam [127:0] sv2v_uu_stage_rf_wr_data_ext_flush_val_x = 1'sbx;
	riscv_v_stage_969A4_CCEB1 #(
		.DATA_T_riscv_pkg_BYTE_WIDTH(riscv_pkg_BYTE_WIDTH),
		.DATA_T_riscv_v_pkg_RISCV_V_DATA_WIDTH(riscv_v_pkg_RISCV_V_DATA_WIDTH),
		.DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA),
		.NUM_STAGES(riscv_v_pkg_RISCV_V_EXE_2_WB_LATENCY)
	) stage_rf_wr_data(
		.clk(clk),
		.rst(1'b0),
		.en(en_stage),
		.flush(1'b0),
		.rst_val(sv2v_uu_stage_rf_wr_data_ext_rst_val_x),
		.flush_val(sv2v_uu_stage_rf_wr_data_ext_flush_val_x),
		.data_in(rf_wr_data_exe),
		.data_out(rf_wr_data_wb),
		.internal_data(rf_wr_data_stages)
	);
	localparam signed [31:0] sv2v_uu_stage_rf_rd_data_srca_DATA_T_riscv_pkg_BYTE_WIDTH = riscv_pkg_BYTE_WIDTH;
	localparam signed [31:0] sv2v_uu_stage_rf_rd_data_srca_DATA_T_riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_DATA_WIDTH;
	localparam signed [31:0] sv2v_uu_stage_rf_rd_data_srca_DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_NUM_BYTES_DATA;
	localparam [127:0] sv2v_uu_stage_rf_rd_data_srca_ext_rst_val_x = 1'sbx;
	localparam [127:0] sv2v_uu_stage_rf_rd_data_srca_ext_flush_val_x = 1'sbx;
	riscv_v_stage_969A4_CCEB1 #(
		.DATA_T_riscv_pkg_BYTE_WIDTH(riscv_pkg_BYTE_WIDTH),
		.DATA_T_riscv_v_pkg_RISCV_V_DATA_WIDTH(riscv_v_pkg_RISCV_V_DATA_WIDTH),
		.DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA),
		.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)
	) stage_rf_rd_data_srca(
		.clk(clk),
		.rst(1'b0),
		.en(en_stage),
		.flush(1'b0),
		.rst_val(sv2v_uu_stage_rf_rd_data_srca_ext_rst_val_x),
		.flush_val(sv2v_uu_stage_rf_rd_data_srca_ext_flush_val_x),
		.data_in(rf_rd_data_srca_id),
		.data_out(rf_rd_data_srca_exe)
	);
	localparam signed [31:0] sv2v_uu_stage_rf_rd_data_srcb_DATA_T_riscv_pkg_BYTE_WIDTH = riscv_pkg_BYTE_WIDTH;
	localparam signed [31:0] sv2v_uu_stage_rf_rd_data_srcb_DATA_T_riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_DATA_WIDTH;
	localparam signed [31:0] sv2v_uu_stage_rf_rd_data_srcb_DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_NUM_BYTES_DATA;
	localparam [127:0] sv2v_uu_stage_rf_rd_data_srcb_ext_rst_val_x = 1'sbx;
	localparam [127:0] sv2v_uu_stage_rf_rd_data_srcb_ext_flush_val_x = 1'sbx;
	riscv_v_stage_969A4_CCEB1 #(
		.DATA_T_riscv_pkg_BYTE_WIDTH(riscv_pkg_BYTE_WIDTH),
		.DATA_T_riscv_v_pkg_RISCV_V_DATA_WIDTH(riscv_v_pkg_RISCV_V_DATA_WIDTH),
		.DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA),
		.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)
	) stage_rf_rd_data_srcb(
		.clk(clk),
		.rst(1'b0),
		.en(en_stage),
		.flush(1'b0),
		.rst_val(sv2v_uu_stage_rf_rd_data_srcb_ext_rst_val_x),
		.flush_val(sv2v_uu_stage_rf_rd_data_srcb_ext_flush_val_x),
		.data_in(rf_rd_data_srcb_id),
		.data_out(rf_rd_data_srcb_exe)
	);
	localparam signed [31:0] sv2v_uu_stage_int_rf_rd_data_DATA_T_riscv_pkg_BYTE_WIDTH = riscv_pkg_BYTE_WIDTH;
	localparam signed [31:0] sv2v_uu_stage_int_rf_rd_data_DATA_T_riscv_pkg_DQWORD_WIDTH = riscv_pkg_DQWORD_WIDTH;
	localparam signed [31:0] sv2v_uu_stage_int_rf_rd_data_DATA_T_riscv_pkg_DWORD_WIDTH = riscv_pkg_DWORD_WIDTH;
	localparam signed [31:0] sv2v_uu_stage_int_rf_rd_data_DATA_T_riscv_pkg_QWORD_WIDTH = riscv_pkg_QWORD_WIDTH;
	localparam signed [31:0] sv2v_uu_stage_int_rf_rd_data_DATA_T_riscv_pkg_RISCV_DATA_WIDTH = riscv_pkg_RISCV_DATA_WIDTH;
	localparam signed [31:0] sv2v_uu_stage_int_rf_rd_data_DATA_T_riscv_pkg_RISCV_NUM_BYTES_DATA = riscv_pkg_RISCV_NUM_BYTES_DATA;
	localparam signed [31:0] sv2v_uu_stage_int_rf_rd_data_DATA_T_riscv_pkg_RISCV_NUM_DQWORDS_DATA = riscv_pkg_RISCV_NUM_DQWORDS_DATA;
	localparam signed [31:0] sv2v_uu_stage_int_rf_rd_data_DATA_T_riscv_pkg_RISCV_NUM_DWORDS_DATA = riscv_pkg_RISCV_NUM_DWORDS_DATA;
	localparam signed [31:0] sv2v_uu_stage_int_rf_rd_data_DATA_T_riscv_pkg_RISCV_NUM_QWORDS_DATA = riscv_pkg_RISCV_NUM_QWORDS_DATA;
	localparam signed [31:0] sv2v_uu_stage_int_rf_rd_data_DATA_T_riscv_pkg_RISCV_NUM_WORDS_DATA = riscv_pkg_RISCV_NUM_WORDS_DATA;
	localparam signed [31:0] sv2v_uu_stage_int_rf_rd_data_DATA_T_riscv_pkg_WORD_WIDTH = riscv_pkg_WORD_WIDTH;
	localparam [31:0] sv2v_uu_stage_int_rf_rd_data_ext_rst_val_x = 1'sbx;
	localparam [31:0] sv2v_uu_stage_int_rf_rd_data_ext_flush_val_x = 1'sbx;
	riscv_v_stage_E6BB0_71521 #(
		.DATA_T_riscv_pkg_BYTE_WIDTH(riscv_pkg_BYTE_WIDTH),
		.DATA_T_riscv_pkg_DQWORD_WIDTH(riscv_pkg_DQWORD_WIDTH),
		.DATA_T_riscv_pkg_DWORD_WIDTH(riscv_pkg_DWORD_WIDTH),
		.DATA_T_riscv_pkg_QWORD_WIDTH(riscv_pkg_QWORD_WIDTH),
		.DATA_T_riscv_pkg_RISCV_DATA_WIDTH(riscv_pkg_RISCV_DATA_WIDTH),
		.DATA_T_riscv_pkg_RISCV_NUM_BYTES_DATA(riscv_pkg_RISCV_NUM_BYTES_DATA),
		.DATA_T_riscv_pkg_RISCV_NUM_DQWORDS_DATA(riscv_pkg_RISCV_NUM_DQWORDS_DATA),
		.DATA_T_riscv_pkg_RISCV_NUM_DWORDS_DATA(riscv_pkg_RISCV_NUM_DWORDS_DATA),
		.DATA_T_riscv_pkg_RISCV_NUM_QWORDS_DATA(riscv_pkg_RISCV_NUM_QWORDS_DATA),
		.DATA_T_riscv_pkg_RISCV_NUM_WORDS_DATA(riscv_pkg_RISCV_NUM_WORDS_DATA),
		.DATA_T_riscv_pkg_WORD_WIDTH(riscv_pkg_WORD_WIDTH),
		.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)
	) stage_int_rf_rd_data(
		.clk(clk),
		.rst(1'b0),
		.en(en_stage),
		.flush(1'b0),
		.rst_val(sv2v_uu_stage_int_rf_rd_data_ext_rst_val_x),
		.flush_val(sv2v_uu_stage_int_rf_rd_data_ext_flush_val_x),
		.data_in(int_rf_rd_data_id),
		.data_out(int_rf_rd_data_exe)
	);
	localparam signed [31:0] sv2v_uu_stage_int_rf_wr_data_DATA_T_riscv_pkg_BYTE_WIDTH = riscv_pkg_BYTE_WIDTH;
	localparam signed [31:0] sv2v_uu_stage_int_rf_wr_data_DATA_T_riscv_pkg_DQWORD_WIDTH = riscv_pkg_DQWORD_WIDTH;
	localparam signed [31:0] sv2v_uu_stage_int_rf_wr_data_DATA_T_riscv_pkg_DWORD_WIDTH = riscv_pkg_DWORD_WIDTH;
	localparam signed [31:0] sv2v_uu_stage_int_rf_wr_data_DATA_T_riscv_pkg_QWORD_WIDTH = riscv_pkg_QWORD_WIDTH;
	localparam signed [31:0] sv2v_uu_stage_int_rf_wr_data_DATA_T_riscv_pkg_RISCV_DATA_WIDTH = riscv_pkg_RISCV_DATA_WIDTH;
	localparam signed [31:0] sv2v_uu_stage_int_rf_wr_data_DATA_T_riscv_pkg_RISCV_NUM_BYTES_DATA = riscv_pkg_RISCV_NUM_BYTES_DATA;
	localparam signed [31:0] sv2v_uu_stage_int_rf_wr_data_DATA_T_riscv_pkg_RISCV_NUM_DQWORDS_DATA = riscv_pkg_RISCV_NUM_DQWORDS_DATA;
	localparam signed [31:0] sv2v_uu_stage_int_rf_wr_data_DATA_T_riscv_pkg_RISCV_NUM_DWORDS_DATA = riscv_pkg_RISCV_NUM_DWORDS_DATA;
	localparam signed [31:0] sv2v_uu_stage_int_rf_wr_data_DATA_T_riscv_pkg_RISCV_NUM_QWORDS_DATA = riscv_pkg_RISCV_NUM_QWORDS_DATA;
	localparam signed [31:0] sv2v_uu_stage_int_rf_wr_data_DATA_T_riscv_pkg_RISCV_NUM_WORDS_DATA = riscv_pkg_RISCV_NUM_WORDS_DATA;
	localparam signed [31:0] sv2v_uu_stage_int_rf_wr_data_DATA_T_riscv_pkg_WORD_WIDTH = riscv_pkg_WORD_WIDTH;
	localparam [31:0] sv2v_uu_stage_int_rf_wr_data_ext_rst_val_x = 1'sbx;
	localparam [31:0] sv2v_uu_stage_int_rf_wr_data_ext_flush_val_x = 1'sbx;
	riscv_v_stage_E6BB0_71521 #(
		.DATA_T_riscv_pkg_BYTE_WIDTH(riscv_pkg_BYTE_WIDTH),
		.DATA_T_riscv_pkg_DQWORD_WIDTH(riscv_pkg_DQWORD_WIDTH),
		.DATA_T_riscv_pkg_DWORD_WIDTH(riscv_pkg_DWORD_WIDTH),
		.DATA_T_riscv_pkg_QWORD_WIDTH(riscv_pkg_QWORD_WIDTH),
		.DATA_T_riscv_pkg_RISCV_DATA_WIDTH(riscv_pkg_RISCV_DATA_WIDTH),
		.DATA_T_riscv_pkg_RISCV_NUM_BYTES_DATA(riscv_pkg_RISCV_NUM_BYTES_DATA),
		.DATA_T_riscv_pkg_RISCV_NUM_DQWORDS_DATA(riscv_pkg_RISCV_NUM_DQWORDS_DATA),
		.DATA_T_riscv_pkg_RISCV_NUM_DWORDS_DATA(riscv_pkg_RISCV_NUM_DWORDS_DATA),
		.DATA_T_riscv_pkg_RISCV_NUM_QWORDS_DATA(riscv_pkg_RISCV_NUM_QWORDS_DATA),
		.DATA_T_riscv_pkg_RISCV_NUM_WORDS_DATA(riscv_pkg_RISCV_NUM_WORDS_DATA),
		.DATA_T_riscv_pkg_WORD_WIDTH(riscv_pkg_WORD_WIDTH),
		.NUM_STAGES(riscv_v_pkg_RISCV_V_EXE_2_WB_LATENCY)
	) stage_int_rf_wr_data(
		.clk(clk),
		.rst(1'b0),
		.en(en_stage),
		.flush(1'b0),
		.rst_val(sv2v_uu_stage_int_rf_wr_data_ext_rst_val_x),
		.flush_val(sv2v_uu_stage_int_rf_wr_data_ext_flush_val_x),
		.data_in(int_rf_wr_data_exe),
		.data_out(int_rf_wr_data_wb)
	);
	localparam [0:0] sv2v_uu_stage_int_rf_wr_en_ext_rst_val_0 = 1'sb0;
	localparam [0:0] sv2v_uu_stage_int_rf_wr_en_ext_flush_val_0 = 1'sb0;
	riscv_v_stage_C9449 #(.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_WB_LATENCY)) stage_int_rf_wr_en(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_int_rf_wr_en_ext_rst_val_0),
		.flush_val(sv2v_uu_stage_int_rf_wr_en_ext_flush_val_0),
		.data_in(int_rf_wr_en_id),
		.data_out(int_rf_wr_en_wb)
	);
	localparam signed [31:0] sv2v_uu_stage_mask_DATA_T_riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG = riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG;
	localparam [sv2v_uu_stage_mask_DATA_T_riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] sv2v_uu_stage_mask_ext_rst_val_x = 1'sbx;
	localparam [sv2v_uu_stage_mask_DATA_T_riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] sv2v_uu_stage_mask_ext_flush_val_x = 1'sbx;
	riscv_v_stage_300B3_9090A #(
		.DATA_T_riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG(riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG),
		.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)
	) stage_mask(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_mask_ext_rst_val_x),
		.flush_val(sv2v_uu_stage_mask_ext_flush_val_x),
		.data_in(mask_id),
		.data_out(mask_exe)
	);
	localparam signed [31:0] sv2v_uu_stage_mask_merge_DATA_T_riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG = riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG;
	localparam [sv2v_uu_stage_mask_merge_DATA_T_riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] sv2v_uu_stage_mask_merge_ext_rst_val_x = 1'sbx;
	localparam [sv2v_uu_stage_mask_merge_DATA_T_riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] sv2v_uu_stage_mask_merge_ext_flush_val_x = 1'sbx;
	riscv_v_stage_300B3_9090A #(
		.DATA_T_riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG(riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG),
		.NUM_STAGES(riscv_v_pkg_RISCV_V_ID_2_EXE_LATENCY)
	) stage_mask_merge(
		.clk(clk),
		.rst(rst),
		.en(en_stage),
		.flush(flush),
		.rst_val(sv2v_uu_stage_mask_merge_ext_rst_val_x),
		.flush_val(sv2v_uu_stage_mask_merge_ext_flush_val_x),
		.data_in(mask_merge_id),
		.data_out(mask_merge_exe)
	);
	assign rf_wr_en_mem = rf_wr_en_stages[riscv_v_pkg_RISCV_V_EXE_2_MEM_LATENCY * riscv_v_pkg_RISCV_V_NUM_BYTES_DATA+:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA];
	assign rf_wr_addr_exe = rf_wr_addr_stages[5+:riscv_v_pkg_RISCV_V_RF_ADDR_WIDTH];
	localparam riscv_v_pkg_RISCV_V_ID_2_MEM_LATENCY = 2;
	assign rf_wr_addr_mem = rf_wr_addr_stages[10+:riscv_v_pkg_RISCV_V_RF_ADDR_WIDTH];
	assign rf_wr_data_mem = rf_wr_data_stages[128+:128];
endmodule
