module vedic_mul_unsigned_2bits(
    A,
    B,
    Z
);

input wire [1:0] A;
input wire [1:0] B;
output wire [3:0] Z;


multiplier_2bit mul(
    .A(A),
    .B(B),
    .Z(Z)
);

endmodule 