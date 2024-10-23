module bw_and#(
    parameter WIDTH = 8
)(
    input wire [WIDTH-1:0] A,
    input wire [WIDTH-1:0] B,
    output wire [WIDTH-1:0] S
);

assign S = A & B;

endmodule