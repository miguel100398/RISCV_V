module riscv_v_stage_300C0 (
	clk,
	rst,
	en,
	flush,
	rst_val,
	flush_val,
	data_in,
	data_out,
	internal_data
);
	parameter signed [31:0] NUM_STAGES = 1;
	input wire clk;
	input wire rst;
	input wire en;
	input wire flush;
	input wire [0:0] rst_val;
	input wire [0:0] flush_val;
	input wire [0:0] data_in;
	output wire [0:0] data_out;
	output reg [(NUM_STAGES >= 0 ? NUM_STAGES + 0 : (1 - NUM_STAGES) + (NUM_STAGES - 1)):(NUM_STAGES >= 0 ? 0 : NUM_STAGES)] internal_data;
	wire [1:1] sv2v_tmp_D6C0F;
	assign sv2v_tmp_D6C0F = data_in;
	always @(*) internal_data[(NUM_STAGES >= 0 ? 0 : NUM_STAGES)+:1] = sv2v_tmp_D6C0F;
	genvar _gv_idx_1;
	generate
		for (_gv_idx_1 = 1; _gv_idx_1 <= NUM_STAGES; _gv_idx_1 = _gv_idx_1 + 1) begin : gen_stage_data
			localparam idx = _gv_idx_1;
			always @(posedge clk or posedge rst)
				if (rst)
					internal_data[(NUM_STAGES >= 0 ? idx : NUM_STAGES - idx)+:1] <= rst_val;
				else if (flush)
					internal_data[(NUM_STAGES >= 0 ? idx : NUM_STAGES - idx)+:1] <= flush_val;
				else if (en)
					internal_data[(NUM_STAGES >= 0 ? idx : NUM_STAGES - idx)+:1] <= internal_data[(NUM_STAGES >= 0 ? idx - 1 : NUM_STAGES - (idx - 1))+:1];
		end
	endgenerate
	assign data_out = internal_data[(NUM_STAGES >= 0 ? NUM_STAGES : NUM_STAGES - NUM_STAGES)+:1];
endmodule
