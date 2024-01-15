//File: riscv_v.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension Top module

module riscv_v 
import riscv_pkg::*, riscv_v_pkg::*;
(
    //Clocks and resets
    input  logic clk,
    input  logic rst
);

    //Decode stage
    riscv_v_decode v_decode(
        .clk(clk),
        .rst(rst)
    );

    //Execute stage
    riscv_v_execute v_execute(
        .clk(clk),
        .rst(rst)
    );

    //Memory stage
    riscv_v_memory v_memory(
        .clk(clk),
        .rst(rst)
    );

endmodule: riscv_v 