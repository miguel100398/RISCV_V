//File: multiplier_2bit
//Author: Miguel Bucio
//Date: 20/09/23
//Description: Multiplier 2 bits

module multiplier_2bit(
    input  logic[1:0] A,
    input  logic[1:0] B,
    output logic[3:0] Z
);

//Partial products
logic  partial[1:0][1:0];

logic cout_ha;

always_comb begin
    for (int idx_A=0; idx_A < 2; idx_A++) begin
        for (int idx_B=0; idx_B < 2; idx_B++) begin
            partial[idx_A][idx_B] = A[idx_A] & B[idx_B];
        end
    end
end

assign Z[0] = partial[0][0];

//Half adders
half_adder ha0(
    .A(partial[0][1]),
    .B(partial[1][0]),
    .S(Z[1]),
    .cout(cout_ha)
);

half_adder ha1(
    .A(cout_ha),
    .B(partial[1][1]),
    .S(Z[2]),
    .cout(Z[3])
);

endmodule: multiplier_2bit
