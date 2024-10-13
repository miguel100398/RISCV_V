module riscv_v_stage_C9449 (
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
	input wire rst_val;
	input wire flush_val;
	input wire data_in;
	output wire data_out;
	output reg [NUM_STAGES:0] internal_data;
	wire [1:1] sv2v_tmp_17784;
	assign sv2v_tmp_17784 = data_in;
	always @(*) internal_data[0] = sv2v_tmp_17784;
	genvar _gv_idx_1;
	generate
		for (_gv_idx_1 = 1; _gv_idx_1 <= NUM_STAGES; _gv_idx_1 = _gv_idx_1 + 1) begin : gen_stage_data
			localparam idx = _gv_idx_1;
			always @(posedge clk or posedge rst)
				if (rst)
					internal_data[idx] <= rst_val;
				else if (flush)
					internal_data[idx] <= flush_val;
				else if (en)
					internal_data[idx] <= internal_data[idx - 1];
		end
	endgenerate
	assign data_out = internal_data[NUM_STAGES];
endmodule
