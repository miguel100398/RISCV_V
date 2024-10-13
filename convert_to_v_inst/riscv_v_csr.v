module riscv_v_csr (
	clk,
	rst,
	vsstatus_data_in,
	vsstatus_wr_en,
	vsstatus_data_out,
	vtype_data_in,
	vtype_wr_en,
	vtype_data_out,
	vl_data_in,
	vl_wr_en,
	vl_data_out,
	vlenb_data_out,
	vstart_data_in,
	vstart_wr_en,
	vstart_data_out,
	vxrm_data_in,
	vxrm_wr_en,
	vxrm_data_out,
	vxsat_data_in,
	vxsat_wr_en,
	vxsat_data_out,
	vcsr_data_out
);
	input wire clk;
	input wire rst;
	input wire [10:0] vsstatus_data_in;
	input wire vsstatus_wr_en;
	output wire [10:0] vsstatus_data_out;
	input wire [8:0] vtype_data_in;
	input wire vtype_wr_en;
	output wire [8:0] vtype_data_out;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_MAX_LMUL = 8;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_MAX_VLEN = riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG * riscv_v_pkg_RISCV_V_MAX_LMUL;
	input wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vl_data_in;
	input wire vl_wr_en;
	output wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vl_data_out;
	output wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vlenb_data_out;
	input wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vstart_data_in;
	input wire vstart_wr_en;
	output wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vstart_data_out;
	input wire [1:0] vxrm_data_in;
	input wire vxrm_wr_en;
	output wire [1:0] vxrm_data_out;
	input wire [0:0] vxsat_data_in;
	input wire vxsat_wr_en;
	output wire [0:0] vxsat_data_out;
	output wire [2:0] vcsr_data_out;
	reg [10:0] vsstatus;
	reg [8:0] vtype;
	reg [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vl;
	wire [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vlenb;
	reg [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] vstart;
	reg [1:0] vxrm;
	reg [0:0] vxsat;
	wire [2:0] vcsr;
	localparam [10:0] riscv_v_pkg_RISCV_V_VSSTATUS_RST_VAL = 11'b00000000000;
	always @(posedge clk or posedge rst)
		if (rst)
			vsstatus <= riscv_v_pkg_RISCV_V_VSSTATUS_RST_VAL;
		else if (vsstatus_wr_en)
			vsstatus <= vsstatus_data_in;
	assign vsstatus_data_out = (vsstatus_wr_en ? vsstatus_data_in : vsstatus);
	localparam [8:0] riscv_v_pkg_RISCV_V_VTYPE_RST_VAL = 9'b011000000;
	always @(posedge clk or posedge rst)
		if (rst)
			vtype <= riscv_v_pkg_RISCV_V_VTYPE_RST_VAL;
		else if (vtype_wr_en)
			vtype <= vtype_data_in;
	assign vtype_data_out = (vtype_wr_en ? vtype_data_in : vtype);
	function automatic [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] sv2v_cast_1B878;
		input reg [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] inp;
		sv2v_cast_1B878 = inp;
	endfunction
	localparam [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] riscv_v_pkg_RISCV_V_VL_RST_VAL = {sv2v_cast_1B878(riscv_v_pkg_RISCV_V_NUM_ELEMENTS_REG)};
	always @(posedge clk or posedge rst)
		if (rst)
			vl <= riscv_v_pkg_RISCV_V_VL_RST_VAL;
		else if (vl_wr_en)
			vl <= vl_data_in;
	assign vl_data_out = (vl_wr_en ? vl_data_in : vl);
	assign vlenb = (vl_wr_en ? vl_data_in >> 3 : vl[$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1-:$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN)] >> 3);
	assign vlenb_data_out = vlenb;
	function automatic [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] sv2v_cast_5C52B;
		input reg [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] inp;
		sv2v_cast_5C52B = inp;
	endfunction
	localparam [$clog2(riscv_v_pkg_RISCV_V_MAX_VLEN) - 1:0] riscv_v_pkg_RISCV_V_VSTART_RST_VAL = {sv2v_cast_5C52B(1'sb0)};
	always @(posedge clk or posedge rst)
		if (rst)
			vstart <= riscv_v_pkg_RISCV_V_VSTART_RST_VAL;
		else if (vstart_wr_en)
			vstart <= vstart_data_in;
	assign vstart_data_out = (vstart_wr_en ? vstart_data_in : vstart);
	localparam [1:0] riscv_v_pkg_RISCV_V_VXRM_RST_VAL = 2'b00;
	always @(posedge clk or posedge rst)
		if (rst)
			vxrm <= riscv_v_pkg_RISCV_V_VXRM_RST_VAL;
		else if (vxrm_wr_en)
			vxrm <= vxrm_data_in;
	assign vxrm_data_out = (vxrm_wr_en ? vxrm_data_in : vxrm);
	localparam [0:0] riscv_v_pkg_RISCV_V_VXSAT_RST_VAL = 1'b0;
	always @(posedge clk or posedge rst)
		if (rst)
			vxsat <= riscv_v_pkg_RISCV_V_VXSAT_RST_VAL;
		else if (vxsat_wr_en)
			vxsat <= vxsat_data_in;
	assign vxsat_data_out = (vxsat_wr_en ? vxsat_data_in : vxsat);
	assign vcsr[2-:2] = (vxrm_wr_en ? vxrm_data_in[1-:2] : vxrm[1-:2]);
	assign vcsr[0] = (vxsat_wr_en ? vxsat_data_in[0] : vxsat[0]);
	assign vcsr_data_out = vcsr;
endmodule
