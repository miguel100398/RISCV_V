module riscv_v_stage_21BCA (
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
	input wire [5:0] rst_val;
	input wire [5:0] flush_val;
	input wire [5:0] data_in;
	output wire [5:0] data_out;
	output reg [(NUM_STAGES >= 0 ? ((NUM_STAGES + 1) * 6) - 1 : ((1 - NUM_STAGES) * 6) + ((NUM_STAGES * 6) - 1)):(NUM_STAGES >= 0 ? 0 : NUM_STAGES * 6)] internal_data;
	wire [6:1] sv2v_tmp_3BCE8;
	assign sv2v_tmp_3BCE8 = data_in;
	always @(*) internal_data[(NUM_STAGES >= 0 ? 0 : NUM_STAGES) * 6+:6] = sv2v_tmp_3BCE8;
	genvar _gv_idx_1;
	generate
		for (_gv_idx_1 = 1; _gv_idx_1 <= NUM_STAGES; _gv_idx_1 = _gv_idx_1 + 1) begin : gen_stage_data
			localparam idx = _gv_idx_1;
			always @(posedge clk or posedge rst)
				if (rst)
					internal_data[(NUM_STAGES >= 0 ? idx : NUM_STAGES - idx) * 6+:6] <= rst_val;
				else if (flush)
					internal_data[(NUM_STAGES >= 0 ? idx : NUM_STAGES - idx) * 6+:6] <= flush_val;
				else if (en)
					internal_data[(NUM_STAGES >= 0 ? idx : NUM_STAGES - idx) * 6+:6] <= internal_data[(NUM_STAGES >= 0 ? idx - 1 : NUM_STAGES - (idx - 1)) * 6+:6];
		end
	endgenerate
	assign data_out = internal_data[(NUM_STAGES >= 0 ? NUM_STAGES : NUM_STAGES - NUM_STAGES) * 6+:6];
endmodule
