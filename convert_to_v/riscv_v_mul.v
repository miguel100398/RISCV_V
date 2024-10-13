module riscv_v_mul (
	is_mul,
	is_high,
	is_signed,
	osize_vector,
	srca,
	srcb,
	result
);
	reg _sv2v_0;
	input wire is_mul;
	input wire is_high;
	input wire is_signed;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES = 5;
	input wire [4:0] osize_vector;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srca;
	input wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srcb;
	output reg [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] result;
	localparam NUM_MUL_BLOCKS = riscv_v_pkg_RISCV_V_NUM_BYTES_DATA;
	localparam MAX_MUL_LEVEL = 7;
	localparam MIN_MUL_LEVEL = 4;
	function automatic signed [31:0] riscv_v_pkg_f_vedic_mul_get_prev_results;
		input reg signed [31:0] mul_level;
		input reg signed [31:0] min_mul_level;
		input reg [1:0] mul_idx;
		input reg get_mid_prev_results;
		reg [0:1] _sv2v_jump;
		begin
			_sv2v_jump = 2'b00;
			if (mul_level < min_mul_level) begin
				riscv_v_pkg_f_vedic_mul_get_prev_results = 1;
				_sv2v_jump = 2'b11;
			end
			if (_sv2v_jump == 2'b00) begin
				if (|{mul_idx == 2'b01, mul_idx == 2'b10} && ~get_mid_prev_results) begin
					riscv_v_pkg_f_vedic_mul_get_prev_results = 1;
					_sv2v_jump = 2'b11;
				end
				if (_sv2v_jump == 2'b00) begin
					if (mul_level == min_mul_level) begin
						riscv_v_pkg_f_vedic_mul_get_prev_results = (get_mid_prev_results ? 4 : 2);
						_sv2v_jump = 2'b11;
					end
					if (_sv2v_jump == 2'b00) begin
						if (get_mid_prev_results) begin
							riscv_v_pkg_f_vedic_mul_get_prev_results = (riscv_v_pkg_f_vedic_mul_get_prev_results(mul_level - 1, min_mul_level, mul_idx, get_mid_prev_results) * 4) + 4;
							_sv2v_jump = 2'b11;
						end
						else begin
							riscv_v_pkg_f_vedic_mul_get_prev_results = (riscv_v_pkg_f_vedic_mul_get_prev_results(mul_level - 1, min_mul_level, mul_idx, get_mid_prev_results) * 2) + 2;
							_sv2v_jump = 2'b11;
						end
					end
				end
			end
		end
	endfunction
	localparam NUM_PREV_RESULTS = riscv_v_pkg_f_vedic_mul_get_prev_results(MAX_MUL_LEVEL, MIN_MUL_LEVEL, 2'b00, 1'b0);
	localparam MUL_RESULT_WIDTH = 256;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] srca_gated;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] srca_mul;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] srcb_mul;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] merge;
	wire [(30 * riscv_v_pkg_RISCV_V_DATA_WIDTH) - 1:0] prev_results;
	wire [255:0] mul_result_osize_prev_comp [4:0];
	wire [255:0] mul_result_osize [4:0];
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] mul_result_osize_sel_lh [4:0];
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] srcA_comp;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] srcB_comp;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] result_comp;
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] srcA_sign_osize [4:0];
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] srcA_sign;
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] srcB_sign_osize [4:0];
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] srcB_sign;
	reg [255:0] mul_result_prev_comp;
	wire [255:0] mul_result;
	genvar _gv_osize_idx_12;
	generate
		for (_gv_osize_idx_12 = 0; _gv_osize_idx_12 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_12 = _gv_osize_idx_12 + 1) begin : gen_sign_src
			localparam osize_idx = _gv_osize_idx_12;
			localparam OSIZE_WIDTH = riscv_pkg_BYTE_WIDTH * (2 ** osize_idx);
			localparam JUMP_SIZE = OSIZE_WIDTH / riscv_pkg_BYTE_WIDTH;
			localparam NUM_BLOCK = riscv_v_pkg_RISCV_V_DATA_WIDTH / OSIZE_WIDTH;
			always @(*) begin
				if (_sv2v_0)
					;
				srcA_sign_osize[osize_idx] = 1'sb0;
				srcB_sign_osize[osize_idx] = 1'sb0;
				begin : sv2v_autoblock_1
					reg signed [31:0] sign_idx;
					for (sign_idx = 0; sign_idx < NUM_BLOCK; sign_idx = sign_idx + 1)
						begin
							srcA_sign_osize[osize_idx][sign_idx * JUMP_SIZE] = srca[(128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (127 - ((sign_idx * OSIZE_WIDTH) + (OSIZE_WIDTH - 1)))];
							srcB_sign_osize[osize_idx][sign_idx * JUMP_SIZE] = srcb[(128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (127 - ((sign_idx * OSIZE_WIDTH) + (OSIZE_WIDTH - 1)))];
						end
				end
			end
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		srcA_sign = 1'sb0;
		srcB_sign = 1'sb0;
		begin : sv2v_autoblock_2
			reg signed [31:0] osize_idx;
			for (osize_idx = 0; osize_idx < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; osize_idx = osize_idx + 1)
				begin
					srcA_sign = srcA_sign | (srcA_sign_osize[osize_idx] & {riscv_v_pkg_RISCV_V_NUM_BYTES_DATA {osize_vector[osize_idx]}});
					srcB_sign = srcB_sign | (srcB_sign_osize[osize_idx] & {riscv_v_pkg_RISCV_V_NUM_BYTES_DATA {osize_vector[osize_idx]}});
				end
		end
	end
	genvar _gv_comp_idx_1;
	generate
		for (_gv_comp_idx_1 = 0; _gv_comp_idx_1 < riscv_v_pkg_RISCV_V_NUM_BYTES_DATA; _gv_comp_idx_1 = _gv_comp_idx_1 + 1) begin : gen_comp_src
			localparam comp_idx = _gv_comp_idx_1;
			assign srcA_comp[comp_idx] = is_signed & srcA_sign[comp_idx];
			assign srcB_comp[comp_idx] = is_signed & srcB_sign[comp_idx];
			assign result_comp[comp_idx] = srcA_comp[comp_idx] ^ srcB_comp[comp_idx];
		end
	endgenerate
	genvar _gv_block_21;
	generate
		for (_gv_block_21 = 0; _gv_block_21 < NUM_MUL_BLOCKS; _gv_block_21 = _gv_block_21 + 1) begin : gen_gate_srcA
			localparam block = _gv_block_21;
			assign srca_gated[block * riscv_pkg_BYTE_WIDTH+:riscv_pkg_BYTE_WIDTH] = srca[(128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (127 - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - (block * riscv_pkg_BYTE_WIDTH))))+:riscv_pkg_BYTE_WIDTH] & {riscv_pkg_BYTE_WIDTH {is_mul}};
		end
	endgenerate
	genvar _gv_block_22;
	generate
		for (_gv_block_22 = 0; _gv_block_22 < NUM_MUL_BLOCKS; _gv_block_22 = _gv_block_22 + 1) begin : gen_mul_srcs
			localparam block = _gv_block_22;
			assign merge[block] = srcb[(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1) - block)];
		end
	endgenerate
	riscv_v_twos_comp_sel #(.BLOCK_WIDTH(riscv_pkg_BYTE_WIDTH)) twos_comp_srcA(
		.in(srca_gated),
		.complement(srcA_comp),
		.osize_vector(osize_vector),
		.merge(merge),
		.out(srca_mul)
	);
	riscv_v_twos_comp_sel #(.BLOCK_WIDTH(riscv_pkg_BYTE_WIDTH)) twos_comp_srcB(
		.in(srcb[128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))-:((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) ? ((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0))) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) - (128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)))) + 1)]),
		.complement(srcB_comp),
		.osize_vector(osize_vector),
		.merge(merge),
		.out(srcb_mul)
	);
	vedic_mul_unsigned_128bits vedic_mul(
		.A(srca_mul),
		.B(srcb_mul),
		.Z(mul_result_osize_prev_comp[4]),
		.prev_result(prev_results)
	);
	genvar _gv_osize_idx_13;
	function automatic signed [31:0] riscv_v_pkg_f_vedic_mul_start_prev_idx;
		input reg signed [31:0] osize;
		reg signed [31:0] osize_width;
		reg signed [31:0] num_results;
		begin
			num_results = 0;
			begin : sv2v_autoblock_3
				reg signed [31:0] i;
				for (i = 1; i <= osize; i = i + 1)
					begin
						osize_width = riscv_pkg_BYTE_WIDTH * (2 ** (i - 1));
						num_results = num_results + (riscv_v_pkg_RISCV_V_DATA_WIDTH / osize_width);
					end
			end
			riscv_v_pkg_f_vedic_mul_start_prev_idx = num_results;
		end
	endfunction
	/*
	generate
		for (_gv_osize_idx_13 = 0; _gv_osize_idx_13 < 4; _gv_osize_idx_13 = _gv_osize_idx_13 + 1) begin : gen_select_prev_result_osize
			localparam osize_idx = _gv_osize_idx_13;
			localparam OSIZE_WIDTH = riscv_pkg_BYTE_WIDTH * (2 ** osize_idx);
			localparam RESULT_WIDTH = 2 * OSIZE_WIDTH;
			localparam NUM_RESULTS = riscv_v_pkg_RISCV_V_DATA_WIDTH / OSIZE_WIDTH;
			localparam START_PREV_IDX = riscv_v_pkg_f_vedic_mul_start_prev_idx(osize_idx);
			genvar _gv_result_idx_1;
			for (_gv_result_idx_1 = 0; _gv_result_idx_1 < NUM_RESULTS; _gv_result_idx_1 = _gv_result_idx_1 + 1) begin : gen_select_prev_result_result
				localparam result_idx = _gv_result_idx_1;
				assign mul_result_osize_prev_comp[osize_idx][result_idx * RESULT_WIDTH+:RESULT_WIDTH] = prev_results[(START_PREV_IDX + result_idx) * riscv_v_pkg_RISCV_V_DATA_WIDTH+:RESULT_WIDTH];
			end
		end
	endgenerate
	*/

	assign mul_result_osize_prev_comp[0][0 +: 16] =  prev_results[0*128 +: 16];
	assign mul_result_osize_prev_comp[0][16 +: 16] =  prev_results[1*128 +: 16];
	assign mul_result_osize_prev_comp[0][32 +: 16] =  prev_results[2*128 +: 16];
	assign mul_result_osize_prev_comp[0][48 +: 16] =  prev_results[3*128 +: 16];
	assign mul_result_osize_prev_comp[0][64 +: 16] =  prev_results[6*128 +: 16];
	assign mul_result_osize_prev_comp[0][80 +: 16] =  prev_results[7*128 +: 16];
	assign mul_result_osize_prev_comp[0][96 +: 16] =  prev_results[8*128 +: 16];
	assign mul_result_osize_prev_comp[0][112 +: 16] =  prev_results[9*128 +: 16];
	assign mul_result_osize_prev_comp[0][128 +: 16] =  prev_results[14*128 +: 16];
	assign mul_result_osize_prev_comp[0][144 +: 16] =  prev_results[15*128 +: 16];
	assign mul_result_osize_prev_comp[0][160 +: 16] =  prev_results[16*128 +: 16];
	assign mul_result_osize_prev_comp[0][176 +: 16] =  prev_results[17*128 +: 16];
	assign mul_result_osize_prev_comp[0][192 +: 16] =  prev_results[20*128 +: 16];
	assign mul_result_osize_prev_comp[0][208 +: 16] =  prev_results[21*128 +: 16];
	assign mul_result_osize_prev_comp[0][224 +: 16] =  prev_results[22*128 +: 16];
	assign mul_result_osize_prev_comp[0][240 +: 16] =  prev_results[23*128 +: 16];

	assign mul_result_osize_prev_comp[1][0 +: 32] =  prev_results[4*128 +: 32];
	assign mul_result_osize_prev_comp[1][32 +: 32] =  prev_results[5*128 +: 32];
	assign mul_result_osize_prev_comp[1][64 +: 32] =  prev_results[10*128 +: 32];
	assign mul_result_osize_prev_comp[1][96 +: 32] =  prev_results[11*128 +: 32];
	assign mul_result_osize_prev_comp[1][128 +: 32] =  prev_results[18*128 +: 32];
	assign mul_result_osize_prev_comp[1][160 +: 32] =  prev_results[19*128 +: 32];
	assign mul_result_osize_prev_comp[1][192 +: 32] =  prev_results[24*128 +: 32];
	assign mul_result_osize_prev_comp[1][224 +: 32] =  prev_results[25*128 +: 32];

	assign mul_result_osize_prev_comp[2][0 +: 64] =  prev_results[12*128 +: 64];
	assign mul_result_osize_prev_comp[2][64 +: 64] =  prev_results[13*128 +: 64];
	assign mul_result_osize_prev_comp[2][128 +: 64] =  prev_results[26*128 +: 64];
	assign mul_result_osize_prev_comp[2][192 +: 64] =  prev_results[27*128 +: 64];

	assign mul_result_osize_prev_comp[3][0 +: 128] =  prev_results[28*128 +: 128];
	assign mul_result_osize_prev_comp[3][128 +: 128] =  prev_results[29*128 +: 128];

	always @(*) begin
		if (_sv2v_0)
			;
		mul_result_prev_comp = 1'sb0;
		begin : sv2v_autoblock_4
			reg signed [31:0] osize_idx;
			for (osize_idx = 0; osize_idx < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; osize_idx = osize_idx + 1)
				mul_result_prev_comp = mul_result_prev_comp | (mul_result_osize_prev_comp[osize_idx] & {MUL_RESULT_WIDTH {osize_vector[osize_idx]}});
		end
	end
	localparam signed [31:0] riscv_pkg_WORD_WIDTH = 16;
	riscv_v_twos_comp_sel #(.BLOCK_WIDTH(riscv_pkg_WORD_WIDTH)) twos_comp_result(
		.in(mul_result_prev_comp),
		.complement(result_comp),
		.osize_vector(osize_vector),
		.merge(merge),
		.out(mul_result)
	);
	genvar _gv_osize_idx_14;
	generate
		for (_gv_osize_idx_14 = 0; _gv_osize_idx_14 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_14 = _gv_osize_idx_14 + 1) begin : gen_select_result_osize
			localparam osize_idx = _gv_osize_idx_14;
			localparam OSIZE_WIDTH = riscv_pkg_BYTE_WIDTH * (2 ** osize_idx);
			localparam RESULT_WIDTH = 2 * OSIZE_WIDTH;
			localparam NUM_RESULTS = riscv_v_pkg_RISCV_V_DATA_WIDTH / OSIZE_WIDTH;
			localparam JUMP_SIZE = riscv_pkg_BYTE_WIDTH / OSIZE_WIDTH;
			assign mul_result_osize[osize_idx] = mul_result;
		end
	endgenerate
	genvar _gv_osize_idx_15;
	generate
		for (_gv_osize_idx_15 = 0; _gv_osize_idx_15 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_15 = _gv_osize_idx_15 + 1) begin : gen_select_hl_osize
			localparam osize_idx = _gv_osize_idx_15;
			localparam OSIZE_WIDTH = riscv_pkg_BYTE_WIDTH * (2 ** osize_idx);
			localparam RESULT_WIDTH = 2 * OSIZE_WIDTH;
			localparam NUM_RESULTS = riscv_v_pkg_RISCV_V_DATA_WIDTH / OSIZE_WIDTH;
			localparam NUM_BYTES = OSIZE_WIDTH / riscv_pkg_BYTE_WIDTH;
			genvar _gv_result_idx_2;
			for (_gv_result_idx_2 = 0; _gv_result_idx_2 < NUM_RESULTS; _gv_result_idx_2 = _gv_result_idx_2 + 1) begin : gen_select_hl_result
				localparam result_idx = _gv_result_idx_2;
				assign mul_result_osize_sel_lh[osize_idx][riscv_pkg_BYTE_WIDTH * (result_idx * NUM_BYTES)+:riscv_pkg_BYTE_WIDTH * NUM_BYTES] = (is_high ? mul_result_osize[osize_idx][((result_idx + 1) * RESULT_WIDTH) - 1-:OSIZE_WIDTH] : mul_result_osize[osize_idx][result_idx * RESULT_WIDTH+:OSIZE_WIDTH]);
			end
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		result = 1'sb0;
		begin : sv2v_autoblock_5
			reg signed [31:0] osize_idx;
			for (osize_idx = 0; osize_idx < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; osize_idx = osize_idx + 1)
				result = result | (mul_result_osize_sel_lh[osize_idx] & {riscv_v_pkg_RISCV_V_DATA_WIDTH {osize_vector[osize_idx]}});
		end
	end
	initial _sv2v_0 = 0;
endmodule
