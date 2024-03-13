//File: behavioral_adder.sv
//Author: Miguel Bucio
//Date: 16/09/23
//Description: behavioral adder 
`timescale 1ns/1ps

module behavioral_adder#(
    parameter WIDTH = 8
)(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    input  logic             cin,
    output logic [WIDTH-1:0] S,
    output logic             prev_cout,   //cout[N-1]
    output logic             cout         //cout[N]
);


    assign {prev_cout, S[WIDTH-2:0]}    = A[WIDTH-2:0]    + B[WIDTH-2:0]    + cin;
    assign {cout,      S[WIDTH-1 -: 1]} = A[WIDTH-1 -: 1] + B[WIDTH-1 -: 1] + prev_cout;


endmodule: behavioral_adder