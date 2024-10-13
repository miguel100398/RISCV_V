module riscv_v_permutation_ALU (
	is_i2v,
	is_v2i,
	srca,
	srcb,
	osize_vector,
	osize_greater_vector,
	integer_data_out,
	vector_data_out
);
	reg _sv2v_0;
	input wire is_i2v;
	input wire is_v2i;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srca;
	input wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srcb;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES = 5;
	input wire [4:0] osize_vector;
	input wire [4:0] osize_greater_vector;
	localparam signed [31:0] riscv_pkg_DWORD_WIDTH = 32;
	localparam signed [31:0] riscv_pkg_RISCV_DATA_WIDTH = riscv_pkg_DWORD_WIDTH;
	localparam signed [31:0] riscv_pkg_RISCV_NUM_BYTES_DATA = riscv_pkg_RISCV_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	localparam signed [31:0] riscv_pkg_DQWORD_WIDTH = 128;
	localparam signed [31:0] riscv_pkg_RISCV_NUM_DQWORDS_DATA = riscv_pkg_RISCV_DATA_WIDTH / riscv_pkg_DQWORD_WIDTH;
	localparam signed [31:0] riscv_pkg_RISCV_NUM_DWORDS_DATA = riscv_pkg_RISCV_DATA_WIDTH / riscv_pkg_DWORD_WIDTH;
	localparam signed [31:0] riscv_pkg_QWORD_WIDTH = 64;
	localparam signed [31:0] riscv_pkg_RISCV_NUM_QWORDS_DATA = riscv_pkg_RISCV_DATA_WIDTH / riscv_pkg_QWORD_WIDTH;
	localparam signed [31:0] riscv_pkg_WORD_WIDTH = 16;
	localparam signed [31:0] riscv_pkg_RISCV_NUM_WORDS_DATA = riscv_pkg_RISCV_DATA_WIDTH / riscv_pkg_WORD_WIDTH;
	output reg [31:0] integer_data_out;
	output wire [(128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] vector_data_out;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_INT_OSIZES = 3;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_INT_VALID_OSIZES = riscv_v_pkg_RISCV_V_NUM_INT_OSIZES;
	wire [31:0] v2i_result_osize [2:0];
	wire [127:0] i2v_src;
	wire [127:0] i2v_result_qual_osize;
	wire [127:0] i2v_result_qual;
	wire [127:0] v2i_src;
	assign i2v_src = srca[128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))-:((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) ? ((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0))) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) - (128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)))) + 1)] & {riscv_v_pkg_RISCV_V_DATA_WIDTH {is_i2v}};
	assign i2v_result_qual = i2v_src;
	assign vector_data_out[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] = srca[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA];
	assign vector_data_out[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127-:((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) ? ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127)) + 1)] = i2v_result_qual;
	assign v2i_src = srcb[128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))-:((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) ? ((128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1))) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0))) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) - (128 + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1)))) + 1)] & {riscv_v_pkg_RISCV_V_DATA_WIDTH {is_v2i}};
	genvar _gv_osize_idx_16;
	generate
		for (_gv_osize_idx_16 = 0; _gv_osize_idx_16 < 2; _gv_osize_idx_16 = _gv_osize_idx_16 + 1) begin : genblk1
			localparam osize_idx = _gv_osize_idx_16;
			localparam OSIZE_WIDTH = riscv_pkg_BYTE_WIDTH * (2 ** osize_idx);
			assign v2i_result_osize[osize_idx] = {{riscv_pkg_RISCV_DATA_WIDTH - OSIZE_WIDTH {v2i_src[OSIZE_WIDTH - 1]}}, v2i_src[OSIZE_WIDTH - 1:0]} & {riscv_pkg_RISCV_DATA_WIDTH {osize_vector[osize_idx]}};
		end
	endgenerate
	assign v2i_result_osize[2] = v2i_src[31:0] & {riscv_pkg_RISCV_DATA_WIDTH {|osize_vector[4:2]}};
	always @(*) begin
		if (_sv2v_0)
			;
		integer_data_out = 0;
		begin : sv2v_autoblock_1
			reg signed [31:0] osize_idx;
			for (osize_idx = 0; osize_idx < riscv_v_pkg_RISCV_V_NUM_INT_VALID_OSIZES; osize_idx = osize_idx + 1)
				integer_data_out = integer_data_out | v2i_result_osize[osize_idx];
		end
	end
	initial _sv2v_0 = 0;
endmodule
