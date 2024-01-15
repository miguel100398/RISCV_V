//File: riscv_v_execute.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension Execute Stage

module riscv_v_execute 
import riscv_pkg::*, riscv_v_pkg::*;
(
    //Clocks and resets
    input  logic clk,
    input  logic rst
);

//Execution ALUS
riscv_v_exe_alu exe_alu(
    .clk(clk),
    .rst(rst)
);

endmodule: riscv_v_execute