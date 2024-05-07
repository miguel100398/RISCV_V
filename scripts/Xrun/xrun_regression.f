-xmlibdirpath ${WORKAREA}/xrun
-uvm

-warn_multiple_driver
-access +rw

-define XCELIUM
-define RISCV_V_INST
-define RISCV_V_USE_WORD
-define RISCV_V_USE_DWORD
-define RISCV_V_USE_QWORD
-define RISCV_V_USE_DQWORD

-incdir ${WORKAREA}/include
-incdir ${WORKAREA}/verif/base
-incdir ${WORKAREA}/verif/riscv_v_base
-incdir ${WORKAREA}/verif/riscv_rf_agent
-incdir ${WORKAREA}/verif/riscv_v_alu_agent
-incdir ${WORKAREA}/verif/riscv_v_csr_agent
-incdir ${WORKAREA}/verif/riscv_v_ext_csr_agent
-incdir ${WORKAREA}/verif/riscv_v_if_agent
-incdir ${WORKAREA}/verif/riscv_v_rf_agent
-incdir ${WORKAREA}/verif/riscv_v_agent
-incdir ${WORKAREA}/verif/tests/base_tests
-incdir ${WORKAREA}/verif/tests/riscv_v_rf_tests
-incdir ${WORKAREA}/verif/tests/riscv_v_alu_tests/base_tests
-incdir ${WORKAREA}/verif/tests/riscv_v_alu_tests/arithmetic_tests
-incdir ${WORKAREA}/verif/tests/riscv_v_alu_tests/logic_tests
-incdir ${WORKAREA}/verif/tests/riscv_v_alu_tests/mask_tests
-incdir ${WORKAREA}/verif/tests/riscv_v_alu_tests/permutation_tests
-incdir ${WORKAREA}/verif/tests/riscv_v_cpu_tests/base_tests
-incdir ${WORKAREA}/verif/tests/riscv_v_cpu_tests/arithmetic_tests
-incdir ${WORKAREA}/verif/tests/riscv_v_cpu_tests/logic_tests
-incdir ${WORKAREA}/verif/tests/riscv_v_cpu_tests/permutation_tests
-incdir ${WORKAREA}/verif/tests/riscv_v_cpu_tests/

${WORKAREA}/include/riscv_pkg.sv
${WORKAREA}/include/riscv_v_macros.svh
${WORKAREA}/include/riscv_v_pkg.sv
${WORKAREA}/include/if/*.sv
${WORKAREA}/src/*.sv
${WORKAREA}/src/riscv/*.sv
${WORKAREA}/verif/base/base_pkg.sv
${WORKAREA}/verif/riscv_v_base/riscv_v_base_pkg.sv
${WORKAREA}/verif/riscv_rf_agent/riscv_rf_agt_pkg.sv
${WORKAREA}/verif/riscv_v_alu_agent/riscv_v_alu_agt_pkg.sv
${WORKAREA}/verif/riscv_v_csr_agent/riscv_v_csr_agt_pkg.sv
${WORKAREA}/verif/riscv_v_ext_csr_agent/riscv_v_ext_csr_agt_pkg.sv
${WORKAREA}/verif/riscv_v_if_agent/riscv_v_if_agt_pkg.sv
${WORKAREA}/verif/riscv_v_rf_agent/riscv_v_rf_agt_pkg.sv
${WORKAREA}/verif/riscv_v_agent/riscv_v_agt_pkg.sv
${WORKAREA}/verif/tests/base_tests/riscv_v_base_test_pkg.sv
${WORKAREA}/verif/tests/riscv_v_rf_tests/riscv_v_rf_test_pkg.sv
${WORKAREA}/verif/tests/riscv_v_alu_tests/base_tests/riscv_v_base_alu_test_pkg.sv
${WORKAREA}/verif/tests/riscv_v_alu_tests/arithmetic_tests/riscv_v_arithmetic_alu_test_pkg.sv
${WORKAREA}/verif/tests/riscv_v_alu_tests/logic_tests/riscv_v_logic_alu_test_pkg.sv
${WORKAREA}/verif/tests/riscv_v_alu_tests/mask_tests/riscv_v_mask_alu_test_pkg.sv
${WORKAREA}/verif/tests/riscv_v_alu_tests/permutation_tests/riscv_v_permutation_alu_test_pkg.sv
${WORKAREA}/verif/tests/riscv_v_alu_tests/riscv_v_alu_test_pkg.sv
${WORKAREA}/verif/tests/riscv_v_cpu_tests/base_tests/riscv_v_cpu_base_test_pkg.sv
${WORKAREA}/verif/tests/riscv_v_cpu_tests/arithmetic_tests/riscv_v_cpu_arithmetic_test_pkg.sv
${WORKAREA}/verif/tests/riscv_v_cpu_tests/logic_tests/riscv_v_cpu_logic_test_pkg.sv
${WORKAREA}/verif/tests/riscv_v_cpu_tests/permutation_tests/riscv_v_cpu_permutation_test_pkg.sv
${WORKAREA}/verif/tests/riscv_v_cpu_tests/riscv_v_cpu_test_pkg.sv
${WORKAREA}/verif/tests/riscv_v_test_pkg.sv
${WORKAREA}/verif/tbench/*.sv