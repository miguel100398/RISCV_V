//File: riscv_v_logic_alu_if
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector extension logical ALU interface

interface riscv_v_logic_ALU_if
import riscv_v_pkg::*;
(
    input logic clk
);

    //Control signals
    logic              is_reduct;
    logic              is_and;
    //Input sources
    riscv_v_alu_data_t srca;
    riscv_v_alu_data_t srcb;
    //Output result
    riscv_v_wb_data_t  result;

    modport alu(
        input  is_reduct,
        input  is_and,
        input  srca,
        input  srcb,
        output result
    );

    modport system(
        output is_reduct,
        output is_and,
        output srca,
        output srcb,
        input  result
    );

    clocking cb_mon @(posedge clk);
        input  is_reduct;
        input  is_and;
        input  srca;
        input  srcb;
        input  result;
    endclocking

    clocking cb_drv @(posedge clk);
        output is_reduct;
        output is_and;
        output srca;
        output srcb;
    endclocking

endinterface: riscv_v_logic_ALU_if  