

set WORKAREA /mnt/d/migue/Documents/Maestria/IDI/RISCV_V_HDL
set INCLUDE_AREA ${WORKAREA}/include
set SRC_AREA ${WORKAREA}/src
set VERILOG_AREA ${WORKAREA}/convert_to_v

yosys echo on
#Read Verilog files
#yosys read_verilog ${VERILOG_AREA}/riscv_v_stage_7EB58.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_stage_1F582_5645A.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_stage_96DA9_C2B4E.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_stage_300B3_9090A.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_stage_969A4_CCEB1.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_stage_63257_B3D37.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_stage_A4EAF_A7C6B.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_stage_C3F9D_39151.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_stage_E6BB0_71521.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_stage_EA379.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_stage_EE621_F935D.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_stage_300C0.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_stage_A8A75.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_stage_C9449.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_ctrl.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_csr_ctrl.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_csr.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_rf_ctrl.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_rf.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_decode.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_memory.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_reduct_src.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_bitwise_and.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_bw_and.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_bitwise_or.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_bw_or.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_bitwise_xor.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_bw_xor.v
#yosys read_verilog ${VERILOG_AREA}/shifter.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_shifter.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_logic_ALU.v
#yosys read_verilog ${VERILOG_AREA}/full_adder.v
#yosys read_verilog ${VERILOG_AREA}/half_adder.v
#yosys read_verilog ${VERILOG_AREA}/ripple_carry_adder.v
#yosys read_verilog ${VERILOG_AREA}/behavioral_adder.v
#yosys read_verilog ${VERILOG_AREA}/adder_nbit.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_adder.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_twos_comp_sel.v
#yosys read_verilog ${VERILOG_AREA}/multiplier_2bit.v
#yosys read_verilog ${VERILOG_AREA}/vedic_mul_unsigned.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_mul.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_extend.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_arithmetic_ALU.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_permutation_ALU.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_exe_alu.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_decode_element.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_bypass.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_swizzle.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v_execute.v
#yosys read_verilog ${VERILOG_AREA}/riscv_v.v
yosys read_verilog ${VERILOG_AREA}/*.v

#Read Liberty files
yosys read_liberty -lib ./lib/sky130_fd_sc_hd__tt_025C_1v80.lib

#Synthesis
yosys synth -top riscv_v_adder

#Get netlist
yosys abc -liberty ./lib/sky130_fd_sc_hd__tt_025C_1v80.lib