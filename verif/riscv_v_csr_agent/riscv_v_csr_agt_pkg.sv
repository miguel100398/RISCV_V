//File: riscv_v_csr_agt_pkg.sv
//Author: Miguel Bucio
//Date: 1/02/24
//Description: RISC-V Instruction Fetch agent package

package riscv_v_csr_agt_pkg;


import uvm_pkg::*;
import riscv_pkg::*;
import riscv_v_pkg::*;
import base_pkg::*;
import riscv_v_base_pkg::*;

`include "uvm_macros.svh"
`include "riscv_v_csr_bfm_cfg_obj.sv"
`include "riscv_v_csr_in_seq_item.sv"
`include "riscv_v_csr_out_seq_item.sv"
`include "riscv_v_csr_seq_item.sv"
`include "riscv_v_csr_trk_item.sv"
typedef riscv_v_base_sqr#(
    .seq_item_t(riscv_v_csr_seq_item)
) riscv_v_csr_sqr;
`include "riscv_v_csr_seq.sv"
`include "riscv_v_csr_drv.sv"
`include "riscv_v_csr_mon.sv"
`include "riscv_v_csr_cov.sv"
`include "riscv_v_csr_model.sv"
`include "riscv_v_csr_scbd.sv"
`include "riscv_v_csr_bfm.sv"
`include "riscv_v_csr_trk.sv"
`include "riscv_v_csr_agt.sv"
`include "riscv_v_csr_env.sv"

endpackage: riscv_v_csr_agt_pkg