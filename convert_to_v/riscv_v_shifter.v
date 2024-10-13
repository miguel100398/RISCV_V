module riscv_v_shifter (
	is_shift,
	is_left,
	is_arith,
	osize_vector,
	is_greater_osize_vector,
	srca,
	srcb,
	result
);
	reg _sv2v_0;
	input wire is_shift;
	input wire is_left;
	input wire is_arith;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES = 5;
	input wire [4:0] osize_vector;
	input wire [4:0] is_greater_osize_vector;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srca;
	input wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srcb;
	output wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] result;
	localparam NUM_SHIFT_BLOCKS = riscv_v_pkg_RISCV_V_NUM_BYTES_DATA;
	localparam BLOCK_SELECTOR_WIDTH = 3;
	localparam BYTE_SELECTOR_WIDTH = $clog2(NUM_SHIFT_BLOCKS);
	localparam SELECTOR_WIDTH = BLOCK_SELECTOR_WIDTH + BYTE_SELECTOR_WIDTH;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] srca_gated;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] srcb_gated;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] srcb_swizzle;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] srcb_merge_swizzle;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] selected_merge;
	wire [NUM_SHIFT_BLOCKS - 1:0] shifter_arith_vector;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] srcb_shift_selected;
	reg [7:0] mux_shift_block [BYTE_SELECTOR_WIDTH - 1:0][NUM_SHIFT_BLOCKS - 1:0];
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] shifter_shift_in;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] shifter_result;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] shifter_result_swizzle;
	wire [(NUM_SHIFT_BLOCKS * SELECTOR_WIDTH) - 1:0] shift_cnt_osize [4:0];
	wire [SELECTOR_WIDTH - 1:0] shift_cnt_osize_qual [4:0][NUM_SHIFT_BLOCKS - 1:0];
	reg [(NUM_SHIFT_BLOCKS * SELECTOR_WIDTH) - 1:0] shift_cnt;
	wire [(NUM_SHIFT_BLOCKS * SELECTOR_WIDTH) - 1:0] shift_cnt_swizzle;
	wire [(NUM_SHIFT_BLOCKS * SELECTOR_WIDTH) - 1:0] shift_cnt_sel;
	wire [SELECTOR_WIDTH - 1:0] selector_mask;
	assign selector_mask[2:0] = {BLOCK_SELECTOR_WIDTH {1'b1}};
	genvar _gv_block_idx_1;
	generate
		for (_gv_block_idx_1 = BLOCK_SELECTOR_WIDTH; _gv_block_idx_1 < SELECTOR_WIDTH; _gv_block_idx_1 = _gv_block_idx_1 + 1) begin : genblk1
			localparam block_idx = _gv_block_idx_1;
			assign selector_mask[block_idx] = is_greater_osize_vector[(block_idx - BLOCK_SELECTOR_WIDTH) + 1];
		end
	endgenerate
	genvar _gv_block_5;
	generate
		for (_gv_block_5 = 0; _gv_block_5 < NUM_SHIFT_BLOCKS; _gv_block_5 = _gv_block_5 + 1) begin : gen_srcb_gated
			localparam block = _gv_block_5;
			assign srcb_gated[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = srcb[(128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (127 - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (block * riscv_pkg_BYTE_WIDTH))))+:riscv_pkg_BYTE_WIDTH] & {riscv_pkg_BYTE_WIDTH {is_shift}};
			assign srca_gated[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = srca[(128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (127 - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (block * riscv_pkg_BYTE_WIDTH))))+:riscv_pkg_BYTE_WIDTH] & {riscv_pkg_BYTE_WIDTH {is_shift}};
		end
	endgenerate
	genvar _gv_block_6;
	generate
		for (_gv_block_6 = 0; _gv_block_6 < NUM_SHIFT_BLOCKS; _gv_block_6 = _gv_block_6 + 1) begin : gen_srcb_swizzle
			localparam block = _gv_block_6;
			assign srcb_swizzle[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = srcb_gated[((NUM_SHIFT_BLOCKS - 1) - block) * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH];
			assign srcb_merge_swizzle[block] = srcb[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - ((NUM_SHIFT_BLOCKS - 1) - block))];
			assign shift_cnt_swizzle[block * SELECTOR_WIDTH+:SELECTOR_WIDTH] = shift_cnt[((NUM_SHIFT_BLOCKS - 1) - block) * SELECTOR_WIDTH+:SELECTOR_WIDTH];
		end
	endgenerate
	assign srcb_shift_selected = (is_left ? srcb_swizzle : srcb_gated);
	genvar _gv_osize_idx_5;
	generate
		for (_gv_osize_idx_5 = 0; _gv_osize_idx_5 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_5 = _gv_osize_idx_5 + 1) begin : gen_shift_cnt_osize
			localparam osize_idx = _gv_osize_idx_5;
			localparam OSIZE_WIDTH = 8 * (2 ** osize_idx);
			localparam NUM_BLOCKS_OSIZE = riscv_v_pkg_RISCV_V_DATA_WIDTH / OSIZE_WIDTH;
			localparam NUM_REPLICATE_BLOCKS = NUM_SHIFT_BLOCKS / NUM_BLOCKS_OSIZE;
			genvar _gv_block_idx_2;
			for (_gv_block_idx_2 = 0; _gv_block_idx_2 < NUM_BLOCKS_OSIZE; _gv_block_idx_2 = _gv_block_idx_2 + 1) begin : gen_shift_cnt_block
				localparam block_idx = _gv_block_idx_2;
				wire [SELECTOR_WIDTH - 1:0] srca_byte_sel;
				assign srca_byte_sel = srca_gated[(block_idx * NUM_REPLICATE_BLOCKS) * riscv_pkg_BYTE_WIDTH+:SELECTOR_WIDTH] & selector_mask;
				assign shift_cnt_osize[osize_idx][SELECTOR_WIDTH * (block_idx * NUM_REPLICATE_BLOCKS)+:SELECTOR_WIDTH * NUM_REPLICATE_BLOCKS] = {NUM_REPLICATE_BLOCKS {srca_byte_sel}};
			end
			genvar _gv_block_idx_3;
			for (_gv_block_idx_3 = 0; _gv_block_idx_3 < NUM_SHIFT_BLOCKS; _gv_block_idx_3 = _gv_block_idx_3 + 1) begin : gen_shift_cnt_qual
				localparam block_idx = _gv_block_idx_3;
				assign shift_cnt_osize_qual[osize_idx][block_idx] = shift_cnt_osize[osize_idx][block_idx * SELECTOR_WIDTH+:SELECTOR_WIDTH] & {SELECTOR_WIDTH {osize_vector[osize_idx]}};
			end
		end
	endgenerate
	always @(*) begin
		shift_cnt = 0;
		begin : sv2v_autoblock_1
			reg signed [31:0] osize_idx;
			for (osize_idx = 0; osize_idx < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; osize_idx = osize_idx + 1)
				begin : sv2v_autoblock_2
					reg signed [31:0] block_idx;
					for (block_idx = 0; block_idx < NUM_SHIFT_BLOCKS; block_idx = block_idx + 1)
						shift_cnt[block_idx * SELECTOR_WIDTH+:SELECTOR_WIDTH] = shift_cnt[block_idx * SELECTOR_WIDTH+:SELECTOR_WIDTH] | shift_cnt_osize_qual[osize_idx][block_idx];
				end
		end
	end
	assign shift_cnt_sel = (is_left ? shift_cnt_swizzle : shift_cnt);
	genvar _gv_block_7;
	generate
		for (_gv_block_7 = 0; _gv_block_7 < (NUM_SHIFT_BLOCKS - 1); _gv_block_7 = _gv_block_7 + 1) begin : gen_selected_merge
			localparam block = _gv_block_7;
			assign selected_merge[block] = (is_left ? srcb_merge_swizzle[block + 1] : srcb[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - block)]);
		end
	endgenerate
	assign selected_merge[NUM_SHIFT_BLOCKS - 1] = 1'b0;
	genvar _gv_mux_idx_1;
	generate
		for (_gv_mux_idx_1 = 0; _gv_mux_idx_1 < NUM_SHIFT_BLOCKS; _gv_mux_idx_1 = _gv_mux_idx_1 + 1) begin : gen_mux_first_stage
			localparam mux_idx = _gv_mux_idx_1;
			if (mux_idx < (NUM_SHIFT_BLOCKS - 1)) begin : genblk1
				always @(*) begin
					if (_sv2v_0)
						;
					if (shift_cnt_sel[(mux_idx * SELECTOR_WIDTH) + 3]) begin
						if (selected_merge[mux_idx])
							mux_shift_block[0][mux_idx] = srcb_shift_selected[(mux_idx + 1) * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH];
						else
							mux_shift_block[0][mux_idx] = {riscv_pkg_BYTE_WIDTH {srcb_shift_selected[(((((mux_idx / 2) + 1) * 2) - 1) * riscv_pkg_BYTE_WIDTH) + 7]}} & {riscv_pkg_BYTE_WIDTH {is_arith}};
					end
					else
						mux_shift_block[0][mux_idx] = srcb_shift_selected[mux_idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH];
				end
			end
			else begin : genblk1
				always @(*) begin
					if (_sv2v_0)
						;
					if (shift_cnt_sel[(mux_idx * SELECTOR_WIDTH) + 3])
						mux_shift_block[0][mux_idx] = {riscv_pkg_BYTE_WIDTH {srcb_shift_selected[(((((mux_idx / 2) + 1) * 2) - 1) * riscv_pkg_BYTE_WIDTH) + 7]}} & {riscv_pkg_BYTE_WIDTH {is_arith}};
					else
						mux_shift_block[0][mux_idx] = srcb_shift_selected[mux_idx * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH];
				end
			end
		end
	endgenerate
	genvar _gv_mux_stage_1;
	generate
		for (_gv_mux_stage_1 = 1; _gv_mux_stage_1 < BYTE_SELECTOR_WIDTH; _gv_mux_stage_1 = _gv_mux_stage_1 + 1) begin : gen_mux_stage
			localparam mux_stage = _gv_mux_stage_1;
			genvar _gv_mux_idx_2;
			for (_gv_mux_idx_2 = 0; _gv_mux_idx_2 < NUM_SHIFT_BLOCKS; _gv_mux_idx_2 = _gv_mux_idx_2 + 1) begin : gen_mux_idx
				localparam mux_idx = _gv_mux_idx_2;
				if (mux_idx < (NUM_SHIFT_BLOCKS - (2 ** mux_stage))) begin : genblk1
					always @(*) begin
						if (_sv2v_0)
							;
						if (shift_cnt_sel[(mux_idx * SELECTOR_WIDTH) + (mux_stage + BLOCK_SELECTOR_WIDTH)]) begin
							if (&selected_merge[mux_idx+:2 ** mux_stage])
								mux_shift_block[mux_stage][mux_idx] = mux_shift_block[mux_stage - 1][mux_idx + (2 ** mux_stage)];
							else
								mux_shift_block[mux_stage][mux_idx] = {riscv_pkg_BYTE_WIDTH {mux_shift_block[mux_stage - 1][(((mux_idx / (2 ** mux_stage)) + 1) * (2 ** mux_stage)) - 1][7]}} & {riscv_pkg_BYTE_WIDTH {is_arith}};
						end
						else
							mux_shift_block[mux_stage][mux_idx] = mux_shift_block[mux_stage - 1][mux_idx];
					end
				end
				else begin : genblk1
					always @(*) begin
						if (_sv2v_0)
							;
						if (shift_cnt_sel[(mux_idx * SELECTOR_WIDTH) + (mux_stage + BLOCK_SELECTOR_WIDTH)])
							mux_shift_block[mux_stage][mux_idx] = {riscv_pkg_BYTE_WIDTH {mux_shift_block[mux_stage - 1][(((mux_idx / (2 ** mux_stage)) + 1) * (2 ** mux_stage)) - 1][7]}} & {riscv_pkg_BYTE_WIDTH {is_arith}};
						else
							mux_shift_block[mux_stage][mux_idx] = mux_shift_block[mux_stage - 1][mux_idx];
					end
				end
			end
		end
	endgenerate
	genvar _gv_block_8;
	generate
		for (_gv_block_8 = 0; _gv_block_8 < (NUM_SHIFT_BLOCKS - 1); _gv_block_8 = _gv_block_8 + 1) begin : gen_shift_in
			localparam block = _gv_block_8;
			assign shifter_shift_in[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = mux_shift_block[BYTE_SELECTOR_WIDTH - 1][block + 1] & {riscv_pkg_BYTE_WIDTH {selected_merge[block]}};
		end
	endgenerate
	assign shifter_shift_in[(NUM_SHIFT_BLOCKS - 1) * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = {riscv_pkg_BYTE_WIDTH {1'b0}};
	genvar _gv_block_9;
	generate
		for (_gv_block_9 = 0; _gv_block_9 < NUM_SHIFT_BLOCKS; _gv_block_9 = _gv_block_9 + 1) begin : gen_shifters
			localparam block = _gv_block_9;
			assign shifter_arith_vector[block] = ~selected_merge[block] & is_arith;
			shifter #(.WIDTH(riscv_pkg_BYTE_WIDTH)) byte_shifter(
				.src(mux_shift_block[BYTE_SELECTOR_WIDTH - 1][block]),
				.shift(shift_cnt_sel[block * SELECTOR_WIDTH+:BLOCK_SELECTOR_WIDTH]),
				.shift_left(is_left),
				.shift_arith(shifter_arith_vector[block]),
				.shift_in(shifter_shift_in[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH]),
				.result(shifter_result[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH])
			);
		end
	endgenerate
	genvar _gv_block_10;
	generate
		for (_gv_block_10 = 0; _gv_block_10 < NUM_SHIFT_BLOCKS; _gv_block_10 = _gv_block_10 + 1) begin : swizzle_shifter_result
			localparam block = _gv_block_10;
			assign shifter_result_swizzle[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = shifter_result[((NUM_SHIFT_BLOCKS - 1) - block) * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH];
		end
	endgenerate
	genvar _gv_block_11;
	generate
		for (_gv_block_11 = 0; _gv_block_11 < NUM_SHIFT_BLOCKS; _gv_block_11 = _gv_block_11 + 1) begin : gen_shift_result
			localparam block = _gv_block_11;
			assign result[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = (is_left ? shifter_result_swizzle[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] : shifter_result[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH]);
		end
	endgenerate
	initial _sv2v_0 = 0;
endmodule
