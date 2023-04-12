//File: riscv_v_pkg.sv
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension package

package riscv_v_pkg;

parameter real CLK_FREQ    = 50e6;
parameter real CLK_PERIOD  = 1/CLK_FREQ;

parameter int BYTE_WIDTH = 8;

endpackage: riscv_v_pkg