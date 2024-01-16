//File: riscv_v_execute.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension Execute Stage

module riscv_v_execute 
import riscv_pkg::*, riscv_v_pkg::*;
(
    //Clocks and resets
    input  logic                       clk,
    input  logic                       rst,
    //Decode interface
    input  riscv_data_t                int_data_exe,
    output riscv_data_t                int_data_result_exe,
    input  riscv_v_data_t              srca_exe,
    input  riscv_v_data_t              srcb_exe,
    input  riscv_v_mask_t              mask_exe,
    output riscv_v_wb_data_t           alu_result_exe,
    output riscv_v_mask_t              mask_result_exe,
    //CSR interface
    riscv_v_vtype_t                    vtype,
    riscv_v_vl_t                       vl,
    riscv_v_vstart_t                   vstart   
);

//Execution ALUS
riscv_v_exe_alu exe_alu(
    .clk(clk),
    .rst(rst)
);

endmodule: riscv_v_execute