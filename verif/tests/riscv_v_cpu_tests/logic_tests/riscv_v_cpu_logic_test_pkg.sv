//File: riscv_v_cpu_logic_test_pkg.sv
//Author: Miguel Bucio
//Date: 11/02/24
//Description: RISC-V Vector CPU test package

package riscv_v_cpu_logic_test_pkg;
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
    `include "riscv_v_cpu_vand_test.sv"
    `include "riscv_v_cpu_vor_test.sv"
    `include "riscv_v_cpu_vxor_test.sv"
    `include "riscv_v_cpu_vredand_test.sv"
    `include "riscv_v_cpu_vredor_test.sv"
    `include "riscv_v_cpu_vredxor_test.sv"
    `include "riscv_v_cpu_vsll_test.sv"
    `include "riscv_v_cpu_vsrl_test.sv"
    `include "riscv_v_cpu_vsra_test.sv"
    `include "riscv_v_cpu_vmand_test.sv"
    `include "riscv_v_cpu_vmnand_test.sv"
    `include "riscv_v_cpu_vmandn_test.sv"
    `include "riscv_v_cpu_vmor_test.sv"
    `include "riscv_v_cpu_vmnor_test.sv"
    `include "riscv_v_cpu_vmorn_test.sv"
    `include "riscv_v_cpu_vmxor_test.sv"
    `include "riscv_v_cpu_vmxnor_test.sv"
    

endpackage: riscv_v_cpu_logic_test_pkg 