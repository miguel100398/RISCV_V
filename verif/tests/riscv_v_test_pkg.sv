//File: riscv_v_test_pkg.sv
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector test package

package riscv_v_test_pkg;
    import riscv_v_pkg::*;
    import uvm_pkg::*;
    import riscv_v_rf_agt_pkg::*;

    `include "uvm_macros.svh"
    `include "riscv_v_rf_doa_test.sv"

endpackage: riscv_v_test_pkg