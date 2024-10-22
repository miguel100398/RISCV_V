module mul_vedic_test_latency (
	clk,
	srca_in,
	srcb_in,
	result,
	prev_result
);
	parameter WIDTH = 8;
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
	input wire clk;
	input wire [WIDTH - 1:0] srca_in;
	input wire [WIDTH - 1:0] srcb_in;
	output reg [RESULT_WIDTH - 1:0] result;
	output reg [(NUM_PREV_RESULTS * WIDTH) - 1:0] prev_result;
	reg [WIDTH - 1:0] srca;
	reg [WIDTH - 1:0] srcb;
	wire [RESULT_WIDTH - 1:0] mul_result;
	wire [(NUM_PREV_RESULTS * WIDTH) - 1:0] mul_prev_result;
	always @(posedge clk) begin
		srca <= srca_in;
		srcb <= srcb_in;
	end
	vedic_mul_unsigned #(
		.WIDTH(WIDTH),
		.MUL_IDX(MUL_IDX),
		.MIN_MUL_LEVEL(MIN_MUL_LEVEL),
		.GET_MID_PREV_RESULTS(GET_MID_PREV_RESULTS)
	) vedic_mul(
		.A(srca),
		.B(srcb),
		.Z(mul_result),
		.prev_result(mul_prev_result)
	);
	always @(posedge clk) begin
		result <= mul_result;
		prev_result <= mul_prev_result;
	end
endmodule
