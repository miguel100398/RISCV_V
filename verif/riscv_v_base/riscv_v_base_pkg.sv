//File: riscv_v_base_pkg.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base package

package riscv_v_base_pkg;

import uvm_pkg::*;
import base_pkg::*;
import riscv_v_pkg::*;

`include "uvm_macros.svh"


typedef base_cfg_obj     riscv_v_base_cfg_obj;
typedef base_bfm_cfg_obj riscv_v_base_bfm_cfg_obj;
typedef base_model       riscv_v_base_model; 
`include "riscv_v_base_seq_item.sv"
`include "riscv_v_base_in_out_seq_item.sv"
`include "riscv_v_base_subscriber_2ports.sv"
`include "riscv_v_base_sqr.sv"
`include "riscv_v_base_seq.sv"
`include "riscv_v_base_drv.sv"
`include "riscv_v_base_mon.sv"
`include "riscv_v_base_scbd.sv"
`include "riscv_v_base_trk.sv"
`include "riscv_v_base_cov.sv"
`include "riscv_v_base_bfm.sv"
`include "riscv_v_base_agt.sv"
`include "riscv_v_base_env.sv"

endpackage: riscv_v_base_pkg