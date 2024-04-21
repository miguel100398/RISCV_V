//File: riscv_v_shuffler.sv
//Author: Miguel Bucio
//Date: 17/01/24
//Description: RISC-V Vector extension Shuffler
`timescale 1ns/1ps

module riscv_v_shuffler
import riscv_pkg::*, riscv_v_pkg::*;
(
    input  riscv_v_alu_data_t            src,
    input  riscv_v_shuffler_sel_vector_t sel,
    output riscv_v_alu_data_t            result
);

//Shuffle Data
/*
generate
    for (genvar byte_idx = 0; byte_idx < RISCV_V_NUM_ELEMENTS_REG; byte_idx++) begin : gen_shuffler
        assign result.data.Byte[byte_idx] = src.data.Byte[sel[byte_idx]];
        assign result.merge[byte_idx]     = src.merge[sel[byte_idx]];
        assign result.valid[byte_idx]     = src.valid[sel[byte_idx]];
    end 
endgenerate
*/
assign result = src;

endmodule: riscv_v_shuffler