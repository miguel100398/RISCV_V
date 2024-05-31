//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 12/03/2022
//Behavioral Adder

module Adder#(
    parameter int unsigned WIDTH      = 32
) (
    input  logic            c_in,
    input  logic[WIDTH-1:0] A,
    input  logic[WIDTH-1:0] B,
    output logic[WIDTH-1:0] S,
    output logic            c_out
);

    assign {c_out, S} = A + B + c_in;

endmodule: Adder