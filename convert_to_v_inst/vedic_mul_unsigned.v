module vedic_mul_unsigned (
	A,
	B,
	Z,
	prev_result
);
	reg _sv2v_0;
	parameter WIDTH = 2;
	parameter [1:0] MUL_IDX = 2'b00;
	parameter MIN_MUL_LEVEL = 4;
	parameter [0:0] GET_MID_PREV_RESULTS = 1'b0;
	localparam RESULT_WIDTH = 2 * WIDTH;
	localparam MUL_LEVEL = $clog2(WIDTH);
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
	localparam NUM_PREV_RESULTS = riscv_v_pkg_f_vedic_mul_get_prev_results(MUL_LEVEL, MIN_MUL_LEVEL, MUL_IDX, GET_MID_PREV_RESULTS);
	input wire [WIDTH - 1:0] A;
	input wire [WIDTH - 1:0] B;
	output wire [RESULT_WIDTH - 1:0] Z;
	output reg [(NUM_PREV_RESULTS * WIDTH) - 1:0] prev_result;
	localparam HALF_WIDTH = WIDTH / 2;
	localparam NUM_MULTIPLIERS = 4;
	localparam PREV_LEVEL_HL_NUM_PREV_RESULTS = riscv_v_pkg_f_vedic_mul_get_prev_results(MUL_LEVEL - 1, MIN_MUL_LEVEL, 2'b00, GET_MID_PREV_RESULTS);
	localparam PREV_LEVEL_MID_NUM_PREV_RESULTS = riscv_v_pkg_f_vedic_mul_get_prev_results(MUL_LEVEL - 1, MIN_MUL_LEVEL, 2'b01, GET_MID_PREV_RESULTS);
	function automatic riscv_v_pkg_f_vedic_mul_valid_prev_result;
		input reg signed [31:0] mul_level;
		input reg signed [31:0] min_mul_level;
		input reg [1:0] mul_idx;
		input reg get_mid_prev_results;
		reg [0:1] _sv2v_jump;
		begin
			_sv2v_jump = 2'b00;
			if (mul_level < min_mul_level) begin
				riscv_v_pkg_f_vedic_mul_valid_prev_result = 1'b0;
				_sv2v_jump = 2'b11;
			end
			if (_sv2v_jump == 2'b00) begin
				if (|{mul_idx == 2'b01, mul_idx == 2'b10} && ~get_mid_prev_results) begin
					riscv_v_pkg_f_vedic_mul_valid_prev_result = 1'b0;
					_sv2v_jump = 2'b11;
				end
				if (_sv2v_jump == 2'b00) begin
					riscv_v_pkg_f_vedic_mul_valid_prev_result = 1'b1;
					_sv2v_jump = 2'b11;
				end
			end
		end
	endfunction
	localparam VALID_PREV_RESULT = riscv_v_pkg_f_vedic_mul_valid_prev_result(MUL_LEVEL, MIN_MUL_LEVEL, MUL_IDX, GET_MID_PREV_RESULTS);
	function automatic signed [31:0] riscv_v_pkg_f_vedic_mul_num_prev_results_level_diff;
		input reg signed [31:0] mul_level;
		input reg signed [31:0] result_level;
		input reg get_mid_prev_results;
		reg signed [31:0] diff_mul_result_level;
		begin
			diff_mul_result_level = mul_level - result_level;
			if (get_mid_prev_results)
				riscv_v_pkg_f_vedic_mul_num_prev_results_level_diff = 4 ** diff_mul_result_level;
			else
				riscv_v_pkg_f_vedic_mul_num_prev_results_level_diff = 2 ** diff_mul_result_level;
		end
	endfunction
	generate
		if (WIDTH > 2) begin : gen_vedic_multiplier
			wire [HALF_WIDTH - 1:0] A_l;
			wire [HALF_WIDTH - 1:0] A_h;
			wire [HALF_WIDTH - 1:0] B_l;
			wire [HALF_WIDTH - 1:0] B_h;
			wire [WIDTH - 1:0] mul [3:0];
			wire [WIDTH - 1:0] srcA_low_adder;
			wire [WIDTH - 1:0] srcB_low_adder;
			wire [WIDTH - 1:0] result_low_adder;
			wire cin_low_adder;
			wire cout_low_adder;
			wire [WIDTH - 1:0] srcA_mid_adder;
			wire [WIDTH - 1:0] srcB_mid_adder;
			wire [WIDTH - 1:0] result_mid_adder;
			wire cin_mid_adder;
			wire cout_mid_adder;
			wire [WIDTH - 1:0] srcA_high_adder;
			wire [WIDTH - 1:0] srcB_high_adder;
			wire [WIDTH - 1:0] result_high_adder;
			wire cin_high_adder;
			wire cout_high_adder;
			wire or_carry;
			wire [(PREV_LEVEL_HL_NUM_PREV_RESULTS * HALF_WIDTH) - 1:0] prev_result_mul_la_lb;
			wire [(PREV_LEVEL_MID_NUM_PREV_RESULTS * HALF_WIDTH) - 1:0] prev_result_mul_la_hb;
			wire [(PREV_LEVEL_MID_NUM_PREV_RESULTS * HALF_WIDTH) - 1:0] prev_result_mul_ha_lb;
			wire [(PREV_LEVEL_HL_NUM_PREV_RESULTS * HALF_WIDTH) - 1:0] prev_result_mul_ha_hb;
			assign A_l = A[0+:HALF_WIDTH];
			assign A_h = A[WIDTH - 1-:HALF_WIDTH];
			assign B_l = B[0+:HALF_WIDTH];
			assign B_h = B[WIDTH - 1-:HALF_WIDTH];
			vedic_mul_unsigned #(
				.WIDTH(HALF_WIDTH),
				.MUL_IDX(2'b00),
				.MIN_MUL_LEVEL(MIN_MUL_LEVEL),
				.GET_MID_PREV_RESULTS(GET_MID_PREV_RESULTS)
			) mul_la_lb(
				.A(A_l),
				.B(B_l),
				.Z(mul[0]),
				.prev_result(prev_result_mul_la_lb)
			);
			vedic_mul_unsigned #(
				.WIDTH(HALF_WIDTH),
				.MUL_IDX(2'b01),
				.MIN_MUL_LEVEL(MIN_MUL_LEVEL),
				.GET_MID_PREV_RESULTS(GET_MID_PREV_RESULTS)
			) mul_la_hb(
				.A(A_l),
				.B(B_h),
				.Z(mul[1]),
				.prev_result(prev_result_mul_la_hb)
			);
			vedic_mul_unsigned #(
				.WIDTH(HALF_WIDTH),
				.MUL_IDX(2'b10),
				.MIN_MUL_LEVEL(MIN_MUL_LEVEL),
				.GET_MID_PREV_RESULTS(GET_MID_PREV_RESULTS)
			) mul_ha_lb(
				.A(A_h),
				.B(B_l),
				.Z(mul[2]),
				.prev_result(prev_result_mul_ha_lb)
			);
			vedic_mul_unsigned #(
				.WIDTH(HALF_WIDTH),
				.MUL_IDX(2'b11),
				.MIN_MUL_LEVEL(MIN_MUL_LEVEL),
				.GET_MID_PREV_RESULTS(GET_MID_PREV_RESULTS)
			) mul_ha_hb(
				.A(A_h),
				.B(B_h),
				.Z(mul[3]),
				.prev_result(prev_result_mul_ha_hb)
			);
			assign srcA_low_adder = {{HALF_WIDTH {1'b0}}, mul[0][WIDTH - 1-:HALF_WIDTH]};
			assign srcB_low_adder = result_mid_adder;
			assign cin_low_adder = 1'b0;
			adder_nbit #(
				.WIDTH(WIDTH),
				.RIPPLE_CARRY(1'b1),
				.BEHAVIORAL(1'b0)
			) low_adder(
				.A(srcA_low_adder),
				.B(srcB_low_adder),
				.cin(cin_low_adder),
				.S(result_low_adder),
				.cout(cout_low_adder)
			);
			assign srcA_mid_adder = mul[1];
			assign srcB_mid_adder = mul[2];
			assign cin_mid_adder = 1'b0;
			adder_nbit #(
				.WIDTH(WIDTH),
				.RIPPLE_CARRY(1'b1),
				.BEHAVIORAL(1'b0)
			) mid_adder(
				.A(srcA_mid_adder),
				.B(srcB_mid_adder),
				.cin(cin_mid_adder),
				.S(result_mid_adder),
				.cout(cout_mid_adder)
			);
			assign srcA_high_adder = {{HALF_WIDTH - 1 {1'b0}}, or_carry, result_low_adder[WIDTH - 1-:HALF_WIDTH]};
			assign srcB_high_adder = mul[3];
			assign cin_high_adder = 1'b0;
			adder_nbit #(
				.WIDTH(WIDTH),
				.RIPPLE_CARRY(1'b1),
				.BEHAVIORAL(1'b0)
			) high_adder(
				.A(srcA_high_adder),
				.B(srcB_high_adder),
				.cin(cin_high_adder),
				.S(result_high_adder),
				.cout(cout_high_adder)
			);
			assign or_carry = cout_low_adder | cout_mid_adder;
			assign Z[0+:HALF_WIDTH] = mul[0][0+:HALF_WIDTH];
			assign Z[HALF_WIDTH+:HALF_WIDTH] = result_low_adder[0+:HALF_WIDTH];
			assign Z[RESULT_WIDTH - 1-:WIDTH] = result_high_adder;
			if (VALID_PREV_RESULT) begin : genblk1
				always @(*) begin : sv2v_autoblock_1
					reg signed [31:0] num_prev_prev_result;
					reg signed [31:0] num_prev_prev_result_div;
					reg signed [31:0] accum_prev_level;
					reg signed [31:0] current_idx;
					accum_prev_level = 0;
					current_idx = 0;
					if (_sv2v_0)
						;
					if (GET_MID_PREV_RESULTS) begin
						begin : sv2v_autoblock_2
							reg signed [31:0] prev_level;
							for (prev_level = MIN_MUL_LEVEL; prev_level < MUL_LEVEL; prev_level = prev_level + 1)
								begin
									num_prev_prev_result = riscv_v_pkg_f_vedic_mul_num_prev_results_level_diff(MUL_LEVEL, prev_level - 1, GET_MID_PREV_RESULTS);
									num_prev_prev_result_div = num_prev_prev_result / 2;
									begin : sv2v_autoblock_3
										reg signed [31:0] lalb_idx;
										for (lalb_idx = accum_prev_level; lalb_idx < (accum_prev_level + num_prev_prev_result_div); lalb_idx = lalb_idx + 1)
											begin
												current_idx = current_idx + 1;
												prev_result[(current_idx + 1'sd1) * WIDTH+:WIDTH] = {{WIDTH - HALF_WIDTH {1'b0}}, prev_result_mul_la_lb[lalb_idx * HALF_WIDTH+:HALF_WIDTH]};
											end
									end
									begin : sv2v_autoblock_4
										reg signed [31:0] lahb_idx;
										for (lahb_idx = accum_prev_level; lahb_idx < (accum_prev_level + num_prev_prev_result_div); lahb_idx = lahb_idx + 1)
											begin
												current_idx = current_idx + 1;
												prev_result[(current_idx + 1'sd1) * WIDTH+:WIDTH] = {{WIDTH - HALF_WIDTH {1'b0}}, prev_result_mul_la_hb[lahb_idx * HALF_WIDTH+:HALF_WIDTH]};
											end
									end
									begin : sv2v_autoblock_5
										reg signed [31:0] halb_idx;
										for (halb_idx = accum_prev_level; halb_idx < (accum_prev_level + num_prev_prev_result_div); halb_idx = halb_idx + 1)
											begin
												current_idx = current_idx + 1;
												prev_result[(current_idx + 1'sd1) * WIDTH+:WIDTH] = {{WIDTH - HALF_WIDTH {1'b0}}, prev_result_mul_ha_lb[halb_idx * HALF_WIDTH+:HALF_WIDTH]};
											end
									end
									begin : sv2v_autoblock_6
										reg signed [31:0] hahb_idx;
										for (hahb_idx = accum_prev_level; hahb_idx < (accum_prev_level + num_prev_prev_result_div); hahb_idx = hahb_idx + 1)
											begin
												current_idx = current_idx + 1;
												prev_result[(current_idx + 1'sd1) * WIDTH+:WIDTH] = {{WIDTH - HALF_WIDTH {1'b0}}, prev_result_mul_ha_hb[hahb_idx * HALF_WIDTH+:HALF_WIDTH]};
											end
									end
									accum_prev_level = accum_prev_level + num_prev_prev_result_div;
								end
						end
						begin : sv2v_autoblock_7
							reg signed [31:0] new_idx;
							for (new_idx = 0; new_idx < 4; new_idx = new_idx + 1)
								begin
									current_idx = current_idx + 1;
									prev_result[(current_idx + 1'sd1) * WIDTH+:WIDTH] = mul[new_idx];
								end
						end
					end
					else begin
						begin : sv2v_autoblock_8
							reg signed [31:0] prev_level;
							for (prev_level = MIN_MUL_LEVEL; prev_level < MUL_LEVEL; prev_level = prev_level + 1)
								begin
									num_prev_prev_result = riscv_v_pkg_f_vedic_mul_num_prev_results_level_diff(MUL_LEVEL, prev_level - 1, GET_MID_PREV_RESULTS);
									num_prev_prev_result_div = num_prev_prev_result / 2;
									begin : sv2v_autoblock_9
										reg signed [31:0] lalb_idx;
										for (lalb_idx = accum_prev_level; lalb_idx < (accum_prev_level + num_prev_prev_result_div); lalb_idx = lalb_idx + 1)
											begin
												current_idx = current_idx + 1;
												prev_result[(current_idx + 1'sd1) * WIDTH+:WIDTH] = {{WIDTH - HALF_WIDTH {1'b0}}, prev_result_mul_la_lb[lalb_idx * HALF_WIDTH+:HALF_WIDTH]};
											end
									end
									begin : sv2v_autoblock_10
										reg signed [31:0] hahb_idx;
										for (hahb_idx = accum_prev_level; hahb_idx < (accum_prev_level + num_prev_prev_result_div); hahb_idx = hahb_idx + 1)
											begin
												current_idx = current_idx + 1;
												prev_result[(current_idx + 1'sd1) * WIDTH+:WIDTH] = {{WIDTH - HALF_WIDTH {1'b0}}, prev_result_mul_ha_hb[hahb_idx * HALF_WIDTH+:HALF_WIDTH]};
											end
									end
									accum_prev_level = accum_prev_level + num_prev_prev_result_div;
								end
						end
						begin : sv2v_autoblock_11
							reg signed [31:0] new_idx;
							for (new_idx = 0; new_idx < 2; new_idx = new_idx + 1)
								begin
									current_idx = current_idx + 1;
									prev_result[(current_idx + 1'sd1) * WIDTH+:WIDTH] = mul[new_idx * 3];
								end
						end
					end
				end
			end
			else begin : genblk1
				wire [WIDTH * 1:1] sv2v_tmp_7488D;
				assign sv2v_tmp_7488D = 1'sbz;
				always @(*) prev_result[0+:WIDTH] = sv2v_tmp_7488D;
			end
		end
		else begin : gen_base_multiplier
			multiplier_2bit mul(
				.A(A),
				.B(B),
				.Z(Z)
			);
			if (VALID_PREV_RESULT) begin : genblk1
				if (GET_MID_PREV_RESULTS) begin : genblk1
					wire [WIDTH * 1:1] sv2v_tmp_75243;
					assign sv2v_tmp_75243 = A[0] & B[0];
					always @(*) prev_result[0+:WIDTH] = sv2v_tmp_75243;
					wire [WIDTH * 1:1] sv2v_tmp_ED8D1;
					assign sv2v_tmp_ED8D1 = A[0] & B[1];
					always @(*) prev_result[WIDTH+:WIDTH] = sv2v_tmp_ED8D1;
					wire [WIDTH * 1:1] sv2v_tmp_511C5;
					assign sv2v_tmp_511C5 = A[1] & B[0];
					always @(*) prev_result[2 * WIDTH+:WIDTH] = sv2v_tmp_511C5;
					wire [WIDTH * 1:1] sv2v_tmp_73195;
					assign sv2v_tmp_73195 = A[1] & B[1];
					always @(*) prev_result[3 * WIDTH+:WIDTH] = sv2v_tmp_73195;
				end
				else begin : genblk1
					wire [WIDTH * 1:1] sv2v_tmp_75243;
					assign sv2v_tmp_75243 = A[0] & B[0];
					always @(*) prev_result[0+:WIDTH] = sv2v_tmp_75243;
					wire [WIDTH * 1:1] sv2v_tmp_99573;
					assign sv2v_tmp_99573 = A[1] & B[1];
					always @(*) prev_result[0+:WIDTH] = sv2v_tmp_99573;
				end
			end
			else begin : genblk1
				wire [WIDTH * 1:1] sv2v_tmp_7488D;
				assign sv2v_tmp_7488D = 1'sbz;
				always @(*) prev_result[0+:WIDTH] = sv2v_tmp_7488D;
			end
		end
	endgenerate
	initial _sv2v_0 = 0;
endmodule
