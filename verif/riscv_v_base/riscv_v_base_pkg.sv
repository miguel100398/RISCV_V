//File: riscv_v_base_pkg.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base package

package riscv_v_base_pkg;

import uvm_pkg::*;
import riscv_v_pkg::*;

`include "uvm_macros.svh"
`include "riscv_v_base_seq_item.sv"
`include "riscv_v_base_sqr.sv"
`include "riscv_v_base_seq.sv"
`include "riscv_v_base_drv.sv"
`include "riscv_v_base_mon.sv"
`include "riscv_v_base_scbd.sv"
`include "riscv_v_base_agt.sv"
`include "riscv_v_base_env.sv"

endpackage: riscv_v_base_pkg