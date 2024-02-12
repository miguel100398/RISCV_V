//File: riscv_v_rf_test_pkg.sv
//Author: Miguel Bucio
//Date: 11/02/24
//Description: RISC-V Vector RF test package

package riscv_v_rf_test_pkg;
    import uvm_pkg::*; 
    import riscv_pkg::*;
    import riscv_v_pkg::*;
    import riscv_rf_agt_pkg::*;
    import riscv_v_rf_agt_pkg::*;

    `include "uvm_macros.svh"
    import riscv_v_base_test_pkg::*;
    `include "riscv_v_rf_base_test.sv"
    `include "riscv_v_rf_doa_test.sv"

endpackage: riscv_v_rf_test_pkg