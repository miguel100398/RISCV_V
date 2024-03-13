//File: half_adder.sv
//Author: Miguel Bucio
//Date: 20/09/23
//Description: RISC-V Vector 1 bit Half adder 
`timescale 1ns/1ps

module half_adder(
    input  logic A,
    input  logic B,
    output logic S,
    output logic cout
);

assign S    = A ^ B;
assign cout = A & B;

endmodule: half_adder