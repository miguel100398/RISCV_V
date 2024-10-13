module riscv_v_stage_7EB58 (
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
	input wire [10:0] rst_val;
	input wire [10:0] flush_val;
	input wire [10:0] data_in;
	output wire [10:0] data_out;
	output reg [(NUM_STAGES >= 0 ? ((NUM_STAGES + 1) * 11) - 1 : ((1 - NUM_STAGES) * 11) + ((NUM_STAGES * 11) - 1)):(NUM_STAGES >= 0 ? 0 : NUM_STAGES * 11)] internal_data;
	wire [11:1] sv2v_tmp_2EEBE;
	assign sv2v_tmp_2EEBE = data_in;
	always @(*) internal_data[(NUM_STAGES >= 0 ? 0 : NUM_STAGES) * 11+:11] = sv2v_tmp_2EEBE;
	genvar _gv_idx_1;
	generate
		for (_gv_idx_1 = 1; _gv_idx_1 <= NUM_STAGES; _gv_idx_1 = _gv_idx_1 + 1) begin : gen_stage_data
			localparam idx = _gv_idx_1;
			always @(posedge clk or posedge rst)
				if (rst)
					internal_data[(NUM_STAGES >= 0 ? idx : NUM_STAGES - idx) * 11+:11] <= rst_val;
				else if (flush)
					internal_data[(NUM_STAGES >= 0 ? idx : NUM_STAGES - idx) * 11+:11] <= flush_val;
				else if (en)
					internal_data[(NUM_STAGES >= 0 ? idx : NUM_STAGES - idx) * 11+:11] <= internal_data[(NUM_STAGES >= 0 ? idx - 1 : NUM_STAGES - (idx - 1)) * 11+:11];
		end
	endgenerate
	assign data_out = internal_data[(NUM_STAGES >= 0 ? NUM_STAGES : NUM_STAGES - NUM_STAGES) * 11+:11];
endmodule
