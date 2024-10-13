module shifter (
	src,
	shift,
	shift_left,
	shift_arith,
	shift_in,
	result
);
	reg _sv2v_0;
	parameter signed [31:0] WIDTH = 8;
	parameter signed [31:0] SHIFT_WIDTH = $clog2(WIDTH);
	input wire [WIDTH - 1:0] src;
	input wire [SHIFT_WIDTH - 1:0] shift;
	input wire shift_left;
	input wire shift_arith;
	input wire [WIDTH - 1:0] shift_in;
	output wire [WIDTH - 1:0] result;
	reg [WIDTH - 1:0] src_swizzle;
	wire [WIDTH - 1:0] src_shift;
	wire [WIDTH - 1:0] shift_result;
	reg [WIDTH - 1:0] result_swizzle;
	reg [WIDTH - 1:0] shift_in_swizzle;
	reg [WIDTH - 1:0] shift_in_selected;
	wire [WIDTH - 1:0] shift_in_arith;
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < WIDTH; i = i + 1)
				begin
					src_swizzle[i] = src[(WIDTH - 1) - i];
					shift_in_swizzle[i] = shift_in[(WIDTH - 1) - i];
				end
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_2
			reg signed [31:0] i;
			for (i = 0; i < WIDTH; i = i + 1)
				result_swizzle[i] = shift_result[(WIDTH - 1) - i];
		end
	end
	assign src_shift = (shift_left ? src_swizzle : src);
	assign shift_in_arith = {WIDTH {src[WIDTH - 1]}};
	always @(*) begin
		if (_sv2v_0)
			;
		if (shift_left)
			shift_in_selected = shift_in_swizzle;
		else if (shift_arith)
			shift_in_selected = shift_in_arith;
		else
			shift_in_selected = shift_in;
	end
	assign shift_result = {shift_in_selected, src_shift} >> shift;
	assign result = (shift_left ? result_swizzle : shift_result);
	initial _sv2v_0 = 0;
endmodule
