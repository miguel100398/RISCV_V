#!/bin/bash
printf "Starting script\n\n"

RISCV_V_INST_ON=$1

WORKAREA="/mnt/d/migue/Documents/Maestria/IDI/RISCV_V_HDL"
INCLUDE_AREA="${WORKAREA}/include"
SRC_AREA="${WORKAREA}/src"
if [ $RISCV_V_INST_ON == "true" ]
then
    OUTPUT_DIR="${WORKAREA}/convert_to_v_inst/"
else
    OUTPUT_DIR="${WORKAREA}/convert_to_v/"
fi
#Add Defines
DEFINES=""
if [ $RISCV_V_INST_ON == "true" ]
then
    DEFINES="$DEFINES -D=RISCV_V_INST"
fi
DEFINES="$DEFINES -D=VIVADO"
DEFINES="$DEFINES -D=RISCV_USE_WORD"
DEFINES="$DEFINES -D=RISCV_USE_DWORD"
DEFINES="$DEFINES -D=RISCV_USE_QWORD"
DEFINES="$DEFINES -D=RISCV_USE_DQWORD"
#Add packages
PACKAGES=""
PACKAGES="$PACKAGES ${INCLUDE_AREA}/riscv_v_macros.svh"
PACKAGES="$PACKAGES ${INCLUDE_AREA}/riscv_pkg.sv"
PACKAGES="$PACKAGES ${INCLUDE_AREA}/riscv_v_pkg.sv"
#Add filess
FILES=""
FILES="$FILES ${SRC_AREA}/riscv_v_stage.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_ctrl.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_csr_ctrl.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_csr.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_rf_ctrl.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_rf.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_decode.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_memory.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_reduct_src.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_bitwise_and.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_bw_and.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_bitwise_or.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_bw_or.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_bitwise_xor.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_bw_xor.sv"
FILES="$FILES ${SRC_AREA}/shifter.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_shifter.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_logic_ALU.sv"
FILES="$FILES ${SRC_AREA}/full_adder.sv"
FILES="$FILES ${SRC_AREA}/half_adder.sv"
FILES="$FILES ${SRC_AREA}/ripple_carry_adder.sv"
FILES="$FILES ${SRC_AREA}/behavioral_adder.sv"
FILES="$FILES ${SRC_AREA}/adder_nbit.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_adder.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_twos_comp_sel.sv"
FILES="$FILES ${SRC_AREA}/multiplier_2bit.sv"
FILES="$FILES ${SRC_AREA}/vedic_mul_unsigned.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_mul.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_extend.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_arithmetic_ALU.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_permutation_ALU.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_exe_alu.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_decode_element.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_bypass.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_swizzle.sv"
FILES="$FILES ${SRC_AREA}/riscv_v_execute.sv"
FILES="$FILES ${SRC_AREA}/riscv_v.sv"

printf "Variables set\n\n"
printf "WORKAREA: $WORKAREA \n"
printf "INCLUDE_AREA: $INCLUDE_AREA \n"
printf "OUTPUT_DIR: $OUTPUT_DIR \n"
printf "SRC_AREA: $SRC_AREA \n"
printf "DEFINES: $DEFINES \n"
printf "PACKAGES: $PACKAGES \n"
printf "FILES: $FILES \n"
printf "\n\n"

./bin/sv2v $DEFINES $PACKAGES $FILES -w=$OUTPUT_DIR