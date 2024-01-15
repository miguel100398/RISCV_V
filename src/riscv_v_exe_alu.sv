//File: riscv_v_exe_alu.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension Execute ALUs

module riscv_v_exe_alu 
import riscv_pkg::*, riscv_v_pkg::*;
(
    //Clocks and resets
    input  logic clk,
    input  logic rst
);

    //Logical ALU
    riscv_v_logic_ALU logic_ALU(
        .is_reduct(),
        .is_and(),
        .is_or(),
        .is_xor(),
        .is_mask(),
        .is_shift(),
        .is_left(),
        .is_arith(),
        .dst_osize_vector(),
        .is_greater_osize_vector(),
        .is_less_osize_vector(),
        .srca(),
        .srcb(),
        .result()
    );

    //Arithmetic ALU
    riscv_v_arithmetic_ALU arithmetic_ALU(
        .is_reduct(),
        .is_add(),
        .is_sub(),
        .is_mul(),
        .is_zero_ext(),
        .is_sign_ext(),
        .is_set_equal(),
        .is_set_nequal(),
        .is_set_less(),
        .is_set_greater(),
        .is_max(),
        .is_min(),
        .is_high(),
        .is_signed(),
        .use_carry(),
        .dst_osize_vector(),
        .src_osize_vector(),
        .is_greater_osize_vector(),
        .is_less_osize_vector(),
        .srca(),
        .srcb(),
        .carry_in(),
        .result(),
        .zf(),
        .of(),
        .cf()
    );

    //Mask  ALU
    riscv_v_mask_ALU mask_ALU(
        .is_mask(),
        .is_and(),
        .is_or(),
        .is_xor(),
        .is_negate_srca(),
        .is_negate_result(),
        .srca(),
        .srcb(),
        .result()
    );
    
    //Permutation ALU
    riscv_v_permutation_ALU permutation_ALU(
        .is_i2v(),
        .is_v2i(),
        .integer_data_in(),
        .vector_data_in(),
        .integer_data_out(),
        .vector_data_out()
    );


endmodule: riscv_v_exe_alu