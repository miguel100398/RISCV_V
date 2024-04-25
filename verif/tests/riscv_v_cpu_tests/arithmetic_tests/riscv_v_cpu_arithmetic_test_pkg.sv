//File: riscv_v_cpu_arithmetic_test_pkg.sv
//Author: Miguel Bucio
//Date: 11/02/24
//Description: RISC-V Vector CPU test package

package riscv_v_cpu_arithmetic_test_pkg;
    import uvm_pkg::*; 
    import riscv_pkg::*;
    import riscv_v_pkg::*;
    import riscv_rf_agt_pkg::*;
    import riscv_v_rf_agt_pkg::*;
    import riscv_v_alu_agt_pkg::*;
    import riscv_v_if_agt_pkg::*;
    import riscv_v_ext_csr_agt_pkg::*;
    import riscv_v_csr_agt_pkg::*;
    import riscv_v_agt_pkg::*;

    `include "uvm_macros.svh"
    import riscv_v_base_test_pkg::*;
    import riscv_v_cpu_base_test_pkg::*;
    `include "riscv_v_cpu_vadd_test.sv"
    `include "riscv_v_cpu_vredsum_test.sv"
    `include "riscv_v_cpu_vadc_test.sv"
    `include "riscv_v_cpu_vsub_test.sv"
    `include "riscv_v_cpu_vsubc_test.sv"
    `include "riscv_v_cpu_vzext_test.sv"
    `include "riscv_v_cpu_vsext_test.sv"
    `include "riscv_v_cpu_vmul_test.sv"
    `include "riscv_v_cpu_vmulh_test.sv"
    `include "riscv_v_cpu_vmulhu_test.sv"
    `include "riscv_v_cpu_vmin_test.sv"
    `include "riscv_v_cpu_vminu_test.sv"
    `include "riscv_v_cpu_vmax_test.sv"
    `include "riscv_v_cpu_vmaxu_test.sv"
    `include "riscv_v_cpu_vredmin_test.sv"

endpackage: riscv_v_cpu_arithmetic_test_pkg 