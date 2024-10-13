module riscv_v_decode_element (
	srca_addr,
	srca,
	srcb,
	vtype,
	vl,
	vstart,
	is_zero_ext,
	is_sign_ext,
	is_v2i,
	is_i2v,
	is_mask,
	is_reduct,
	is_compare,
	use_mask,
	mask,
	mask_merge,
	srca_alu,
	srcb_alu,
	mask_osize_sel,
	mask_merge_qual,
	mask_result_valid,
	len,
	osize,
	dst_osize_vector,
	src_osize_vector,
	is_greater_osize_vector,
	is_less_osize_vector
);
	reg _sv2v_0;
	localparam signed [31:0] riscv_pkg_RISCV_INSTR_RS_WIDTH = 5;
	input wire [4:0] srca_addr;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [127:0] srca;
	input wire [127:0] srcb;
	input wire [8:0] vtype;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_MAX_LMUL = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_MAX_VLEN = riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG * riscv_v_pkg_RISCV_V_MAX_LMUL;
	input wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vl;
	input wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vstart;
	input wire is_zero_ext;
	input wire is_sign_ext;
	input wire is_v2i;
	input wire is_i2v;
	input wire is_mask;
	input wire is_reduct;
	input wire is_compare;
	input wire use_mask;
	input wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask;
	input wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_merge;
	output reg [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srca_alu;
	output reg [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srcb_alu;
	output reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_osize_sel;
	output reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_merge_qual;
	output reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_result_valid;
	output wire [$clog2(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA):0] len;
	output wire [2:0] osize;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES = 5;
	output wire [4:0] dst_osize_vector;
	output wire [4:0] src_osize_vector;
	output wire [4:0] is_greater_osize_vector;
	output wire [4:0] is_less_osize_vector;
	wire is_extend;
	wire [2:0] dst_osize;
	reg [4:0] src_osize_vector_ext;
	localparam riscv_v_pkg_RISCV_V_OSIZE_SHIFT_STICKY_WIDTH = 2;
	reg [1:0] src_osize_vector_sticky;
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] merge_osize [4:1];
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] valid_osize [4:0];
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] valid_osize_sel;
	wire len_greater_than [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0];
	wire start_less_than [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0];
	wire len_start_vec [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0];
	wire [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] mask_osize [0:4];
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] mask_valid;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] is_mask_valid;
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] is_reduct_osize [0:3];
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] is_reduct_osize_sel;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] is_reduct_valid;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] i2v_mask;
	function automatic [2:0] sv2v_cast_3;
		input reg [2:0] inp;
		sv2v_cast_3 = inp;
	endfunction
	assign dst_osize = sv2v_cast_3(vtype[5-:3]);
	assign dst_osize_vector[0] = dst_osize == 3'd0;
	assign dst_osize_vector[1] = dst_osize == 3'd1;
	assign dst_osize_vector[2] = dst_osize == 3'd2;
	assign dst_osize_vector[3] = dst_osize == 3'd3;
	assign dst_osize_vector[4] = dst_osize == 3'd4;
	assign is_extend = is_zero_ext | is_sign_ext;
	localparam riscv_v_pkg_RISCV_V_EXTEND_SHIFT_BEGIN = 1;
	localparam riscv_v_pkg_RISCV_V_EXTEND_SHIFT_END = 2;
	localparam [1:0] riscv_v_pkg_RISCV_V_EXT_SHIFT_1 = 2'b11;
	localparam [1:0] riscv_v_pkg_RISCV_V_EXT_SHIFT_2 = 2'b10;
	localparam [1:0] riscv_v_pkg_RISCV_V_EXT_SHIFT_3 = 2'b01;
	always @(*) begin
		if (_sv2v_0)
			;
		(* full_case, parallel_case *)
		case (srca_addr[riscv_v_pkg_RISCV_V_EXTEND_SHIFT_END:riscv_v_pkg_RISCV_V_EXTEND_SHIFT_BEGIN])
			riscv_v_pkg_RISCV_V_EXT_SHIFT_3: {src_osize_vector_ext, src_osize_vector_sticky} = {dst_osize_vector, {riscv_v_pkg_RISCV_V_OSIZE_SHIFT_STICKY_WIDTH {1'b0}}} >> 3;
			riscv_v_pkg_RISCV_V_EXT_SHIFT_2: {src_osize_vector_ext, src_osize_vector_sticky} = {dst_osize_vector, {riscv_v_pkg_RISCV_V_OSIZE_SHIFT_STICKY_WIDTH {1'b0}}} >> 2;
			riscv_v_pkg_RISCV_V_EXT_SHIFT_1: {src_osize_vector_ext, src_osize_vector_sticky} = {dst_osize_vector, {riscv_v_pkg_RISCV_V_OSIZE_SHIFT_STICKY_WIDTH {1'b0}}} >> 1;
			default: src_osize_vector_ext = 1'sbx;
		endcase
		src_osize_vector_ext[0] = src_osize_vector_ext[0] | (|src_osize_vector_sticky);
	end
	assign src_osize_vector = (is_extend ? src_osize_vector_ext : dst_osize_vector);
	assign is_greater_osize_vector[0] = 1'b1;
	genvar _gv_osize_idx_17;
	generate
		for (_gv_osize_idx_17 = 1; _gv_osize_idx_17 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_17 = _gv_osize_idx_17 + 1) begin : gen_is_greater_osize_vector
			localparam osize_idx = _gv_osize_idx_17;
			assign is_greater_osize_vector[osize_idx] = |dst_osize_vector[4:osize_idx];
		end
	endgenerate
	assign is_less_osize_vector[4] = 1'b1;
	genvar _gv_osize_idx_18;
	generate
		for (_gv_osize_idx_18 = 0; _gv_osize_idx_18 < 4; _gv_osize_idx_18 = _gv_osize_idx_18 + 1) begin : gen_is_less_osize_vector
			localparam osize_idx = _gv_osize_idx_18;
			assign is_less_osize_vector[osize_idx] = ~is_greater_osize_vector[osize_idx + 1];
		end
	endgenerate
	genvar _gv_len_idx_1;
	generate
		for (_gv_len_idx_1 = 0; _gv_len_idx_1 < riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG; _gv_len_idx_1 = _gv_len_idx_1 + 1) begin : gen_len_greater_than
			localparam len_idx = _gv_len_idx_1;
			assign len_greater_than[len_idx] = $unsigned(vl[$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1-:$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN)]) >= $unsigned(len_idx + 1);
		end
	endgenerate
	genvar _gv_start_idx_1;
	generate
		for (_gv_start_idx_1 = 0; _gv_start_idx_1 < riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG; _gv_start_idx_1 = _gv_start_idx_1 + 1) begin : gen_start_less_than
			localparam start_idx = _gv_start_idx_1;
			assign start_less_than[start_idx] = $unsigned(vstart[$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1-:$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN)]) < $unsigned(start_idx + 1);
		end
	endgenerate
	genvar _gv_idx_2;
	generate
		for (_gv_idx_2 = 0; _gv_idx_2 < riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG; _gv_idx_2 = _gv_idx_2 + 1) begin : gen_len_start_vec
			localparam idx = _gv_idx_2;
			assign len_start_vec[idx] = len_greater_than[idx] & start_less_than[idx];
		end
	endgenerate
	assign i2v_mask[0] = 1'b1;
	genvar _gv_osize_idx_19;
	generate
		for (_gv_osize_idx_19 = 1; _gv_osize_idx_19 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_19 = _gv_osize_idx_19 + 1) begin : gen_i2v_mask
			localparam osize_idx = _gv_osize_idx_19;
			assign i2v_mask[(2 ** osize_idx) - 1-:2 ** (osize_idx - 1)] = {2 ** (osize_idx - 1) {~is_i2v || is_greater_osize_vector[osize_idx]}};
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_1
			reg signed [31:0] idx;
			for (idx = 0; idx < riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG; idx = idx + 1)
				mask_result_valid[idx] = len_start_vec[idx];
		end
		begin : sv2v_autoblock_2
			reg signed [31:0] idx;
			for (idx = 0; idx < riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG; idx = idx + 1)
				mask_result_valid[idx] = mask_result_valid[idx] & ~(((use_mask & ~mask[idx]) | ~is_less_osize_vector[4 - $clog2(idx + 1)]) & is_compare);
		end
	end
	genvar _gv_osize_idx_20;
	generate
		for (_gv_osize_idx_20 = 0; _gv_osize_idx_20 < 4; _gv_osize_idx_20 = _gv_osize_idx_20 + 1) begin : gen_reduct
			localparam osize_idx = _gv_osize_idx_20;
			always @(*) begin
				if (_sv2v_0)
					;
				is_reduct_osize[osize_idx] = 1'sb0;
				is_reduct_osize[osize_idx][0+:2 ** osize_idx] = {2 ** osize_idx {dst_osize_vector[osize_idx]}};
			end
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		is_reduct_osize_sel = 1'sb0;
		begin : sv2v_autoblock_3
			reg signed [31:0] osize_idx;
			for (osize_idx = 0; osize_idx < 4; osize_idx = osize_idx + 1)
				is_reduct_osize_sel = is_reduct_osize_sel | is_reduct_osize[osize_idx];
		end
	end
	assign is_reduct_valid = {riscv_v_pkg_RISCV_V_NUM_BYTES_DATA {~is_reduct}} | is_reduct_osize_sel;
	genvar _gv_osize_idx_21;
	generate
		for (_gv_osize_idx_21 = 0; _gv_osize_idx_21 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_21 = _gv_osize_idx_21 + 1) begin : gen_mask_osize
			localparam osize_idx = _gv_osize_idx_21;
			localparam NUM_BLOCKS_OSIZE = riscv_v_pkg_RISCV_V_NUM_BYTES_DATA / (2 ** osize_idx);
			localparam BYTES_PER_BLOCK = riscv_v_pkg_RISCV_V_NUM_BYTES_DATA / NUM_BLOCKS_OSIZE;
			genvar _gv_block_idx_5;
			for (_gv_block_idx_5 = 0; _gv_block_idx_5 < NUM_BLOCKS_OSIZE; _gv_block_idx_5 = _gv_block_idx_5 + 1) begin : gen_mask_osize_block
				localparam block_idx = _gv_block_idx_5;
				assign mask_osize[osize_idx][block_idx * BYTES_PER_BLOCK+:BYTES_PER_BLOCK] = {BYTES_PER_BLOCK {mask[block_idx] & dst_osize_vector[osize_idx]}};
			end
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		mask_osize_sel = 1'sb0;
		begin : sv2v_autoblock_4
			reg signed [31:0] osize_idx;
			for (osize_idx = 0; osize_idx < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; osize_idx = osize_idx + 1)
				mask_osize_sel = mask_osize_sel | mask_osize[osize_idx];
		end
	end
	localparam riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK = riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG / riscv_pkg_BYTE_WIDTH;
	assign is_mask_valid = {{riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK {~is_mask}}, {riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK {1'b1}}};
	assign mask_valid = {riscv_v_pkg_RISCV_V_NUM_BYTES_DATA {~use_mask}} | mask_osize_sel;
	wire [((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) ? ((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0))) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) - (128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)))) + 1) * 1:1] sv2v_tmp_5F9B0;
	assign sv2v_tmp_5F9B0 = srca;
	always @(*) srca_alu[128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))-:((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) ? ((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0))) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) - (128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)))) + 1)] = sv2v_tmp_5F9B0;
	wire [((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) ? ((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0))) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) - (128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)))) + 1) * 1:1] sv2v_tmp_1FB50;
	assign sv2v_tmp_1FB50 = srcb;
	always @(*) srcb_alu[128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))-:((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) ? ((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0))) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) - (128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)))) + 1)] = sv2v_tmp_1FB50;
	genvar _gv_osize_idx_22;
	generate
		for (_gv_osize_idx_22 = 1; _gv_osize_idx_22 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_22 = _gv_osize_idx_22 + 1) begin : gen_merge_osize
			localparam osize_idx = _gv_osize_idx_22;
			localparam NUM_BLOCKS_OSIZE = riscv_v_pkg_RISCV_V_NUM_BYTES_DATA / (2 ** osize_idx);
			localparam NUM_BITS_OSIZE = (2 ** osize_idx) - 1;
			always @(*) begin
				if (_sv2v_0)
					;
				merge_osize[osize_idx] = 1'sb0;
				begin : sv2v_autoblock_5
					reg signed [31:0] block_idx;
					for (block_idx = 0; block_idx < NUM_BLOCKS_OSIZE; block_idx = block_idx + 1)
						merge_osize[osize_idx][block_idx * (2 ** osize_idx)+:NUM_BITS_OSIZE] = {NUM_BITS_OSIZE {dst_osize_vector[osize_idx]}};
				end
			end
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		srca_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)-:((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) ? ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) + 1)] = 1'sb0;
		begin : sv2v_autoblock_6
			reg signed [31:0] osize_idx;
			for (osize_idx = 1; osize_idx < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; osize_idx = osize_idx + 1)
				srca_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)-:((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) ? ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) + 1)] = srca_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)-:((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) ? ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) + 1)] | merge_osize[osize_idx];
		end
	end
	genvar _gv_osize_idx_23;
	generate
		for (_gv_osize_idx_23 = 0; _gv_osize_idx_23 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_23 = _gv_osize_idx_23 + 1) begin : gen_valid_osize
			localparam osize_idx = _gv_osize_idx_23;
			localparam NUM_BLOCKS_OSIZE = riscv_v_pkg_RISCV_V_NUM_BYTES_DATA / (2 ** osize_idx);
			localparam NUM_BITS_OSIZE = 2 ** osize_idx;
			always @(*) begin
				if (_sv2v_0)
					;
				valid_osize[osize_idx] = 1'sb0;
				begin : sv2v_autoblock_7
					reg signed [31:0] block_idx;
					for (block_idx = 0; block_idx < NUM_BLOCKS_OSIZE; block_idx = block_idx + 1)
						valid_osize[osize_idx][block_idx * (2 ** osize_idx)+:NUM_BITS_OSIZE] = {NUM_BITS_OSIZE {len_start_vec[block_idx] & dst_osize_vector[osize_idx]}};
				end
			end
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		valid_osize_sel = 1'sb0;
		begin : sv2v_autoblock_8
			reg signed [31:0] osize_idx;
			for (osize_idx = 0; osize_idx < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; osize_idx = osize_idx + 1)
				valid_osize_sel = valid_osize_sel | valid_osize[osize_idx];
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		srca_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] = valid_osize_sel;
		srcb_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] = valid_osize_sel;
		srca_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] = srca_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] & mask_valid;
		srcb_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] = srcb_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] & mask_valid;
		srca_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] = srca_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] & is_reduct_valid;
		srca_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] = srca_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] & is_mask_valid;
		srca_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] = srca_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] & {riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG {~is_v2i}};
		srca_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] = srca_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] & i2v_mask;
		srca_alu[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - (riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK - 1)):(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)] = srca_alu[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - (riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK - 1)):(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)] | {riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK {is_mask}};
	end
	wire [((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) ? ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) + 1) * 1:1] sv2v_tmp_F9480;
	assign sv2v_tmp_F9480 = srca_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)-:((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) ? ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) + 1)];
	always @(*) srcb_alu[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)-:((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) ? ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) + 1)] = sv2v_tmp_F9480;
	always @(*) begin
		if (_sv2v_0)
			;
		mask_merge_qual = mask_merge;
		mask_merge_qual = mask_merge_qual & {riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG {is_mask}};
		begin : sv2v_autoblock_9
			reg signed [31:0] idx;
			for (idx = 0; idx < riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG; idx = idx + 1)
				mask_merge_qual[idx] = mask_merge_qual[idx] & ~mask_result_valid[idx];
		end
	end
	assign len = vl[$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1-:$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN)];
	assign osize = sv2v_cast_3(vtype[5-:3]);
	initial _sv2v_0 = 0;
endmodule
