module riscv_v_rf (
	clk,
	wr_addr,
	mask_merge_addr,
	rd_addr_A,
	rd_addr_B,
	data_in,
	wr_en,
	data_out_A,
	data_out_B,
	mask,
	mask_merge,
	syn_addr,
	syn_data
);
	reg _sv2v_0;
	localparam [0:0] RD_ASYNC = 1'b1;
	localparam [0:0] REG_INPUTS = 1'b0;
	localparam [0:0] USE_BYPASS = 1'b1;
	input wire clk;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_RF_NUM_REGS = 32;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_RF_ADDR_WIDTH = 5;
	input wire [4:0] wr_addr;
	input wire [4:0] mask_merge_addr;
	input wire [4:0] rd_addr_A;
	input wire [4:0] rd_addr_B;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [127:0] data_in;
	input wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] wr_en;
	output reg [127:0] data_out_A;
	output reg [127:0] data_out_B;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	output reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask;
	output reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_merge;
	input wire [4:0] syn_addr;
	output wire [127:0] syn_data;
	reg [4095:0] regs;
	reg [4095:0] regs_nxt;
	reg [4:0] wr_addr_int;
	reg [4:0] mask_merge_addr_int;
	reg [4:0] rd_addr_A_int;
	reg [4:0] rd_addr_B_int;
	reg [127:0] data_in_int;
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] wr_en_int;
	assign syn_data = regs[(31 - syn_addr) * 128+:128];
	localparam riscv_v_pkg_RISCV_V_MASK_RF_POS = 0;
	localparam riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK = riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG / riscv_pkg_BYTE_WIDTH;
	generate
		if (RD_ASYNC) begin : GEN_READ_MASK_ASYNC
			if (USE_BYPASS) begin : GEN_READ_MASK_BYPASS
				wire wr_addr_match_mask;
				assign wr_addr_match_mask = wr_addr_int == riscv_v_pkg_RISCV_V_MASK_RF_POS;
				always @(*) begin
					if (_sv2v_0)
						;
					begin : sv2v_autoblock_1
						reg signed [31:0] idx;
						for (idx = 0; idx < riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK; idx = idx + 1)
							if (wr_en_int[idx] && wr_addr_match_mask)
								mask[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = data_in[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH];
							else
								mask[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = regs[3968 + (idx * riscv_pkg_BYTE_WIDTH)+:riscv_pkg_BYTE_WIDTH];
					end
				end
			end
			else begin : BEGIN_READ_MASK_NO_BYPASS
				wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG:1] sv2v_tmp_32FC6;
				assign sv2v_tmp_32FC6 = regs[riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG + 3967-:riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG];
				always @(*) mask = sv2v_tmp_32FC6;
			end
		end
		else begin : GEN_READ_MASK_SYNC
			always @(posedge clk) mask <= regs[riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG + 3967-:riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG];
		end
		if (REG_INPUTS) begin : GEN_REG_INPUTS
			always @(posedge clk) begin
				wr_addr_int <= wr_addr;
				mask_merge_addr_int <= mask_merge_addr;
				rd_addr_A_int <= rd_addr_A;
				rd_addr_B_int <= rd_addr_B;
				data_in_int <= data_in;
				wr_en_int <= wr_en;
			end
		end
		else begin : GEN_BYPASS_INPUTS
			always @(*) begin
				if (_sv2v_0)
					;
				wr_addr_int = wr_addr;
				mask_merge_addr_int = mask_merge_addr;
				rd_addr_A_int = rd_addr_A;
				rd_addr_B_int = rd_addr_B;
				data_in_int = data_in;
				wr_en_int = wr_en;
			end
		end
		if (RD_ASYNC) begin : GEN_READ_MERGE_MASK_ASYNC
			if (USE_BYPASS) begin : GEN_READ_MERGE_MASK_BYPASS
				wire wr_addr_match_merge_mask;
				assign wr_addr_match_merge_mask = wr_addr_int == mask_merge_addr_int;
				always @(*) begin
					if (_sv2v_0)
						;
					begin : sv2v_autoblock_2
						reg signed [31:0] idx;
						for (idx = 0; idx < riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK; idx = idx + 1)
							if (wr_en_int[idx] && wr_addr_match_merge_mask)
								mask_merge[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = data_in[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH];
							else
								mask_merge[idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = regs[((31 - mask_merge_addr_int) * 128) + (idx * riscv_pkg_BYTE_WIDTH)+:riscv_pkg_BYTE_WIDTH];
					end
				end
			end
			else begin : GEN_READ_MERGE_MASK_NO_BYPASS
				wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG:1] sv2v_tmp_5A4A7;
				assign sv2v_tmp_5A4A7 = regs[((31 - mask_merge_addr_int) * 128) + (riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1)-:riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG];
				always @(*) mask_merge = sv2v_tmp_5A4A7;
			end
		end
		else begin : GEN_READ_MERGE_MASK_SYNC
			always @(posedge clk) mask_merge = regs[((31 - mask_merge_addr_int) * 128) + (riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1)-:riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG];
		end
		if (RD_ASYNC) begin : GEN_READ_SRCA_ASYNC
			if (USE_BYPASS) begin : GEN_READ_SRCA_BYPASS
				wire wr_addr_match_srca;
				assign wr_addr_match_srca = wr_addr_int == rd_addr_A_int;
				always @(*) begin
					if (_sv2v_0)
						;
					begin : sv2v_autoblock_3
						reg signed [31:0] idx;
						for (idx = 0; idx < riscv_v_pkg_RISCV_V_NUM_BYTES_DATA; idx = idx + 1)
							if (wr_en_int[idx] && wr_addr_match_srca)
								data_out_A[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH] = data_in[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH];
							else
								data_out_A[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH] = regs[((31 - rd_addr_A_int) * 128) + (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH)))+:riscv_pkg_BYTE_WIDTH];
					end
				end
			end
			else begin : GEN_READ_SRCA_NO_BYPASS
				wire [128:1] sv2v_tmp_0D15D;
				assign sv2v_tmp_0D15D = regs[(31 - rd_addr_A_int) * 128+:128];
				always @(*) data_out_A = sv2v_tmp_0D15D;
			end
		end
		else begin : GEN_READ_SRCA_SYNC
			always @(posedge clk) data_out_A <= regs[(31 - rd_addr_A_int) * 128+:128];
		end
		if (RD_ASYNC) begin : GEN_READ_SRCB_ASYNC
			if (USE_BYPASS) begin : GEN_READ_SRCB_BYPASS
				wire wr_addr_match_srcb;
				assign wr_addr_match_srcb = wr_addr_int == rd_addr_B_int;
				always @(*) begin
					if (_sv2v_0)
						;
					begin : sv2v_autoblock_4
						reg signed [31:0] idx;
						for (idx = 0; idx < riscv_v_pkg_RISCV_V_NUM_BYTES_DATA; idx = idx + 1)
							if (wr_en_int[idx] && wr_addr_match_srcb)
								data_out_B[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH] = data_in[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH];
							else
								data_out_B[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH] = regs[((31 - rd_addr_B_int) * 128) + (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (idx * riscv_pkg_BYTE_WIDTH)))+:riscv_pkg_BYTE_WIDTH];
					end
				end
			end
			else begin : GEN_READ_SRCB_NO_BYPASS
				wire [128:1] sv2v_tmp_10C6D;
				assign sv2v_tmp_10C6D = regs[(31 - rd_addr_B_int) * 128+:128];
				always @(*) data_out_B = sv2v_tmp_10C6D;
			end
		end
		else begin : GEN_READ_SRCB_SYNC
			always @(posedge clk) data_out_B <= regs[(31 - rd_addr_B_int) * 128+:128];
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		regs_nxt = regs;
		begin : sv2v_autoblock_5
			reg signed [31:0] byte_reg;
			for (byte_reg = 0; byte_reg < riscv_v_pkg_RISCV_V_NUM_BYTES_DATA; byte_reg = byte_reg + 1)
				regs_nxt[((31 - wr_addr_int) * 128) + (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (byte_reg * riscv_pkg_BYTE_WIDTH)))+:riscv_pkg_BYTE_WIDTH] = (wr_en_int[byte_reg] ? data_in_int[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (byte_reg * riscv_pkg_BYTE_WIDTH))+:riscv_pkg_BYTE_WIDTH] : regs[((31 - wr_addr_int) * 128) + (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (byte_reg * riscv_pkg_BYTE_WIDTH)))+:riscv_pkg_BYTE_WIDTH]);
		end
	end
	always @(posedge clk) regs <= regs_nxt;
	initial _sv2v_0 = 0;
endmodule
