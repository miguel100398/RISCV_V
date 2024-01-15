//File: riscv_v_bitwise_xor.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector extensionBit wise and 8 bits

module riscv_v_bitwise_xor
import riscv_v_pkg::*, riscv_pkg::*;
#(
    parameter int DATA_WIDTH = 8
)(
    input  logic [DATA_WIDTH-1:0] A,
    input  logic [DATA_WIDTH-1:0] B,
    output logic [DATA_WIDTH-1:0] S
);

    assign S = A ^ B;

endmodule: riscv_v_bitwise_xor