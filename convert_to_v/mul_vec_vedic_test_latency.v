module mul_vec_vedic_test_latency (
	clk,
	srca,
	srcb,
	osize,
	result
);
	reg _sv2v_0;
	input wire clk;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [127:0] srca;
	input wire [127:0] srcb;
	input wire [2:0] osize;
	output reg [255:0] result;
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
	wire [(NUM_PREV_RESULTS * riscv_v_pkg_RISCV_V_DATA_WIDTH) - 1:0] prev_results;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES = 5;
	wire [255:0] mul_result_osize [4:0];
	mul_vedic_test_latency #(
		.WIDTH(riscv_v_pkg_RISCV_V_DATA_WIDTH),
		.MUL_IDX(2'b00),
		.MIN_MUL_LEVEL(MIN_MUL_LEVEL),
		.GET_MID_PREV_RESULTS(1'b0)
	) vedic_mul(
		.clk(clk),
		.srca_in(srca),
		.srcb_in(srcb),
		.result(mul_result_osize[4]),
		.prev_result(prev_results)
	);
	genvar _gv_osize_idx_1;
	function automatic signed [31:0] riscv_v_pkg_f_vedic_mul_start_prev_idx;
		input reg signed [31:0] osize;
		reg signed [31:0] osize_width;
		reg signed [31:0] num_results;
		begin
			num_results = 0;
			begin : sv2v_autoblock_1
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
	generate
		for (_gv_osize_idx_1 = 0; _gv_osize_idx_1 < 4; _gv_osize_idx_1 = _gv_osize_idx_1 + 1) begin : gen_select_prev_result_osize
			localparam osize_idx = _gv_osize_idx_1;
			localparam OSIZE_WIDTH = riscv_pkg_BYTE_WIDTH * (2 ** osize_idx);
			localparam RESULT_WIDTH = 2 * OSIZE_WIDTH;
			localparam NUM_RESULTS = riscv_v_pkg_RISCV_V_DATA_WIDTH / OSIZE_WIDTH;
			localparam START_PREV_IDX = riscv_v_pkg_f_vedic_mul_start_prev_idx(osize_idx);
			genvar _gv_result_idx_1;
			for (_gv_result_idx_1 = 0; _gv_result_idx_1 < NUM_RESULTS; _gv_result_idx_1 = _gv_result_idx_1 + 1) begin : gen_select_prev_result_result
				localparam result_idx = _gv_result_idx_1;
				assign mul_result_osize[osize_idx][result_idx * RESULT_WIDTH+:RESULT_WIDTH] = prev_results[(START_PREV_IDX + result_idx) * riscv_v_pkg_RISCV_V_DATA_WIDTH+:RESULT_WIDTH];
			end
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		case (osize)
			3'd0: {result[128+:128], result[0+:128]} = mul_result_osize[0];
			3'd1: {result[128+:128], result[0+:128]} = mul_result_osize[1];
			3'd2: {result[128+:128], result[0+:128]} = mul_result_osize[2];
			3'd3: {result[128+:128], result[0+:128]} = mul_result_osize[3];
			3'd4: {result[128+:128], result[0+:128]} = mul_result_osize[4];
			default: {result[128+:128], result[0+:128]} = 1'sbx;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
