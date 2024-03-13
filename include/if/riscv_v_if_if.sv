//File: riscv_v_if_if
//Author: Miguel Bucio
//Date: 11/02/24
//Description: RISC-V Vector extension Intruction Fetch Interface
`timescale 1ns/1ps

interface riscv_v_if_if 
import riscv_pkg::*, riscv_v_pkg::*;
(
    input logic clk 
);

    logic               rst;
    riscv_instruction_t instruction;
    `ifdef RISCV_V_INST
        riscv_v_opcode_e opcode;
    `endif //RISCV_V_INST

    modport instruction_fetch(
        input  rst,
        `ifdef RISCV_V_INST
            output opcode,
        `endif //RISCV_V_INST
        output instruction
    );

    modport system(
        output rst,
        `ifdef RISCV_V_INST
            input opcode,
        `endif //RISCV_V_INST
        input  instruction
    );

    clocking cb_mon @(posedge clk);
        input rst;
        `ifdef RISCV_V_INST
            input opcode;
        `endif //RISCV_V_INST
        input instruction;
    endclocking: cb_mon 

    clocking cb_drv @(posedge clk);
        output rst;
    endclocking: cb_drv

    clocking cb_bfm @(posedge clk);
        output instruction;
        `ifdef RISCV_V_INST
            output opcode;
        `endif //RISCV_V_INST
    endclocking: cb_bfm

endinterface: riscv_v_if_if 