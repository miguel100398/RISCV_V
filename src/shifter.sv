//File: shifter.sv
//Author: Miguel Bucio
//Date: 17/08/23
//Description: RISC-V Vector extension shifter

module shifter #(
    parameter int WIDTH = 8
    parameter int SHIFT_WIDTH = $clog2(WIDTH) + 1;
)
(
    input  logic [WIDTH-1:0]       src,
    input  logic [SHIFT_WIDTH-1:0] shift,
    input  logic                   shift_left,
    input  logic [WIDTH-1:0]       shift_in,
    output logic [WIDTH-1:0]       result
);

logic [WIDTH-1:0] src_swizzle;
logic [WIDTH-1:0] src_shift;
logic [WIDTH-1:0] shift_result;
logic [WIDTH-1:0] result_swizzle;

//Swizzle src
always_comb begin
    for (int i=0; i<WIDTH; i++) begin
        src_swizzle[i] = src[WIDTH-1-i];
    end
end

//Swizzle result
always_comb  begin
    for (int i=0; i<WIDTH; i++) begin
        result_swizzle[i] = shift_result[WIDTH-1-i];
    end
end

//Selec shift source, default shift is shift right
assign src_shift = (shift_left) ? src_swizzle : src;
//Shifter
assign shift_result = {shift_in, src_shift} >> shift;
//Select result
assign result = (shift_left) ? result_swizzle : shift_result;

endmodule: shifter