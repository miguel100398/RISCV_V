module riscv_v_bypass (
	integer_data,
	imm,
	srca,
	srcb,
	mask,
	mask_merge,
	osize_vector,
	is_shift,
	is_scalar,
	is_scalar_int,
	is_scalar_vec,
	is_scalar_imm,
	is_scalar_fp,
	rf_wr_en_mem,
	rf_wr_en_wb,
	rf_rd_addr_srca_exe,
	rf_rd_addr_srcb_exe,
	rf_merge_mask_addr_exe,
	rf_wr_addr_mem,
	rf_wr_addr_wb,
	rf_wr_data_mem,
	rf_wr_data_wb,
	srca_byp,
	srcb_byp,
	mask_byp,
	mask_merge_byp
);
	reg _sv2v_0;
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
	input wire [31:0] integer_data;
	localparam riscv_v_pkg_RISCV_V_IMM_WIDTH = 5;
	input wire [4:0] imm;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [127:0] srca;
	input wire [127:0] srcb;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask;
	input wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_merge;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES = 5;
	input wire [4:0] osize_vector;
	input wire is_shift;
	input wire is_scalar;
	input wire is_scalar_int;
	input wire is_scalar_vec;
	input wire is_scalar_imm;
	input wire is_scalar_fp;
	input wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] rf_wr_en_mem;
	input wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] rf_wr_en_wb;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_RS_WIDTH = 5;
	input wire [4:0] rf_rd_addr_srca_exe;
	input wire [4:0] rf_rd_addr_srcb_exe;
	input wire [4:0] rf_merge_mask_addr_exe;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_RD_WIDTH = 5;
	input wire [4:0] rf_wr_addr_mem;
	input wire [4:0] rf_wr_addr_wb;
	input wire [127:0] rf_wr_data_mem;
	input wire [127:0] rf_wr_data_wb;
	output wire [127:0] srca_byp;
	output wire [127:0] srcb_byp;
	output reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_byp;
	output reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_merge_byp;
	wire rd_addr_A_mem_match;
	wire rd_addr_A_wb_match;
	wire rd_addr_B_mem_match;
	wire rd_addr_B_wb_match;
	wire mask_mem_match;
	wire mask_wb_match;
	wire mask_merge_mem_match;
	wire mask_merge_wb_match;
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] srca_mem_sel;
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] srca_wb_sel;
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] srcb_mem_sel;
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] srcb_wb_sel;
	localparam riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK = riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG / riscv_pkg_BYTE_WIDTH;
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK - 1:0] mask_mem_sel;
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK - 1:0] mask_wb_sel;
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK - 1:0] mask_merge_mem_sel;
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK - 1:0] mask_merge_wb_sel;
	reg [127:0] srca_vec_byp;
	reg [127:0] srcb_vec_byp;
	wire sign_imm_int;
	reg [127:0] sign_extended_data;
	wire [127:0] data_to_replicate;
	wire [127:0] data_replicated_osize [4:0];
	reg [127:0] data_replicated;
	assign rd_addr_A_mem_match = rf_rd_addr_srca_exe == rf_wr_addr_mem;
	assign rd_addr_A_wb_match = rf_rd_addr_srca_exe == rf_wr_addr_wb;
	assign rd_addr_B_mem_match = rf_rd_addr_srcb_exe == rf_wr_addr_mem;
	assign rd_addr_B_wb_match = rf_rd_addr_srcb_exe == rf_wr_addr_wb;
	localparam riscv_v_pkg_RISCV_V_MASK_RF_POS = 0;
	assign mask_mem_match = rf_wr_addr_mem == riscv_v_pkg_RISCV_V_MASK_RF_POS;
	assign mask_wb_match = rf_wr_addr_wb == riscv_v_pkg_RISCV_V_MASK_RF_POS;
	assign mask_merge_mem_match = rf_merge_mask_addr_exe == rf_wr_addr_mem;
	assign mask_merge_wb_match = rf_merge_mask_addr_exe == rf_wr_addr_wb;
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_1
			reg signed [31:0] idx;
			for (idx = 0; idx < riscv_v_pkg_RISCV_V_NUM_BYTES_DATA; idx = idx + 1)
				begin
					srca_mem_sel[idx] = rd_addr_A_mem_match && rf_wr_en_mem[idx];
					srca_wb_sel[idx] = rd_addr_A_wb_match && rf_wr_en_wb[idx];
				end
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_2
			reg signed [31:0] idx;
			for (idx = 0; idx < riscv_v_pkg_RISCV_V_NUM_BYTES_DATA; idx = idx + 1)
				begin
					srcb_mem_sel[idx] = rd_addr_B_mem_match && rf_wr_en_mem[idx];
					srcb_wb_sel[idx] = rd_addr_B_wb_match && rf_wr_en_wb[idx];
				end
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_3
			reg signed [31:0] idx;
			for (idx = 0; idx < riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK; idx = idx + 1)
				begin
					mask_mem_sel[idx] = mask_mem_match && rf_wr_en_mem[idx];
					mask_wb_sel[idx] = mask_wb_match && rf_wr_en_wb[idx];
				end
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_4
			reg signed [31:0] idx;
			for (idx = 0; idx < riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK; idx = idx + 1)
				begin
					mask_merge_mem_sel[idx] = mask_merge_mem_match && rf_wr_en_mem[idx];
					mask_merge_wb_sel[idx] = mask_merge_wb_match && rf_wr_en_wb[idx];
				end
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_5
			reg signed [31:0] idx;
			for (idx = 0; idx < riscv_v_pkg_RISCV_V_NUM_BYTES_DATA; idx = idx + 1)
				if (srca_mem_sel[idx])
					srca_vec_byp[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH] = rf_wr_data_mem[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH];
				else if (srca_wb_sel[idx])
					srca_vec_byp[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH] = rf_wr_data_wb[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH];
				else
					srca_vec_byp[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH] = srca[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH];
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_6
			reg signed [31:0] idx;
			for (idx = 0; idx < riscv_v_pkg_RISCV_V_NUM_BYTES_DATA; idx = idx + 1)
				if (srcb_mem_sel[idx])
					srcb_vec_byp[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH] = rf_wr_data_mem[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH];
				else if (srcb_wb_sel[idx])
					srcb_vec_byp[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH] = rf_wr_data_wb[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH];
				else
					srcb_vec_byp[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH] = srcb[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH];
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_7
			reg signed [31:0] idx;
			for (idx = 0; idx < riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK; idx = idx + 1)
				if (mask_mem_sel[idx])
					mask_byp[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = rf_wr_data_mem[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH];
				else if (mask_wb_sel[idx])
					mask_byp[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = rf_wr_data_wb[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH];
				else
					mask_byp[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = mask[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH];
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_8
			reg signed [31:0] idx;
			for (idx = 0; idx < riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK; idx = idx + 1)
				if (mask_merge_mem_sel[idx])
					mask_merge_byp[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = rf_wr_data_mem[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH];
				else if (mask_merge_wb_sel[idx])
					mask_merge_byp[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = rf_wr_data_wb[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH];
				else
					mask_merge_byp[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = mask_merge[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH];
		end
	end
	assign srca_byp = (is_scalar ? data_replicated : srca_vec_byp);
	assign srcb_byp = srcb_vec_byp;
	assign sign_imm_int = (is_scalar_imm ? imm[4] & ~is_shift : integer_data[31]);
	always @(*) begin
		if (_sv2v_0)
			;
		sign_extended_data[127:riscv_pkg_RISCV_DATA_WIDTH] = {riscv_v_pkg_RISCV_V_DATA_WIDTH - riscv_pkg_RISCV_DATA_WIDTH {sign_imm_int}};
		sign_extended_data[31:riscv_v_pkg_RISCV_V_IMM_WIDTH] = (is_scalar_imm ? {27 {sign_imm_int}} : integer_data[31:riscv_v_pkg_RISCV_V_IMM_WIDTH]);
		sign_extended_data[4:0] = (is_scalar_imm ? imm : integer_data[4:0]);
	end
	assign data_to_replicate = (is_scalar_vec ? srca_vec_byp : sign_extended_data);
	genvar _gv_osize_idx_24;
	generate
		for (_gv_osize_idx_24 = 0; _gv_osize_idx_24 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_24 = _gv_osize_idx_24 + 1) begin : genblk1
			localparam osize_idx = _gv_osize_idx_24;
			localparam OSIZE_WIDTH = (2 ** osize_idx) * riscv_pkg_BYTE_WIDTH;
			localparam NUM_BLOCKS_OSIZE = riscv_v_pkg_RISCV_V_DATA_WIDTH / OSIZE_WIDTH;
			assign data_replicated_osize[osize_idx] = {NUM_BLOCKS_OSIZE {data_to_replicate[OSIZE_WIDTH - 1:0]}};
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		data_replicated = 1'sb0;
		begin : sv2v_autoblock_9
			reg signed [31:0] osize_idx;
			for (osize_idx = 0; osize_idx < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; osize_idx = osize_idx + 1)
				data_replicated = data_replicated | (data_replicated_osize[osize_idx] & {riscv_v_pkg_RISCV_V_DATA_WIDTH {osize_vector[osize_idx]}});
		end
	end
	initial _sv2v_0 = 0;
endmodule
