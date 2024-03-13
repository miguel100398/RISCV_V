//File: riscv_v_mask_alu_if
//Author: Miguel Bucio
//Date: 15/01/244
//Description: RISC-V Vector extension Mask ALU interface
`timescale 1ns/1ps

interface riscv_v_mask_ALU_if 
import riscv_v_pkg::*;
(
    input  logic clk
);

    //Control signals
    logic               is_mask;
    logic               is_and;
    logic               is_or;
    logic               is_xor;
    logic               is_negate_srca;
    logic               is_negate_result;
    riscv_v_mask_t      srca;
    riscv_v_mask_t      srcb;
    riscv_v_mask_t      result;
    `ifdef RISCV_V_INST 
        riscv_v_opcode_e opcode;
    `endif //RISCV_V_INST

    modport alu(
        input  is_mask,
        input  is_and,
        input  is_or,
        input  is_xor,
        input  is_negate_srca,
        input  is_negate_result,
        input  srca,
        input  srcb,
        `ifdef RISCV_V_INST 
            input opcode,
        `endif //RISCV_V_INST
        output result
    );

    modport system(
        output is_mask,
        output is_and,
        output is_or,
        output is_xor,
        output is_negate_srca,
        output is_negate_result,
        output srca,
        output srcb,
        `ifdef RISCV_V_INST
            output opcode,
        `endif //RISCV_V_INST
        input result
    );

    clocking cb_mon @(posedge clk);
        input is_mask;
        input is_and;
        input is_or;
        input is_xor;
        input is_negate_srca;
        input is_negate_result;
        input srca;
        input srcb;
        `ifdef RISCV_V_INST 
            input opcode;
        `endif //RISCV_V_INST
        input result;
    endclocking

    clocking cb_drv @(posedge clk);
        output is_mask;
        output is_and;
        output is_or;
        output is_xor;
        output is_negate_srca;
        output is_negate_result;
        output srca;
        output srcb;
        `ifdef RISCV_V_INST 
            output opcode;
        `endif 
    endclocking 

    clocking cb_bfm @(posedge clk);
        output result;
    endclocking

endinterface: riscv_v_mask_ALU_if