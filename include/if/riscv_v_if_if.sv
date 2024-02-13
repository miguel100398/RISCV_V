//File: riscv_v_if_if
//Author: Miguel Bucio
//Date: 11/02/24
//Description: RISC-V Vector extension Intruction Fetch Interface

interface riscv_v_if_if 
import riscv_pkg::*, riscv_v_pkg::*;
(
    input logic clk 
);

    logic               rst;
    riscv_instruction_t instruction;

    modport instruction_fetch(
        input  rst,
        output instruction
    );

    modport system(
        output rst,
        input  instruction
    );

    clocking cb_mon @(posedge clk);
        input rst;
        input instruction;
    endclocking: cb_mon 

    clocking cb_drv @(posedge clk);
        output rst;
    endclocking: cb_drv

    clocking cb_bfm @(posedge clk);
        output instruction;
    endclocking: cb_bfm

endinterface: riscv_v_if_if 