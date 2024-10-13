module riscv_v_stage_63257_B3D37 (
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
	parameter signed [31:0] DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = 0;
	parameter signed [31:0] NUM_STAGES = 1;
	input wire clk;
	input wire rst;
	input wire en;
	input wire flush;
	input wire [DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] rst_val;
	input wire [DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] flush_val;
	input wire [DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] data_in;
	output wire [DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] data_out;
	output reg [(NUM_STAGES >= 0 ? ((NUM_STAGES + 1) * DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1 : ((1 - NUM_STAGES) * DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + ((NUM_STAGES * DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1)):(NUM_STAGES >= 0 ? 0 : NUM_STAGES * DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA)] internal_data;
	wire [DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * 1:1] sv2v_tmp_C7848;
	assign sv2v_tmp_C7848 = data_in;
	always @(*) internal_data[(NUM_STAGES >= 0 ? 0 : NUM_STAGES) * DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA+:DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] = sv2v_tmp_C7848;
	genvar _gv_idx_1;
	generate
		for (_gv_idx_1 = 1; _gv_idx_1 <= NUM_STAGES; _gv_idx_1 = _gv_idx_1 + 1) begin : gen_stage_data
			localparam idx = _gv_idx_1;
			always @(posedge clk or posedge rst)
				if (rst)
					internal_data[(NUM_STAGES >= 0 ? idx : NUM_STAGES - idx) * DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA+:DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] <= rst_val;
				else if (flush)
					internal_data[(NUM_STAGES >= 0 ? idx : NUM_STAGES - idx) * DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA+:DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] <= flush_val;
				else if (en)
					internal_data[(NUM_STAGES >= 0 ? idx : NUM_STAGES - idx) * DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA+:DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] <= internal_data[(NUM_STAGES >= 0 ? idx - 1 : NUM_STAGES - (idx - 1)) * DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA+:DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA];
		end
	endgenerate
	assign data_out = internal_data[(NUM_STAGES >= 0 ? NUM_STAGES : NUM_STAGES - NUM_STAGES) * DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA+:DATA_T_riscv_v_pkg_RISCV_V_NUM_BYTES_DATA];
endmodule
