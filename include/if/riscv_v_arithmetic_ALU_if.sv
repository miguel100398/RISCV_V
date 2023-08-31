//File: riscv_v_arithmetic_alu_if
//Author: Miguel Bucio
//Date: 30/08/23
//Description: RISC-V Vector extension Arithmetic ALU interface

interface riscv_v_arithmetic_ALU_if
import riscv_v_pkg::*;
(
    input logic clk
);

    //Control signals
    logic                     is_reduct;
    logic                     is_add;
    logic                     is_sub;
    logic                     is_zero_ext;
    logic                     is_sign_ext;
    logic                     is_max;
    logic                     is_min;
    logic                     is_signed;
    logic                     use_carry;
    osize_vector_t            osize_vector;
    osize_vector_t            is_greater_osize_vector;
    osize_vector_t            is_less_osize_vector;
    //Input sources
    riscv_v_alu_data_t srca;
    riscv_v_alu_data_t srcb;
    riscv_v_carry_in_t carry_in;
    //Output result
    riscv_v_wb_data_t  result;
    riscv_v_zf_t       zf;
    riscv_v_of_t       of;
    riscv_v_cf_t       cf;
    `ifdef RISCV_V_INST 
        riscv_v_osize_e   osize;
        riscv_v_opcode_e  opcode;
        riscv_v_src_len_t len;
    `endif //RISCV_V_INST

    modport alu(
        input  is_reduct,
        input  is_add,
        input  is_sub,
        input  is_zero_ext,
        input  is_sign_ext,
        input  is_max,
        input  is_min,
        input  is_signed,
        input  use_carry,
        input  osize_vector,
        input  is_greater_osize_vector,
        input  is_less_osize_vector,
        input  srca,
        input  srcb,
        input  carry_in,
        `ifdef RISCV_V_INST
            input osize,
            input opcode,
            input len,
        `endif //RISCV_V_INST
        output result,
        output zf,
        output of,
        output cf
    );

    modport system(
        output is_reduct,
        output is_add,
        output is_sub,
        output is_zero_ext,
        output is_sign_ext,
        output is_max,
        output is_min,
        output is_signed,
        output use_carry,
        output osize_vector,
        output is_greater_osize_vector,
        output is_less_osize_vector,
        output srca,
        output srcb,
        output carry_in,
        `ifdef RISCV_V_INST 
            output osize,
            output opcode,
            output len,
        `endif //RISCV_V_INST
        input  result,
        input  zf,
        input  of,
        input  cf
    );

    clocking cb_mon @(posedge clk);
        input  is_reduct;
        input  is_add;
        input  is_sub;
        input  is_zero_ext;
        input  is_sign_ext;
        input  is_max;
        input  is_min;
        input  is_signed;
        input  use_carry;
        input  osize_vector;
        input  is_greater_osize_vector;
        input  is_less_osize_vector;
        input  srca;
        input  srcb;
        input  carry_in;
        input  result;
        input  zf;
        input  of;
        input  cf;
        `ifdef RISCV_V_INST 
            input osize;
            input opcode;
            input len;
        `endif //RISCV_V_INST 
    endclocking

    clocking cb_drv @(posedge clk);
        output is_reduct;
        output is_add;
        output is_sub;
        output is_zero_ext;
        output is_sign_ext;
        output is_max;
        output is_min;
        output is_signed;
        output use_carry;
        output osize_vector;
        output is_greater_osize_vector;
        output is_less_osize_vector;
        output srca;
        output srcb;
        output carry_in;
        `ifdef RISCV_V_INST 
            output osize;
            output opcode;
            output len;
        `endif //RISCV_V_INST 
    endclocking

endinterface: riscv_v_arithmetic_ALU_if  