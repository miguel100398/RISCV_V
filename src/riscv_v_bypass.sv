//File: riscv_v_bypass.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector Bypass unit

module riscv_v_bypass
import riscv_pkg::*, riscv_v_pkg::*;
`include "riscv_v_macros.svh"
(
    input  riscv_data_t         integer_data,
    input  riscv_v_data_t       srca,
    input  riscv_v_data_t       srcb,
    input  logic                is_scalar_int,
    output riscv_v_data_t       srca_byp,
    output riscv_v_data_t       srcb_byp
);

    assign srca_byp = (is_scalar_int) ? `RISCV_V_SX(integer_data, RISCV_V_DATA_WIDTH) : srca;
    assign srcb_byp = srcb;

endmodule: riscv_v_bypass
