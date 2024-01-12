//File: adder_nbit.sv
//Author: Miguel Bucio
//Date: 31/08/23
//Description: Parametrizable adder

module adder_nbit#(
    parameter int    WIDTH      = 8,
    parameter string ADDER_TYPE = "BEHAVIORAL_ADDER"
) (
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    input  logic             cin,
    output logic [WIDTH-1:0] S,
    output logic             prev_cout,   //cout[N-1]
    output logic             cout         //cout[N]
);

initial begin 
    if ((ADDER_TYPE != "RIPPLE_CARRY_ADDER") && (ADDER_TYPE != "BEHAVIORAL_ADDER")) begin
        $fatal("Invalid adder type: %s", ADDER_TYPE);
    end 
end 

//Generate adder
generate 
    if (ADDER_TYPE == "RIPPLE_CARRY_ADDER") begin : get_ripple_carry_adder 
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
    end else if (ADDER_TYPE == "BEHAVIORAL_ADDER") begin : gen_behavioral_adder 
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