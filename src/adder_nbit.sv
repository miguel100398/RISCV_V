//File: adder_nbit.sv
//Author: Miguel Bucio
//Date: 31/08/23
//Description: Parametrizable adder
`timescale 1ns/1ps

module adder_nbit#(
    parameter int    WIDTH         = 8,
    parameter bit BEHAVIORAL       = 1'b1,
    parameter bit RIPPLE_CARRY     = 1'b0
) (
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    input  logic             cin,
    output logic [WIDTH-1:0] S,
    output logic             prev_cout,   //cout[N-1]
    output logic             cout         //cout[N]
);

`ifndef SYNTHESIS
    initial begin 
        if (!$onehot({BEHAVIORAL, RIPPLE_CARRY})) begin
            $fatal(1, "Invalid adder type {BEHAVIORAL, RIPPLE_CARRY}: %0b", {BEHAVIORAL, RIPPLE_CARRY});
        end 
    end
`endif //SYNTHESIS 

//Generate adder
generate 
    if (RIPPLE_CARRY) begin : get_ripple_carry_adder 
        ripple_carry_adder #(
            .WIDTH(WIDTH)
        ) adder (
            .A(A),
            .B(B),
            .cin(cin),
            .S(S),
            .prev_cout(prev_cout),
            .cout(cout)
        );
    end else if (BEHAVIORAL) begin : gen_behavioral_adder 
        behavioral_adder #(
            .WIDTH(WIDTH)
        ) adder (
            .A(A),
            .B(B),
            .cin(cin),
            .S(S),
            .prev_cout(prev_cout),
            .cout(cout)
        );
    end else begin : gen_default_adder
        behavioral_adder #(
            .WIDTH(WIDTH)
        ) adder (
            .A(A),
            .B(B),
            .cin(cin),
            .S(S),
            .prev_cout(prev_cout),
            .cout(cout)
        );
    end
endgenerate

endmodule: adder_nbit
