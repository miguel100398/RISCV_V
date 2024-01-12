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
    logic                     is_reduct;
    logic                     is_and;
    logic                     is_or;
    logic                     is_xor;
    logic                     is_shift;
    logic                     is_left;
    logic                     is_arith;
    osize_vector_t            dst_osize_vector;
    osize_vector_t            is_greater_osize_vector;
    osize_vector_t            is_less_osize_vector;
    //Input sources
    riscv_v_alu_data_t srca;
    riscv_v_alu_data_t srcb;
    //Output result
    riscv_v_wb_data_t  result;
    `ifdef RISCV_V_INST 
        riscv_v_osize_e   osize;
        riscv_v_opcode_e  opcode;
        riscv_v_src_len_t len;
    `endif //RISCV_V_INST

    modport alu(
        input  is_reduct,
        input  is_and,
        input  is_or,
        input  is_xor,
        input  is_shift,
        input  is_left,
        input  is_arith,
        input  dst_osize_vector,
        input  is_greater_osize_vector,
        input  is_less_osize_vector,
        input  srca,
        input  srcb,
        `ifdef RISCV_V_INST
            input osize,
            input opcode,
            input len,
        `endif //RISCV_V_INST
        output result
    );

    modport system(
        output is_reduct,
        output is_and,
        output is_or,
        output is_xor,
        output is_shift,
        output is_left,
        output is_arith,
        output dst_osize_vector,
        output is_greater_osize_vector,
        output is_less_osize_vector,
        output srca,
        output srcb,
        `ifdef RISCV_V_INST 
            output osize,
            output opcode,
            output len,
        `endif //RISCV_V_INST
        input  result
    );

    clocking cb_mon @(posedge clk);
        input  is_reduct;
        input  is_and;
        input  is_or;
        input  is_xor;
        input  is_shift;
        input  is_left;
        input  is_arith;
        input  dst_osize_vector;
        input  is_greater_osize_vector;
        input  is_less_osize_vector;
        input  srca;
        input  srcb;
        input  result;
        `ifdef RISCV_V_INST 
            input osize;
            input opcode;
            input len;
        `endif //RISCV_V_INST 
    endclocking

    clocking cb_drv @(posedge clk);
        output is_reduct;
        output is_and;
        output is_or;
        output is_xor;
        output is_shift;
        output is_left;
        output is_arith;
        output dst_osize_vector;
        output is_greater_osize_vector;
        output is_less_osize_vector;
        output srca;
        output srcb;
        `ifdef RISCV_V_INST 
            output osize;
            output opcode;
            output len;
        `endif //RISCV_V_INST 
    endclocking

endinterface: riscv_v_logic_ALU_if  