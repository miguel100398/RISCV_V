//File: riscv_v_agt_pkg.sv
//Author: Miguel Bucio
//Date: 1/02/24
//Description: RISC-V Instruction Fetch agent package

package riscv_v_agt_pkg;


import uvm_pkg::*;
import riscv_pkg::*;
import riscv_v_pkg::*;
import base_pkg::*;
import riscv_v_base_pkg::*;
import riscv_v_rf_agt_pkg::*;
import riscv_v_csr_agt_pkg::*;

`include "uvm_macros.svh"
`include "riscv_v_bfm_cfg_obj.sv"
`include "riscv_v_trk_item.sv"
`include "riscv_v_in_seq_item.sv"
`include "riscv_v_out_seq_item.sv"
`include "riscv_v_seq_item.sv"
typedef riscv_v_base_sqr#(
    .seq_item_t(riscv_v_seq_item)
) riscv_v_sqr;
`include "riscv_v_seq.sv"
`include "riscv_v_drv.sv"
`include "riscv_v_mon.sv"
`include "riscv_v_trk.sv"
`include "riscv_v_cov.sv"
`include "riscv_v_decode_model.sv"
`include "riscv_v_model.sv"
`include "riscv_v_bfm.sv"
`include "riscv_v_scbd.sv"
`include "riscv_v_agt.sv"
`include "riscv_v_env.sv"

endpackage: riscv_v_agt_pkg