module riscv_v_arithmetic_ALU (
	is_reduct,
	is_add,
	is_sub,
	is_negate_srca,
	is_negate_srcb,
	is_mul,
	is_zero_ext,
	is_sign_ext,
	is_set_equal,
	is_set_nequal,
	is_set_less,
	is_set_greater,
	is_max,
	is_min,
	is_high,
	is_signed,
	use_carry,
	dst_osize_vector,
	src_osize_vector,
	is_greater_osize_vector,
	is_less_osize_vector,
	srca,
	srcb,
	carry_in,
	result,
	zf,
	of,
	cf
);
	input wire is_reduct;
	input wire is_add;
	input wire is_sub;
	input wire is_negate_srca;
	input wire is_negate_srcb;
	input wire is_mul;
	input wire is_zero_ext;
	input wire is_sign_ext;
	input wire is_set_equal;
	input wire is_set_nequal;
	input wire is_set_less;
	input wire is_set_greater;
	input wire is_max;
	input wire is_min;
	input wire is_high;
	input wire is_signed;
	input wire use_carry;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_VALID_OSIZES = 5;
	input wire [4:0] dst_osize_vector;
	input wire [4:0] src_osize_vector;
	input wire [4:0] is_greater_osize_vector;
	input wire [4:0] is_less_osize_vector;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_ELEN = 128;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_VLEN = riscv_v_pkg_RISCV_V_ELEN;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_DATA_WIDTH = riscv_v_pkg_RISCV_V_VLEN;
	localparam signed [31:0] riscv_pkg_BYTE_WIDTH = 8;
	localparam signed [31:0] riscv_v_pkg_RISCV_V_NUM_BYTES_DATA = riscv_v_pkg_RISCV_V_DATA_WIDTH / riscv_pkg_BYTE_WIDTH;
	input wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srca;
	input wire [((128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] srcb;
	input wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] carry_in;
	output wire [(128 + riscv_v_pkg_RISCV_V_NUM_BYTES_DATA) - 1:0] result;
	output wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] zf;
	output wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] of;
	output wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] cf;
	wire valid_adder;
	wire is_reduct_n;
	wire is_arithmetic;
	wire is_min_max;
	wire is_compare;
	wire valid_result;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] adder_result;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] adder_result_qual;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] mul_result;
	wire [(riscv_v_pkg_RISCV_V_NUM_BYTES_DATA * riscv_pkg_BYTE_WIDTH) - 1:0] extend_result;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] zf_adder;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] of_adder;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] cf_adder;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] zf_qual;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] of_qual;
	wire [riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1:0] cf_qual;
	assign is_reduct_n = ~is_reduct;
	assign is_min_max = is_min || is_max;
	assign is_compare = ((is_set_equal || is_set_nequal) || is_set_less) || is_set_greater;
	assign is_arithmetic = ((is_add || is_sub) & ~is_min_max) & ~is_compare;
	assign valid_adder = (is_arithmetic || is_min_max) || is_compare;
	assign valid_result = ((valid_adder || is_mul) || is_zero_ext) || is_sign_ext;
	riscv_v_adder adder(
		.valid_adder(valid_adder),
		.is_reduct(is_reduct),
		.is_reduct_n(is_reduct_n),
		.is_add(is_add),
		.is_sub(is_sub),
		.is_negate_srca(is_negate_srca),
		.is_negate_srcb(is_negate_srcb),
		.is_max(is_max),
		.is_set_equal(is_set_equal),
		.is_set_nequal(is_set_nequal),
		.is_set_less(is_set_less),
		.is_set_greater(is_set_greater),
		.is_arithmetic(is_arithmetic),
		.is_min_max(is_min_max),
		.is_signed(is_signed),
		.use_carry(use_carry),
		.osize_vector(dst_osize_vector),
		.is_greater_osize_vector(is_greater_osize_vector),
		.srca(srca),
		.srcb(srcb),
		.carry_in(carry_in),
		.result(adder_result),
		.zf(zf_adder),
		.of(of_adder),
		.cf(cf_adder)
	);
	riscv_v_mul multiplier(
		.is_mul(is_mul),
		.is_high(is_high),
		.is_signed(is_signed),
		.osize_vector(dst_osize_vector),
		.srca(srca),
		.srcb(srcb),
		.result(mul_result)
	);
	riscv_v_extend extend(
		.is_zero_ext(is_zero_ext),
		.is_sign_ext(is_sign_ext),
		.src_osize_vector(src_osize_vector),
		.dst_osize_vector(dst_osize_vector),
		.src(srcb),
		.result(extend_result)
	);
	assign adder_result_qual = adder_result & {riscv_v_pkg_RISCV_V_DATA_WIDTH {valid_adder}};
	assign zf_qual = zf_adder & {riscv_v_pkg_RISCV_V_NUM_BYTES_DATA {is_arithmetic}};
	assign of_qual = of_adder & {riscv_v_pkg_RISCV_V_NUM_BYTES_DATA {is_arithmetic}};
	assign cf_qual = cf_adder & {riscv_v_pkg_RISCV_V_NUM_BYTES_DATA {is_arithmetic}};
	assign result[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127-:((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127) >= (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) ? ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0)) + 1 : ((riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 0) - (riscv_v_pkg_RISCV_V_NUM_BYTES_DATA + 127)) + 1)] = (adder_result_qual | mul_result) | extend_result;
	assign zf = zf_qual;
	assign of = of_qual;
	assign cf = cf_qual;
	assign result[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] = srca[riscv_v_pkg_RISCV_V_NUM_BYTES_DATA - 1-:riscv_v_pkg_RISCV_V_NUM_BYTES_DATA] & {riscv_v_pkg_RISCV_V_NUM_BYTES_DATA {valid_result}};
endmodule
