//File: riscv_rf_agt_pkg.sv
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V Register file agent package

package riscv_rf_agt_pkg;


import uvm_pkg::*;
import riscv_pkg::*;
import riscv_v_pkg::*;
import riscv_v_base_pkg::*;

typedef riscv_v_base_bfm_cfg_obj riscv_rf_bfm_cfg_obj;

`include "uvm_macros.svh"
`include "riscv_rf_trk_item.sv"
`include "riscv_rf_wr_seq_item.sv"
`include "riscv_rf_rd_seq_item.sv"
`include "riscv_rf_seq_item"
`include "riscv_rf_base_seq.sv"
`include "riscv_rf_seq.sv"
`include "riscv_rf_drv.sv"
`include "riscv_rf_mon.sv"
`include "riscv_rf_trk.sv"
`include "riscv_rf_cov.sv"

endpackage: riscv_rf_agt_pkg