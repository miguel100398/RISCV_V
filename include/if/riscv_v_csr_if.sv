//File: riscv_v_csr_if
//Author: Miguel Bucio
//Date: 29/02/2024
//Description: RISCV V CSR Interface

interface riscv_v_csr_if
import riscv_pkg::*, riscv_v_pkg::*;
(
    input logic clk
);

    logic               rst;
    riscv_v_vsstatus_t  vsstatus_data_in;
    logic               vsstatus_wr_en;
    riscv_v_vsstatus_t  vsstatus_data_out;
    riscv_v_vtype_t     vtype_data_in;
    logic               vtype_wr_en;
    riscv_v_vtype_t     vtype_data_out;
    riscv_v_vl_t        vl_data_in;
    logic               vl_wr_en;
    riscv_v_vl_t        vl_data_out;
    riscv_v_vlenb_t     vlenb_data_out;
    riscv_v_vstart_t    vstart_data_in;
    logic               vstart_wr_en;
    riscv_v_vstart_t    vstart_data_out;
    riscv_v_vxrm_t      vxrm_data_in;
    logic               vxrm_wr_en;
    riscv_v_vxrm_t      vxrm_data_out;
    riscv_v_vxsat_t     vxsat_data_in;
    logic               vxsat_wr_en;
    riscv_v_vxsat_t     vxsat_data_out;
    riscv_v_vcsr_t      vcsr_data_out;

    modport riscv_v_csr(
        input  rst,
        input  vsstatus_data_in,
        input  vsstatus_wr_en,
        output vsstatus_data_out,
        input  vtype_data_in,
        input  vtype_wr_en,
        output vtype_data_out,
        input  vl_data_in,
        input  vl_wr_en,
        output vl_data_out,
        output vlenb_data_out,
        input  vstart_data_in,
        input  vstart_wr_en,
        output vstart_data_out,
        input  vxrm_data_in,
        input  vxrm_wr_en,
        output vxrm_data_out,
        input  vxsat_data_in,
        input  vxsat_wr_en,
        output vxsat_data_out,
        output vcsr_data_out
    );

    modport system(
        output  rst,
        output  vsstatus_data_in,
        output  vsstatus_wr_en,
        input   vsstatus_data_out,
        output  vtype_data_in,
        output  vtype_wr_en,
        input   vtype_data_out,
        output  vl_data_in,
        output  vl_wr_en,
        input   vl_data_out,
        input   vlenb_data_out,
        output  vstart_data_in,
        output  vstart_wr_en,
        input   vstart_data_out,
        output  vxrm_data_in,
        output  vxrm_wr_en,
        input   vxrm_data_out,
        output  vxsat_data_in,
        output  vxsat_wr_en,
        input   vxsat_data_out,
        input   vcsr_data_out
    );

    clocking cb_mon @(posedge clk);
        input   rst;
        input   vsstatus_data_in;
        input   vsstatus_wr_en;
        input   vsstatus_data_out;
        input   vtype_data_in;
        input   vtype_wr_en;
        input   vtype_data_out;
        input   vl_data_in;
        input   vl_wr_en;
        input   vl_data_out;
        input   vlenb_data_out;
        input   vstart_data_in;
        input   vstart_wr_en;
        input   vstart_data_out;
        input   vxrm_data_in;
        input   vxrm_wr_en;
        input   vxrm_data_out;
        input   vxsat_data_in;
        input   vxsat_wr_en;
        input   vxsat_data_out;
        input   vcsr_data_out;
    endclocking: cb_mon

    clocking cb_drv @(posedge clk);
        output  rst;
        output  vsstatus_data_in;
        output  vsstatus_wr_en;
        output  vtype_data_in;
        output  vtype_wr_en;
        output  vl_data_in;
        output  vl_wr_en;
        output  vstart_data_in;
        output  vstart_wr_en;
        output  vxrm_data_in;
        output  vxrm_wr_en;
        output  vxsat_data_in;
        output  vxsat_wr_en;
    endclocking: cb_drv

    clocking cb_bfm @(posedge clk);
        output vsstatus_data_out;
        output vtype_data_out;
        output vl_data_out;
        output vlenb_data_out;
        output vstart_data_out;
        output vxrm_data_out;
        output vxsat_data_out;
        output vcsr_data_out;
    endclocking: cb_bfm

endinterface: riscv_v_csr_if

