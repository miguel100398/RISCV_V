#Set work area
set WORK_AREA D:/migue/Documents/Maestria/IDI/RISCV_V_HDL/Vivado

set DUTS {riscv_v_tb}

set riscv_v_tb_tests {riscv_v_cpu_vadc_test riscv_v_cpu_vadd_test riscv_v_cpu_vmax_test riscv_v_cpu_vmaxu_test riscv_v_cpu_vmin_test riscv_v_cpu_vminu_test riscv_v_cpu_vmseq_test riscv_v_cpu_vmsgt_test riscv_v_cpu_vmsgtu_test riscv_v_cpu_vmsle_test
                      riscv_v_cpu_vmsleu_test riscv_v_cpu_vmslt_test riscv_v_cpu_vmsltu_test riscv_v_cpu_vmsne_test riscv_v_cpu_vmul_test riscv_v_cpu_vmulh_test riscv_v_cpu_vmulhu_test riscv_v_cpu_vredmax_test riscv_v_cpu_vredmaxu_test
                      riscv_v_cpu_vredmin_test riscv_v_cpu_vredminu_test riscv_v_cpu_vredsum_test riscv_v_cpu_vsext_test riscv_v_cpu_vzext_test riscv_v_cpu_vsub_test riscv_v_cpu_vsubc_test
                      riscv_v_cpu_vand_test riscv_v_cpu_vmand_test riscv_v_cpu_vmandn_test riscv_v_cpu_vmnand_test riscv_v_cpu_vor_test riscv_v_cpu_vmor_test riscv_v_cpu_vmnor_test riscv_v_cpu_vmorn_test riscv_v_cpu_vxor_test
                      riscv_v_cpu_vmxor_test riscv_v_cpu_vmxnor_test riscv_v_cpu_vredand_test riscv_v_cpu_vredor_test riscv_v_cpu_vredxor_test riscv_v_cpu_vsll_test riscv_v_cpu_vsrl_test riscv_v_cpu_vsra_test
                      riscv_v_cpu_i2v_test riscv_v_cpu_v2i_test}

set WAVES 0
set CLOSE_WAVES 1

cd $WORK_AREA