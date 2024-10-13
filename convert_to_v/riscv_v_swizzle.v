module riscv_v_swizzle (
	src_data,
	invert,
	osize_vec,
	result
);
	reg _sv2v_0;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [127:0] src_data;
	input wire invert;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES = 5;
	input wire [4:0] osize_vec;
	output wire [127:0] result;
	reg [127:0] data_swizzle [0:4];
	reg [127:0] data_swizzle_sel;
	genvar _gv_osize_idx_25;
	generate
		for (_gv_osize_idx_25 = 0; _gv_osize_idx_25 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_25 = _gv_osize_idx_25 + 1) begin : genblk1
			localparam osize_idx = _gv_osize_idx_25;
			localparam BLOCK_WIDTH = riscv_pkg_BYTE_WIDTH * (2 ** osize_idx);
			localparam NUM_BLOCKS = riscv_v_pkg_RISCV_V_DATA_WIDTH / BLOCK_WIDTH;
			always @(*) begin
				if (_sv2v_0)
					;
				begin : sv2v_autoblock_1
					reg signed [31:0] idx;
					for (idx = 0; idx < NUM_BLOCKS; idx = idx + 1)
						data_swizzle[osize_idx][127 - (idx * BLOCK_WIDTH)-:BLOCK_WIDTH] = src_data[idx * BLOCK_WIDTH+:BLOCK_WIDTH];
				end
			end
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		data_swizzle_sel = 1'sb0;
		begin : sv2v_autoblock_2
			reg signed [31:0] osize_idx;
			for (osize_idx = 0; osize_idx < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; osize_idx = osize_idx + 1)
				data_swizzle_sel = data_swizzle_sel | (data_swizzle[osize_idx] & {riscv_v_pkg_RISCV_V_DATA_WIDTH {osize_vec[osize_idx]}});
		end
	end
	assign result = (invert ? data_swizzle_sel : src_data);
	initial _sv2v_0 = 0;
endmodule
