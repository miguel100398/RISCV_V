//File: riscv_v_if_agt_pkg.sv
//Author: Miguel Bucio
//Date: 1/02/24
//Description: RISC-V Instruction Fetch agent package

package riscv_v_if_agt_pkg;


import uvm_pkg::*;
import riscv_pkg::*;
import riscv_v_pkg::*;
import base_pkg::*;
import riscv_v_base_pkg::*;


`include "uvm_macros.svh"
`include "riscv_instr.sv"
`include "riscv_v_instr.sv"
`include "riscv_v_if_bfm_cfg_obj.sv"
`include "riscv_v_if_trk_item.sv"
`include "riscv_v_if_in_seq_item.sv"
`include "riscv_v_if_out_seq_item.sv"
`include "riscv_v_if_seq_item.sv"
typedef riscv_v_base_sqr#(
    .seq_item_t(riscv_v_if_seq_item)
) riscv_v_if_sqr;
`include "riscv_v_if_seq.sv"
`include "riscv_v_if_drv.sv"
`include "riscv_v_if_mon.sv"
`include "riscv_v_if_trk.sv"
`include "riscv_v_if_cov.sv"
`include "riscv_v_if_model.sv"
`include "riscv_v_if_bfm.sv"
`include "riscv_v_if_scbd.sv"
`include "riscv_v_if_agt.sv"
`include "riscv_v_if_env.sv"

endpackage: riscv_v_if_agt_pkg