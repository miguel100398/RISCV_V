module riscv_v_extend (
	is_zero_ext,
	is_sign_ext,
	src_osize_vector,
	dst_osize_vector,
	src,
	result
);
	reg _sv2v_0;
	input wire is_zero_ext;
	input wire is_sign_ext;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES = 5;
	input wire [4:0] src_osize_vector;
	input wire [4:0] dst_osize_vector;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] src;
	output wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] result;
	localparam NUM_EXT_BLOCKS = riscv_v_pkg_RISCV_V_NUM_BYTES_DATA;
	wire is_ext;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] src_gated;
	reg [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] src_ext_osize [4:1][3:0];
	reg [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] src_ext_osize_sel;
	assign is_ext = is_zero_ext | is_sign_ext;
	genvar _gv_block_23;
	generate
		for (_gv_block_23 = 0; _gv_block_23 < NUM_EXT_BLOCKS; _gv_block_23 = _gv_block_23 + 1) begin : gen_gate_src
			localparam block = _gv_block_23;
			assign src_gated[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = src[(128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (127 - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (block * riscv_pkg_BYTE_WIDTH))))+:riscv_pkg_BYTE_WIDTH] & {riscv_pkg_BYTE_WIDTH {is_ext}};
		end
	endgenerate
	genvar _gv_dst_osize_idx_1;
	generate
		for (_gv_dst_osize_idx_1 = 1; _gv_dst_osize_idx_1 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_dst_osize_idx_1 = _gv_dst_osize_idx_1 + 1) begin : gen_dst_osize_shift
			localparam dst_osize_idx = _gv_dst_osize_idx_1;
			genvar _gv_src_osize_idx_1;
			for (_gv_src_osize_idx_1 = 0; _gv_src_osize_idx_1 < dst_osize_idx; _gv_src_osize_idx_1 = _gv_src_osize_idx_1 + 1) begin : gen_src_osize_shift
				localparam src_osize_idx = _gv_src_osize_idx_1;
				localparam SRC_WIDTH = riscv_pkg_BYTE_WIDTH * (2 ** src_osize_idx);
				localparam DEST_WIDTH = riscv_pkg_BYTE_WIDTH * (2 ** dst_osize_idx);
				localparam NUM_ELEMENTS_DEST = riscv_v_pkg_RISCV_V_DATA_WIDTH / DEST_WIDTH;
				localparam DEST_OFFSET = 2 ** dst_osize_idx;
				localparam SRC_OFFSET = 2 ** src_osize_idx;
				localparam NUM_BYTES_SRC = SRC_WIDTH / riscv_pkg_BYTE_WIDTH;
				localparam NUM_BYTES_DST = DEST_WIDTH / riscv_pkg_BYTE_WIDTH;
				localparam SIGN_WIDTH = DEST_WIDTH - SRC_WIDTH;
				always @(*) begin
					if (_sv2v_0)
						;
					src_ext_osize[dst_osize_idx][src_osize_idx] = 1'sb0;
					begin : sv2v_autoblock_1
						reg signed [31:0] element_idx;
						for (element_idx = 0; element_idx < NUM_ELEMENTS_DEST; element_idx = element_idx + 1)
							src_ext_osize[dst_osize_idx][src_osize_idx][riscv_pkg_BYTE_WIDTH * (element_idx * DEST_OFFSET)+:riscv_pkg_BYTE_WIDTH * NUM_BYTES_DST] = {{SIGN_WIDTH {src_gated[(((element_idx * SRC_OFFSET) + (NUM_BYTES_SRC - 1)) * riscv_pkg_BYTE_WIDTH) + 7] & is_sign_ext}}, src_gated[riscv_pkg_BYTE_WIDTH * (element_idx * SRC_OFFSET)+:riscv_pkg_BYTE_WIDTH * NUM_BYTES_SRC]} & {DEST_WIDTH {src_osize_vector[src_osize_idx] && dst_osize_vector[dst_osize_idx]}};
					end
				end
			end
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		src_ext_osize_sel = 1'sb0;
		begin : sv2v_autoblock_2
			reg signed [31:0] dst_osize_idx;
			for (dst_osize_idx = 1; dst_osize_idx < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; dst_osize_idx = dst_osize_idx + 1)
				begin : sv2v_autoblock_3
					reg signed [31:0] src_osize_idx;
					for (src_osize_idx = 0; src_osize_idx < dst_osize_idx; src_osize_idx = src_osize_idx + 1)
						begin : gen_src_osize_shift
							src_ext_osize_sel = src_ext_osize_sel | src_ext_osize[dst_osize_idx][src_osize_idx];
						end
				end
		end
	end
	assign result = src_ext_osize_sel;
	initial _sv2v_0 = 0;
endmodule
