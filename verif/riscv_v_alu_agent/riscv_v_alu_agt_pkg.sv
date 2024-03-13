//File: riscv_v_alu_agt_pkg.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector ALU agent package

package riscv_v_alu_agt_pkg;


import uvm_pkg::*;
import riscv_pkg::*;
import riscv_v_pkg::*;
//import riscv_v_rf_agt_pkg::*;
import riscv_v_base_pkg::*;

typedef string riscv_v_alu_interfaces_names_t[riscv_v_alu_e];

typedef riscv_v_base_bfm_cfg_obj riscv_v_alu_bfm_cfg_obj;

`include "uvm_macros.svh"
`include "riscv_v_macros.svh"
`include "riscv_v_alu_out_seq_item.sv"
`include "riscv_v_mask_alu_out_seq_item.sv"
`include "riscv_v_permutation_alu_out_seq_item.sv"
`include "riscv_v_alu_in_seq_item.sv"
`include "riscv_v_logic_alu_in_seq_item.sv"
`include "riscv_v_arithmetic_alu_in_seq_item.sv"
`include "riscv_v_mask_alu_in_seq_item.sv"
`include "riscv_v_permutation_alu_in_seq_item.sv"
typedef riscv_v_base_in_out_seq_item#(
    .in_seq_item_t(riscv_v_alu_in_seq_item),
    .out_seq_item_t(riscv_v_alu_out_seq_item)
) riscv_v_alu_seq_item;
typedef riscv_v_base_sqr#(
    .seq_item_t(riscv_v_alu_seq_item)
) riscv_v_alu_sqr;
`include "riscv_v_logic_alu_seq.sv"
`include "riscv_v_arithmetic_alu_seq.sv"
`include "riscv_v_mask_alu_seq.sv"
`include "riscv_v_permutation_alu_seq.sv"
`include "riscv_v_alu_seq.sv"
`include "riscv_v_alu_drv.sv"
`include "riscv_v_alu_mon.sv"
`include "riscv_v_alu_model.sv"
//`include "riscv_v_arithmetic_ops.sv"
`include "riscv_v_logic_ops.sv"
`include "riscv_v_mask_ops.sv"
`include "riscv_v_permutation_ops.sv"
`include "riscv_v_alu_scbd.sv"
`include "riscv_v_alu_trk.sv"
`include "riscv_v_alu_cov.sv"
`include "riscv_v_alu_bfm.sv"
`include "riscv_v_alu_agt.sv"
`include "riscv_v_alu_env.sv"

endpackage: riscv_v_alu_agt_pkg