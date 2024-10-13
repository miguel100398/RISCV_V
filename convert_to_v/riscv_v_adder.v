module riscv_v_adder (
	valid_adder,
	is_reduct,
	is_reduct_n,
	is_add,
	is_sub,
	is_max,
	is_set_equal,
	is_set_nequal,
	is_set_less,
	is_set_greater,
	is_arithmetic,
	is_min_max,
	is_signed,
	use_carry,
	is_negate_srca,
	is_negate_srcb,
	osize_vector,
	is_greater_osize_vector,
	srca,
	srcb,
	carry_in,
	result,
	zf,
	of,
	cf
);
	reg _sv2v_0;
	input wire valid_adder;
	input wire is_reduct;
	input wire is_reduct_n;
	input wire is_add;
	input wire is_sub;
	input wire is_max;
	input wire is_set_equal;
	input wire is_set_nequal;
	input wire is_set_less;
	input wire is_set_greater;
	input wire is_arithmetic;
	input wire is_min_max;
	input wire is_signed;
	input wire use_carry;
	input wire is_negate_srca;
	input wire is_negate_srcb;
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
	input wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] carry_in;
	output wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] result;
	output reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] zf;
	output wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] of;
	output wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] cf;
	localparam NUM_ADD_BLOCKS = riscv_v_pkg_RISCV_V_NUM_BYTES_DATA;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] srca_gated;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] srcb_gated;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] srca_xor_sub;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] srcb_xor_sub;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] srca_reduct;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] srca_adder;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] srcb_adder;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] cin_adder;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] prev_cout_adder;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] cout_adder;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] result_adder;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] result_adder_qual;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] merge_carry_in;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] sub_carry_in;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] use_carry_in;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] zf_prev_osize;
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] zf_osize [4:0];
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] signed_of;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] unsigned_of;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] sign_result;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] result_min_max_osize [4:0];
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] result_min_max_osize_qual [4:0];
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] result_min_max_osize_shift [3:0];
	reg [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] result_min_max_reduct_src;
	reg [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] result_min_max_qual;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] result_less_than_signed;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] result_less_than_unsigned;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] result_less_than_prev_osize;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] result_set_equal_osize [4:0];
	reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] result_set_equal;
	reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] result_set_equal_qual;
	reg [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] result_set_equal_ext_qual;
	reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] result_set_nequal_osize [4:0];
	reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] result_set_nequal;
	reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] result_set_nequal_qual;
	reg [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] result_set_nequal_ext_qual;
	reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] result_set_less_osize [4:0];
	reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] result_set_less;
	reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] result_set_less_qual;
	reg [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] result_set_less_ext_qual;
	reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] result_set_greater_osize [4:0];
	reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] result_set_greater;
	reg [riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG - 1:0] result_set_greater_qual;
	reg [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] result_set_greater_ext_qual;
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] flags_mask_osize [0:4];
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] flags_mask_sel;
	genvar _gv_block_13;
	generate
		for (_gv_block_13 = 0; _gv_block_13 < NUM_ADD_BLOCKS; _gv_block_13 = _gv_block_13 + 1) begin : gen_gate_sources
			localparam block = _gv_block_13;
			assign srca_gated[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = srca[(128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (127 - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (block * riscv_pkg_BYTE_WIDTH))))+:riscv_pkg_BYTE_WIDTH] & {riscv_pkg_BYTE_WIDTH {valid_adder}};
			assign srcb_gated[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = srcb[(128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (127 - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (block * riscv_pkg_BYTE_WIDTH))))+:riscv_pkg_BYTE_WIDTH] & {riscv_pkg_BYTE_WIDTH {valid_adder}};
		end
	endgenerate
	genvar _gv_block_14;
	generate
		for (_gv_block_14 = 0; _gv_block_14 < NUM_ADD_BLOCKS; _gv_block_14 = _gv_block_14 + 1) begin : gen_xor_is_sub
			localparam block = _gv_block_14;
			assign srca_xor_sub[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = srca_gated[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] ^ {riscv_pkg_BYTE_WIDTH {is_negate_srca}};
			assign srcb_xor_sub[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = srcb_gated[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] ^ {riscv_pkg_BYTE_WIDTH {is_negate_srcb}};
		end
	endgenerate
	riscv_v_reduct_src reduct_srca(
		.src(srca_xor_sub),
		.is_reduct(is_reduct),
		.is_reduct_n(is_reduct_n),
		.osize_vector(osize_vector),
		.is_greater_osize_vector(is_greater_osize_vector),
		.result(result_adder_qual),
		.src_o(srca_reduct)
	);
	assign srca_adder[0+:riscv_pkg_BYTE_WIDTH] = srca_reduct[0+:riscv_pkg_BYTE_WIDTH];
	genvar _gv_block_15;
	generate
		for (_gv_block_15 = 1; _gv_block_15 < NUM_ADD_BLOCKS; _gv_block_15 = _gv_block_15 + 1) begin : gen_srca_adder
			localparam block = _gv_block_15;
			assign srca_adder[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = srca_reduct[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] | ({riscv_pkg_BYTE_WIDTH {is_reduct}} & result_min_max_reduct_src[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH]);
		end
	endgenerate
	genvar _gv_block_16;
	generate
		for (_gv_block_16 = 0; _gv_block_16 < NUM_ADD_BLOCKS; _gv_block_16 = _gv_block_16 + 1) begin : gen_srcb_adder
			localparam block = _gv_block_16;
			assign srcb_adder[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = srcb_xor_sub[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] & {riscv_pkg_BYTE_WIDTH {srcb[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - block)]}};
		end
	endgenerate
	assign merge_carry_in[0] = 1'b0;
	assign sub_carry_in[0] = is_sub;
	assign use_carry_in[0] = use_carry & carry_in[0];
	genvar _gv_block_17;
	generate
		for (_gv_block_17 = 1; _gv_block_17 < NUM_ADD_BLOCKS; _gv_block_17 = _gv_block_17 + 1) begin : gen_merge_cin
			localparam block = _gv_block_17;
			assign merge_carry_in[block] = cout_adder[block - 1] & srca[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - (block - 1))];
			assign sub_carry_in[block] = (is_sub & srcb[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - block)]) & ~srca[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - (block - 1))];
			assign use_carry_in[block] = (use_carry & carry_in[block]) & ~srca[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - (block - 1))];
		end
	endgenerate
	assign cin_adder = (merge_carry_in | sub_carry_in) ^ use_carry_in;
	genvar _gv_block_18;
	generate
		for (_gv_block_18 = 0; _gv_block_18 < NUM_ADD_BLOCKS; _gv_block_18 = _gv_block_18 + 1) begin : gen_adder
			localparam block = _gv_block_18;
			adder_nbit #(
				.WIDTH(riscv_pkg_BYTE_WIDTH),
				.RIPPLE_CARRY(1'b1),
				.BEHAVIORAL(1'b0)
			) adder(
				.A(srca_adder[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH]),
				.B(srcb_adder[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH]),
				.cin(cin_adder[block]),
				.S(result_adder[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH]),
				.prev_cout(prev_cout_adder[block]),
				.cout(cout_adder[block])
			);
		end
	endgenerate
	genvar _gv_osize_idx_6;
	generate
		for (_gv_osize_idx_6 = 0; _gv_osize_idx_6 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_6 = _gv_osize_idx_6 + 1) begin : gen_result_min_max_osize
			localparam osize_idx = _gv_osize_idx_6;
			localparam NUM_BYTES_OSIZE = 2 ** osize_idx;
			localparam NUM_BLOCKS_OSIZE = NUM_ADD_BLOCKS / NUM_BYTES_OSIZE;
			genvar _gv_byte_idx_1;
			for (_gv_byte_idx_1 = 0; _gv_byte_idx_1 < NUM_BLOCKS_OSIZE; _gv_byte_idx_1 = _gv_byte_idx_1 + 1) begin : genblk1
				localparam byte_idx = _gv_byte_idx_1;
				assign result_min_max_osize[osize_idx][riscv_pkg_BYTE_WIDTH * (byte_idx * NUM_BYTES_OSIZE)+:riscv_pkg_BYTE_WIDTH * NUM_BYTES_OSIZE] = ((is_max ^ result_less_than_prev_osize[((byte_idx + 1) * NUM_BYTES_OSIZE) - 1]) | ~srcb[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - (byte_idx * NUM_BYTES_OSIZE))] ? srca_adder[riscv_pkg_BYTE_WIDTH * (byte_idx * NUM_BYTES_OSIZE)+:riscv_pkg_BYTE_WIDTH * NUM_BYTES_OSIZE] : srcb_gated[riscv_pkg_BYTE_WIDTH * (byte_idx * NUM_BYTES_OSIZE)+:riscv_pkg_BYTE_WIDTH * NUM_BYTES_OSIZE]);
			end
			assign result_min_max_osize_qual[osize_idx] = {riscv_v_pkg_RISCV_V_DATA_WIDTH {is_min_max && osize_vector[osize_idx]}} & result_min_max_osize[osize_idx];
		end
	endgenerate
	genvar _gv_osize_idx_7;
	generate
		for (_gv_osize_idx_7 = 0; _gv_osize_idx_7 < 4; _gv_osize_idx_7 = _gv_osize_idx_7 + 1) begin : gen_result_min_max_shift
			localparam osize_idx = _gv_osize_idx_7;
			assign result_min_max_osize_shift[osize_idx] = result_min_max_osize_qual[osize_idx] << ((2 ** osize_idx) * riscv_pkg_BYTE_WIDTH);
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		result_min_max_reduct_src = 1'sb0;
		begin : sv2v_autoblock_1
			reg signed [31:0] osize_idx;
			for (osize_idx = 0; osize_idx < 4; osize_idx = osize_idx + 1)
				result_min_max_reduct_src = result_min_max_reduct_src | result_min_max_osize_shift[osize_idx];
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		result_min_max_qual = 1'sb0;
		begin : sv2v_autoblock_2
			reg signed [31:0] osize_idx;
			for (osize_idx = 0; osize_idx < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; osize_idx = osize_idx + 1)
				result_min_max_qual = result_min_max_qual | result_min_max_osize_qual[osize_idx];
		end
	end
	genvar _gv_osize_idx_8;
	generate
		for (_gv_osize_idx_8 = 0; _gv_osize_idx_8 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_8 = _gv_osize_idx_8 + 1) begin : genblk9
			localparam osize_idx = _gv_osize_idx_8;
			localparam NUM_FLAG_BITS_OSIZE = 2 ** osize_idx;
			localparam NUM_BLOCKS_OSIZE = riscv_v_pkg_RISCV_V_DATA_WIDTH / (8 * (2 ** osize_idx));
			always @(*) begin
				if (_sv2v_0)
					;
				flags_mask_osize[osize_idx] = 1'sb0;
				begin : sv2v_autoblock_3
					reg signed [31:0] bit_idx;
					for (bit_idx = 0; bit_idx < NUM_BLOCKS_OSIZE; bit_idx = bit_idx + 1)
						flags_mask_osize[osize_idx][(bit_idx * NUM_FLAG_BITS_OSIZE) + (NUM_FLAG_BITS_OSIZE - 1)] = 1'b1;
				end
			end
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		flags_mask_sel = 1'sb0;
		begin : sv2v_autoblock_4
			reg signed [31:0] osize_idx;
			for (osize_idx = 0; osize_idx < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; osize_idx = osize_idx + 1)
				flags_mask_sel = flags_mask_sel | (flags_mask_osize[osize_idx] & {riscv_v_pkg_RISCV_V_NUM_BYTES_DATA {osize_vector[osize_idx]}});
		end
	end
	genvar _gv_block_19;
	generate
		for (_gv_block_19 = 0; _gv_block_19 < NUM_ADD_BLOCKS; _gv_block_19 = _gv_block_19 + 1) begin : gen_flags
			localparam block = _gv_block_19;
			assign zf_prev_osize[block] = result_adder[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] == 0;
			assign cf[block] = cout_adder[block] & flags_mask_sel[block];
			assign signed_of[block] = (cout_adder[block] ^ prev_cout_adder[block]) & is_signed;
			assign unsigned_of[block] = (cout_adder[block] ^ is_sub) & ~is_signed;
			assign of[block] = (signed_of[block] | unsigned_of[block]) & flags_mask_sel[block];
			assign sign_result[block] = result_adder[(block * riscv_pkg_BYTE_WIDTH) + 7];
			assign result_less_than_signed[block] = (sign_result[block] ^ signed_of[block]) & is_signed;
			assign result_less_than_unsigned[block] = unsigned_of[block];
			assign result_less_than_prev_osize[block] = result_less_than_signed[block] | result_less_than_unsigned[block];
		end
	endgenerate
	genvar _gv_osize_idx_9;
	generate
		for (_gv_osize_idx_9 = 0; _gv_osize_idx_9 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_9 = _gv_osize_idx_9 + 1) begin : gen_zf_osize
			localparam osize_idx = _gv_osize_idx_9;
			always @(*) begin
				if (_sv2v_0)
					;
				zf_osize[osize_idx] = 1'sb0;
				if (osize_idx == 0) begin : sv2v_autoblock_5
					reg signed [31:0] zf_idx;
					for (zf_idx = 0; zf_idx < NUM_ADD_BLOCKS; zf_idx = zf_idx + 1)
						zf_osize[osize_idx][zf_idx] = zf_prev_osize[zf_idx] & osize_vector[osize_idx];
				end
				else begin : sv2v_autoblock_6
					reg signed [31:0] zf_idx;
					for (zf_idx = (2 ** osize_idx) - 1; zf_idx < NUM_ADD_BLOCKS; zf_idx = zf_idx + (2 ** osize_idx))
						zf_osize[osize_idx][zf_idx] = &zf_prev_osize[zf_idx-:2 ** osize_idx] & osize_vector[osize_idx];
				end
			end
		end
	endgenerate
	genvar _gv_osize_idx_10;
	generate
		for (_gv_osize_idx_10 = 0; _gv_osize_idx_10 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_10 = _gv_osize_idx_10 + 1) begin : gen_compare_osize
			localparam osize_idx = _gv_osize_idx_10;
			localparam NUM_BITS_OSIZE = 2 ** osize_idx;
			always @(*) begin
				if (_sv2v_0)
					;
				result_set_equal_osize[osize_idx] = 1'sb0;
				result_set_nequal_osize[osize_idx] = 1'sb0;
				result_set_less_osize[osize_idx] = 1'sb0;
				result_set_greater_osize[osize_idx] = 1'sb0;
				begin : sv2v_autoblock_7
					reg signed [31:0] cmp_idx;
					for (cmp_idx = 0; cmp_idx < (riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG / NUM_BITS_OSIZE); cmp_idx = cmp_idx + 1)
						begin
							result_set_equal_osize[osize_idx][cmp_idx] = (&zf_prev_osize[cmp_idx * NUM_BITS_OSIZE+:NUM_BITS_OSIZE] & osize_vector[osize_idx]) & srcb[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - (cmp_idx * NUM_BITS_OSIZE))];
							result_set_nequal_osize[osize_idx][cmp_idx] = (~(&zf_prev_osize[cmp_idx * NUM_BITS_OSIZE+:NUM_BITS_OSIZE]) & osize_vector[osize_idx]) & srcb[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - (cmp_idx * NUM_BITS_OSIZE))];
							result_set_less_osize[osize_idx][cmp_idx] = (result_less_than_prev_osize[((cmp_idx + 1) * NUM_BITS_OSIZE) - 1] & osize_vector[osize_idx]) & srcb[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - (cmp_idx * NUM_BITS_OSIZE))];
							result_set_greater_osize[osize_idx][cmp_idx] = (~(result_set_less_osize[osize_idx][cmp_idx] | result_set_equal_osize[osize_idx][cmp_idx]) & osize_vector[osize_idx]) & srcb[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - (cmp_idx * NUM_BITS_OSIZE))];
						end
				end
			end
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		zf = 1'sb0;
		result_set_equal = 1'sb0;
		result_set_nequal = 1'sb0;
		result_set_less = 1'sb0;
		result_set_greater = 1'sb0;
		begin : sv2v_autoblock_8
			reg signed [31:0] osize_idx;
			for (osize_idx = 0; osize_idx < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; osize_idx = osize_idx + 1)
				begin
					zf = zf | zf_osize[osize_idx];
					result_set_equal = result_set_equal | result_set_equal_osize[osize_idx];
					result_set_nequal = result_set_nequal | result_set_nequal_osize[osize_idx];
					result_set_less = result_set_less | result_set_less_osize[osize_idx];
					result_set_greater = result_set_greater | result_set_greater_osize[osize_idx];
				end
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		result_set_equal_qual = result_set_equal & {riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG {is_set_equal}};
		result_set_nequal_qual = result_set_nequal & {riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG {is_set_nequal}};
		result_set_less_qual = result_set_less & {riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG {is_set_less}};
		result_set_greater_qual = result_set_greater & {riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG {is_set_greater}};
	end
	localparam riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK = riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG / riscv_pkg_BYTE_WIDTH;
	always @(*) begin
		if (_sv2v_0)
			;
		result_set_equal_ext_qual = 0;
		result_set_equal_ext_qual[0+:riscv_pkg_BYTE_WIDTH * riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK] = result_set_equal_qual;
		result_set_nequal_ext_qual = 0;
		result_set_nequal_ext_qual[0+:riscv_pkg_BYTE_WIDTH * riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK] = result_set_nequal_qual;
		result_set_less_ext_qual = 0;
		result_set_less_ext_qual[0+:riscv_pkg_BYTE_WIDTH * riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK] = result_set_less_qual;
		result_set_greater_ext_qual = 0;
		result_set_greater_ext_qual[0+:riscv_pkg_BYTE_WIDTH * riscv_v_pkg_RISCV_V_NUM_BYTES_ALLOCATE_MASK] = result_set_greater_qual;
	end
	assign result_adder_qual = {riscv_v_pkg_RISCV_V_DATA_WIDTH {is_arithmetic}} & result_adder;
	genvar _gv_block_20;
	generate
		for (_gv_block_20 = 0; _gv_block_20 < NUM_ADD_BLOCKS; _gv_block_20 = _gv_block_20 + 1) begin : gen_adder_result
			localparam block = _gv_block_20;
			assign result[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = ((((result_adder_qual[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] | result_min_max_qual[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH]) | result_set_equal_ext_qual[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH]) | result_set_nequal_ext_qual[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH]) | result_set_less_ext_qual[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH]) | result_set_greater_ext_qual[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH];
		end
	endgenerate
	initial _sv2v_0 = 0;
endmodule
