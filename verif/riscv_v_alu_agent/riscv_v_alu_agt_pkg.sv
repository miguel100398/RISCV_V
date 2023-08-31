//File: riscv_v_alu_agt_pkg.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector ALU agent package

package riscv_v_alu_agt_pkg;


import uvm_pkg::*;
import riscv_v_pkg::*;
import riscv_v_base_pkg::*;

`include "uvm_macros.svh"
`include "riscv_v_alu_out_seq_item.sv"
`include "riscv_v_alu_in_seq_item.sv"
`include "riscv_v_logic_alu_in_seq_item.sv"
`include "riscv_v_arithmetic_alu_in_seq_item.sv"
`include "riscv_v_alu_sqr.sv"
`include "riscv_v_logic_alu_seq.sv"
`include "riscv_v_arithmetic_alu_seq.sv"
`include "riscv_v_alu_drv.sv"
`include "riscv_v_alu_mon.sv"
`include "riscv_v_alu_scbd.sv"
`include "riscv_v_alu_trk.sv"
`include "riscv_v_alu_cov.sv"
`include "riscv_v_alu_agt.sv"
`include "riscv_v_alu_env.sv"

endpackage: riscv_v_alu_agt_pkg