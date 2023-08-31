//File: ripple_carry_adder.sv
//Author: Miguel Bucio
//Date: 31/08/23
//Description: ripple carry adder 

module ripple_carry_adder#(
    parameter WIDTH = 8
)(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    input  logic             cin,
    output logic [WIDTH-1:0] S,
    output logic             prev_cout,   //cout[N-1]
    output logic             cout         //cout[N]
);

//Carry out vector
logic[WIDTH:0] cout_vector;

//First cout_vector is cin
assign cout_vector[0] = cin;

//Generate adders
generate
    for (genvar block=0; block<WIDTH; block++) begin : gen_adder 

        full_adder adder(
            .A(A[block]),
            .B(B[block]),
            .cin(cout_vector[block]),
            .S(S[block]),
            .cout(cout_vector[block+1])
        );     

    end

endgenerate

    //Assign cout
    assign cout = cout_vector[WIDTH];
    assign prev_cout = cout_vector[WIDTH-1];

endmodule: ripple_carry_adder