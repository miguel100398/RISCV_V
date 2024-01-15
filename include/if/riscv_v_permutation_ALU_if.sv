//File: riscv_v_permutation_alu_if
//Author: Miguel Bucio
//Date: 15/01/244
//Description: RISC-V Vector extension Permutation ALU interface

interface riscv_v_permutation_ALU_if
import riscv_v_pkg::*, riscv_pkg::*;
(
    input  logic clk
);

    //Control signals
    logic               is_v2i;
    logic               is_i2v;
    riscv_data_t        integer_data_in;
    riscv_v_alu_data_t  vector_data_in;
    riscv_data_t        integer_data_out;
    riscv_v_wb_data_t   vector_data_out;
    `ifdef RISCV_V_INST 
        riscv_v_opcode_e opcode;
    `endif //RISCV_V_INST 

    modport alu(
        input  is_v2i,
        input  is_i2v,
        input  integer_data_in,
        input  vector_data_in,
        `ifdef RISCV_V_INST 
            input opcode,
        `endif //RISCV_V_INST
        output integer_data_out,
        output vector_data_out
    );

    modport system(
        output is_v2i,
        output is_i2v,
        output integer_data_in,
        output vector_data_in,
        `ifdef RISCV_V_INST 
            output opcode,
        `endif //RISCV_V_INST
        input  integer_data_out,
        input  vector_data_out
    );

    clocking cb_mon @(posedge clk);
        input  is_v2i;
        input  is_i2v;
        input  integer_data_in;
        input  vector_data_in;
        `ifdef RISCV_V_INST 
            input opcode;
        `endif //RISCV_V_INST
        input  integer_data_out;
        input  vector_data_out;
    endclocking

    clocking cb_drv @(posedge clk);
        output is_v2i;
        output is_i2v;
        output integer_data_in;
        output vector_data_in;
        `ifdef  RISCV_V_INST 
            output opcode;
        `endif //RISCV_V_INST
    endclocking


endinterface: riscv_v_permutation_ALU_if