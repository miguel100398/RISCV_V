//File: riscv_v_if 
//Author: Miguel Bucio
//Date: 28/02/2024
//Description RISCV Vector extension interface 

interface riscv_v_if 
import riscv_pkg::*, riscv_v_pkg::*;
(
    input logic clk
);

    logic                   rst;
    logic                   clear_pipe;
    logic                   riscv_stall;
    logic                   riscv_v_stall;
    riscv_instruction_t     instruction_id;
    `ifdef RISCV_V_INST
        riscv_v_opcode_e    opcode_id;
    `endif //RISCV_V_INST
    riscv_data_t            int_rf_rd_data_id;
    riscv_data_t            int_rf_wr_data_wb;
    logic                   int_rf_wr_en_wb;
    riscv_data_t            ext_data_in_exe;
    logic                   ext_wr_vsstatus_id;
    logic                   ext_wr_vtype_id;
    logic                   ext_wr_vl_id;
    logic                   ext_wr_vstart_id;
    logic                   ext_wr_vxrm_id;
    logic                   ext_wr_vxsat_id;
    //Internal signals
    riscv_v_rf_if           v_rf_if(.clk(clk));
    riscv_v_csr_if          v_csr_if(.clk(clk));



    modport riscv_v(
        input  rst,
        input  clear_pipe,
        input  riscv_stall,
        output riscv_v_stall,
        input  instruction_id,
        `ifdef RISCV_V_INST
            input  opcode_id,
        `endif //RISCV_V_INST
        input  int_rf_rd_data_id,
        output int_rf_wr_data_wb,
        output int_rf_wr_en_wb,
        input  ext_data_in_exe,
        input  ext_wr_vsstatus_id,
        input  ext_wr_vtype_id,
        input  ext_wr_vl_id,
        input  ext_wr_vstart_id,
        input  ext_wr_vxrm_id,
        input  ext_wr_vxsat_id
    );

    modport system(
        output  rst,
        output  clear_pipe,
        output  riscv_stall,
        input   riscv_v_stall,
        output  instruction_id,
        `ifdef RISCV_V_INST
            output  opcode_id,
        `endif //RISCV_V_INST
        output  int_rf_rd_data_id,
        input   int_rf_wr_data_wb,
        input   int_rf_wr_en_wb,
        output  ext_data_in_exe,
        output  ext_wr_vsstatus_id,
        output  ext_wr_vtype_id,
        output  ext_wr_vl_id,
        output  ext_wr_vstart_id,
        output  ext_wr_vxrm_id,
        output  ext_wr_vxsat_id
    );

    clocking cb_mon @(posedge clk);
        input  rst;
        input  clear_pipe;
        input  riscv_stall;
        input  riscv_v_stall;
        input  instruction_id;
        `ifdef RISCV_V_INST
            input  opcode_id;
        `endif //RISCV_V_INST
        input  int_rf_rd_data_id;
        input  int_rf_wr_data_wb;
        input  int_rf_wr_en_wb;
        input  ext_data_in_exe;
        input  ext_wr_vsstatus_id;
        input  ext_wr_vtype_id;
        input  ext_wr_vl_id;
        input  ext_wr_vstart_id;
        input  ext_wr_vxrm_id;
        input  ext_wr_vxsat_id;
    endclocking: cb_mon

    clocking cb_drv @(posedge clk);
        output  rst;
        output  clear_pipe;
        output  riscv_stall;
        output  instruction_id;
        `ifdef RISCV_V_INST
            output  opcode_id;
        `endif //RISCV_V_INST
        output  int_rf_rd_data_id;
        output  ext_data_in_exe;
        output  ext_wr_vsstatus_id;
        output  ext_wr_vtype_id;
        output  ext_wr_vl_id;
        output  ext_wr_vstart_id;
        output  ext_wr_vxrm_id;
        output  ext_wr_vxsat_id;
    endclocking: cb_drv

    clocking cb_bfm @(posedge clk);
        output riscv_v_stall;
        output int_rf_wr_data_wb;
        output int_rf_wr_en_wb;
    endclocking: cb_bfm

endinterface: riscv_v_if