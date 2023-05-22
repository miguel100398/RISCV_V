//File: riscv_v_rf_agt_pkg.sv
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector Register file agent package

package riscv_v_rf_agt_pkg;


import uvm_pkg::*;
import riscv_v_pkg::*;
import riscv_v_base_pkg::*;

`include "uvm_macros.svh"
`include "riscv_v_rf_seq_item.sv"
`include "riscv_v_rf_wr_seq_item.sv"
`include "riscv_v_rf_rd_seq_item.sv"
`include "riscv_v_rf_sqr.sv"
`include "riscv_v_rf_base_seq.sv"
`include "riscv_v_rf_seq.sv"
`include "riscv_v_rf_rand_seq.sv"
`include "riscv_v_rf_rand_rd_seq.sv"
`include "riscv_v_rf_rand_wr_seq.sv"
`include "riscv_v_rf_rand_raw_seq.sv"
`include "riscv_v_rf_drv.sv"
`include "riscv_v_rf_mon.sv"
`include "riscv_v_rf_scbd.sv"
`include "riscv_v_rf_agt.sv"
`include "riscv_v_rf_env.sv"

endpackage: riscv_v_rf_agt_pkg