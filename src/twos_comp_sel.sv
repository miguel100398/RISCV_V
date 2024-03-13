//File: riscv_v_twos_comp_sel.sv
//Author: Miguel Bucio
//Date: 16/09/23
//Description: twos complements with selector
`timescale 1ns/1ps

module twos_comp_sel#(
    parameter int WIDTH = 0
) (
    input  logic [WIDTH-1:0] in,
    input  logic             complement,
    output logic [WIDTH-1:0] out
);

    logic [WIDTH-1:0] in_xor;
    logic [WIDTH-1:0] srcb_adder;

    assign in_xor = in ^ {WIDTH[complement]};

    assign srcb_adder = {{(WIDTH-1){1'b0}}, complement};

    //adder 
    adder_nbit#(
        .BEHAVIORAL(1'b1),
        .RIPPLE_CARRY(1'b0),
        .WIDTH(WIDTH)
    ) adder (
        .A(in_xor),
        .B(srcb_adder),
        .cin(1'b0),
        .S(out)
    );

endmodule: twos_comp_sel