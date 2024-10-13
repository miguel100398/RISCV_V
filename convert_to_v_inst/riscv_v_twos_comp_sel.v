module riscv_v_twos_comp_sel (
	in,
	complement,
	osize_vector,
	merge,
	out
);
	reg _sv2v_0;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	parameter BLOCK_WIDTH = riscv_pkg_BYTE_WIDTH;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * BLOCK_WIDTH) - 1:0] in;
	input wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] complement;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES = 5;
	input wire [4:0] osize_vector;
	input wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] merge;
	output wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * BLOCK_WIDTH) - 1:0] out;
	localparam NUM_TWOS_COMP_BLOCKS = riscv_v_pkg_RISCV_V_NUM_BYTES_DATA;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] carry_out_adders;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] carry_in_adders;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * BLOCK_WIDTH) - 1:0] in_xor;
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] complement_ext;
	reg [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] complement_ext_osize [4:0];
	genvar _gv_osize_idx_11;
	generate
		for (_gv_osize_idx_11 = 0; _gv_osize_idx_11 < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; _gv_osize_idx_11 = _gv_osize_idx_11 + 1) begin : gen_ext_comp
			localparam osize_idx = _gv_osize_idx_11;
			localparam OSIZE_WIDTH = riscv_pkg_BYTE_WIDTH * (2 ** osize_idx);
			localparam JUMP_SIZE = OSIZE_WIDTH / riscv_pkg_BYTE_WIDTH;
			localparam NUM_BLOCKS = riscv_v_pkg_RISCV_V_DATA_WIDTH / OSIZE_WIDTH;
			always @(*) begin
				if (_sv2v_0)
					;
				begin : sv2v_autoblock_1
					reg signed [31:0] i;
					for (i = 0; i < NUM_BLOCKS; i = i + 1)
						complement_ext_osize[osize_idx][i * JUMP_SIZE+:JUMP_SIZE] = {JUMP_SIZE {complement[i * JUMP_SIZE]}};
				end
			end
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		complement_ext = 1'sb0;
		begin : sv2v_autoblock_2
			reg signed [31:0] osize_idx;
			for (osize_idx = 0; osize_idx < riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES; osize_idx = osize_idx + 1)
				complement_ext = complement_ext | (complement_ext_osize[osize_idx] & {riscv_v_pkg_RISCV_V_NUM_BYTES_DATA {osize_vector[osize_idx]}});
		end
	end
	assign carry_in_adders[0] = complement[0];
	genvar _gv_carry_idx_1;
	generate
		for (_gv_carry_idx_1 = 1; _gv_carry_idx_1 < riscv_v_pkg_RISCV_V_NUM_BYTES_DATA; _gv_carry_idx_1 = _gv_carry_idx_1 + 1) begin : gen_carry
			localparam carry_idx = _gv_carry_idx_1;
			assign carry_in_adders[carry_idx] = complement[carry_idx] | (carry_out_adders[carry_idx - 1] & merge[carry_idx - 1]);
		end
	endgenerate
	genvar _gv_block_idx_4;
	generate
		for (_gv_block_idx_4 = 0; _gv_block_idx_4 < riscv_v_pkg_RISCV_V_NUM_BYTES_DATA; _gv_block_idx_4 = _gv_block_idx_4 + 1) begin : gen_twos_comp_blocks
			localparam block_idx = _gv_block_idx_4;
			assign in_xor[block_idx * BLOCK_WIDTH+:BLOCK_WIDTH] = in[block_idx * BLOCK_WIDTH+:BLOCK_WIDTH] ^ {BLOCK_WIDTH {complement_ext[block_idx]}};
			localparam signed [31:0] sv2v_uu_adder_WIDTH = BLOCK_WIDTH;
			localparam [BLOCK_WIDTH - 1:0] sv2v_uu_adder_ext_B_0 = 1'sb0;
			adder_nbit #(
				.WIDTH(BLOCK_WIDTH),
				.RIPPLE_CARRY(1'b0),
				.BEHAVIORAL(1'b1)
			) adder(
				.A(in_xor[block_idx * BLOCK_WIDTH+:BLOCK_WIDTH]),
				.B(sv2v_uu_adder_ext_B_0),
				.cin(carry_in_adders[block_idx]),
				.S(out[block_idx * BLOCK_WIDTH+:BLOCK_WIDTH]),
				.cout(carry_out_adders[block_idx])
			);
		end
	endgenerate
	initial _sv2v_0 = 0;
endmodule
