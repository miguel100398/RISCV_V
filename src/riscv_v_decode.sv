//File: riscv_v_decode.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension Decode Stage

module riscv_v_decode 
import riscv_pkg::*, riscv_v_pkg::*;
(
    //Clocks and resets
    input  logic clk,
    input  logic rst
);

//CSR
riscv_v_csr v_csr(
    .clk(clk),
    .rst(rst),
    .vsstatus_data_in(),
    .vsstatus_wr_en(),
    .vsstatus_data_out(),
    .vtype_data_in(),
    .vtype_wr_en(),
    .vtype_data_out(),
    .vl_data_in(),
    .vl_wr_en(),
    .vl_data_out(),
    .vlenb_data_out(),
    .vstart_data_in(),
    .vstart_wr_en(),
    .vstart_data_out(),
    .vxrm_data_in(),
    .vxrm_wr_en(),
    .vxrm_data_out(),
    .vxsat_data_in(),
    .vxsat_wr_en(),
    .vxsat_data_out(),
    .vcsr_data_out()
);

//Vector register file
riscv_v_rf #(
    .RD_ASYNC(RISCV_V_RF_RD_ASYNC),
    .REG_INPUTS(RISCV_V_RF_REG_INPUTS)
)v_rf(
    .clk(clk),
    .wr_addr(),
    .rd_addr_A(),
    .rd_addr_B(),
    .data_in(),
    .wr_en(),
    .data_out_A(),
    .data_out_B()
);

//Mask register File
riscv_v_mask_rf #(
    .RD_ASYNC(RISCV_V_MASK_RF_RD_ASYNC),
    .REG_INPUTS(RISCV_V_MASK_RF_REG_INPUTS)
) v_mask_rf(
    .clk(clk),
    .wr_addr(),
    .rd_addr(),
    .data_in(),
    .wr_en(),
    .data_out()
);




endmodule: riscv_v_decode