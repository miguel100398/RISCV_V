module riscv_v_reduct_src (
	src,
	is_reduct,
	is_reduct_n,
	osize_vector,
	is_greater_osize_vector,
	result,
	src_o
);
	reg _sv2v_0;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [127:0] src;
	input wire is_reduct;
	input wire is_reduct_n;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES = 5;
	input wire [4:0] osize_vector;
	input wire [4:0] is_greater_osize_vector;
	input wire [127:0] result;
	output wire [127:0] src_o;
	wire greater_than_sel [4:1];
	wire [127:0] src_gated;
	wire [127:0] result_gated;
	wire [127:0] result_gated_osize [3:0];
	wire [127:0] result_shifted [3:0];
	reg [127:0] result_selected;
	assign result_gated = result & {riscv_v_pkg_RISCV_V_DATA_WIDTH {is_reduct}};
	genvar _gv_osize_idx_1;
	generate
		for (_gv_osize_idx_1 = 1; _gv_osize_idx_1 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_1 = _gv_osize_idx_1 + 1) begin : gen_greater_than_sel
			localparam osize_idx = _gv_osize_idx_1;
			assign greater_than_sel[osize_idx] = is_reduct_n | is_greater_osize_vector[osize_idx];
		end
	endgenerate
	assign src_gated[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1)+:riscv_pkg_BYTE_WIDTH] = src[((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1) - ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1)+:riscv_pkg_BYTE_WIDTH];
	genvar _gv_osize_idx_2;
	generate
		for (_gv_osize_idx_2 = 1; _gv_osize_idx_2 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_2 = _gv_osize_idx_2 + 1) begin : gen_gate_src
			localparam osize_idx = _gv_osize_idx_2;
			localparam WIDTH = 8 * (2 ** (osize_idx - 1));
			localparam START_IDX = 8 * (2 ** (osize_idx - 1));
			assign src_gated[START_IDX+:WIDTH] = src[START_IDX+:WIDTH] & {WIDTH {greater_than_sel[osize_idx]}};
		end
	endgenerate
	genvar _gv_osize_idx_3;
	generate
		for (_gv_osize_idx_3 = 0; _gv_osize_idx_3 < 4; _gv_osize_idx_3 = _gv_osize_idx_3 + 1) begin : gen_gate_result_osize
			localparam osize_idx = _gv_osize_idx_3;
			assign result_gated_osize[osize_idx] = result_gated & {riscv_v_pkg_RISCV_V_DATA_WIDTH {osize_vector[osize_idx]}};
		end
	endgenerate
	genvar _gv_osize_idx_4;
	generate
		for (_gv_osize_idx_4 = 0; _gv_osize_idx_4 < 4; _gv_osize_idx_4 = _gv_osize_idx_4 + 1) begin : gen_result_shift
			localparam osize_idx = _gv_osize_idx_4;
			assign result_shifted[osize_idx] = result_gated_osize[osize_idx] << (8 * (2 ** osize_idx));
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		result_selected = 0;
		begin : sv2v_autoblock_1
			reg signed [31:0] osize_idx;
			for (osize_idx = 0; osize_idx < 4; osize_idx = osize_idx + 1)
				result_selected = result_selected | result_shifted[osize_idx];
		end
	end
	assign src_o = src_gated | result_selected;
	initial _sv2v_0 = 0;
endmodule
