//File: riscv_v_ext_csr_if
//Author: Miguel Bucio
//Date: 13/02/24
//Description: RISC-V Vector extension External CSR interface
`timescale 1ns/1ps

interface riscv_v_ext_csr_if 
import riscv_pkg::*, riscv_v_pkg::*;
(
    input logic clk 
);

    logic           rst;
    riscv_data_t    ext_csr_data;
    logic           ext_wr_vsstatus;
    logic           ext_wr_vtype;
    logic           ext_wr_vl;
    logic           ext_wr_vstart;
    logic           ext_wr_vxrm;
    logic           ext_wr_vxsat;

    modport ext_csr(
        input  rst,
        output ext_csr_data,
        output ext_wr_vsstatus,
        output ext_wr_vtype,
        output ext_wr_vl,
        output ext_wr_vstart,
        output ext_wr_vxrm,
        output ext_wr_vxsat
    );

    modport system(
        output rst,
        input  ext_csr_data,
        input  ext_wr_vsstatus,
        input  ext_wr_vtype,
        input  ext_wr_vl,
        input  ext_wr_vstart,
        input  ext_wr_vxrm,
        input  ext_wr_vxsat
    );

    clocking cb_mon @(posedge clk);
        input rst;
        input ext_csr_data;
        input ext_wr_vsstatus;
        input ext_wr_vtype;
        input ext_wr_vl;
        input ext_wr_vstart;
        input ext_wr_vxrm;
        input ext_wr_vxsat;
    endclocking: cb_mon 

    clocking cb_drv @(posedge clk);
        output rst;
    endclocking: cb_drv

    clocking cb_bfm @(posedge clk);
        output ext_csr_data;
        output ext_wr_vsstatus;
        output ext_wr_vtype;
        output ext_wr_vl;
        output ext_wr_vstart;
        output ext_wr_vxrm;
        output ext_wr_vxsat;
    endclocking: cb_bfm

endinterface: riscv_v_ext_csr_if 