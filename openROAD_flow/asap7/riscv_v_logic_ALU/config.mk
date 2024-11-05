export DESIGN_NICKNAME = riscv_v_logic_ALU
export DESIGN_NAME = riscv_v_logic_ALU
export PLATFORM    = asap7

export WRITE_INT_RESULTS = 1
export DELETE_INT_RESULTS = 1

#export RESULTS_DIR = /home/ubuntu/mbucio/models/synthesis_results/asap7/riscv_v_speed

export FP_SIZING =  absolute
export DIE_AREA    = 0.0 0.0 500 500
export CORE_AREA   = 200 200 500 500

# FastRoute options
export MIN_ROUTING_LAYER ?= M1
export MIN_CLK_ROUTING_LAYER ?= M3
export MAX_ROUTING_LAYER ?= M9


export SKIP_ANTENNA_REPAIR_POST_DRT = 1

export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_stage_7EB58.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_stage_1F582_5645A.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_stage_96DA9_C2B4E.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_stage_300B3_9090A.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_stage_969A4_CCEB1.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_stage_63257_B3D37.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_stage_A4EAF_A7C6B.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_stage_C3F9D_39151.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_stage_E6BB0_71521.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_stage_EA379.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_stage_EE621_F935D.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_stage_300C0.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_stage_A8A75.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_stage_C9449.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_ctrl.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_csr_ctrl.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_csr.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_rf_ctrl.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_rf.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_decode.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_memory.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_reduct_src.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_bitwise_and.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_bw_and.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_bitwise_or.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_bw_or.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_bitwise_xor.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_bw_xor.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/shifter.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_shifter.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_logic_ALU.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/full_adder.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/half_adder.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/ripple_carry_adder.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/behavioral_adder.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/adder_nbit.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_adder.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_twos_comp_sel.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/multiplier_2bit.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/vedic_mul_unsigned_2bits.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/vedic_mul_unsigned_4bits.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/vedic_mul_unsigned_8bits.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/vedic_mul_unsigned_16bits.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/vedic_mul_unsigned_32bits.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/vedic_mul_unsigned_64bits.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/vedic_mul_unsigned_128bits.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_mul.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_extend.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_arithmetic_ALU.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_permutation_ALU.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_exe_alu.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_decode_element.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_bypass.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_swizzle.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v_execute.v \
./designs/src/$(DESIGN_NICKNAME)/convert_to_v/riscv_v.v 

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export SYNTH_STRATEGY = SPEED 4

# Adders degrade ibex setup repair
export ADDER_MAP_FILE :=

export PLACE_DENSITY = 0.5
export PLACE_DENSITY_LB_ADDON = 0.5
export TNS_END_PERCENT = 100

export FASTROUTE_TCL = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/fastroute.tcl

export REMOVE_ABC_BUFFERS = 1
