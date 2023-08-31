//File: full_adder.sv
//Author: Miguel Bucio
//Date: 31/08/23
//Description: RISC-V Vector 1 bit full adder 

module full_adder(
    input  logic A,
    input  logic B,
    input  logic cin,
    output logic S,
    output logic cout
);

    logic a_xor_b;
    logic a_and_b;
    logic a_xor_b_and_cin;

    assign a_xor_b          = A ^ B;
    assign a_and_b          = A & B;
    assign a_xor_b_and_cin  = a_xor_b & cin;

    assign S     = a_xor_b ^ cin;
    assign cout  = a_and_b | a_xor_b_and_cin;

endmodule: full_adder