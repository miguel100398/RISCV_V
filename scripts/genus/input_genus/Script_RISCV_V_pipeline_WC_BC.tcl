# ITESO
# Miguel Bucio
# File: Script_RISCV_V_pipeline_WC_BC.tcl based on Script_Adders_mmmc.tcl
#### Template Script for RTL->Gate-Level Flow (generated from GENUS 20.11-s111_1) 
## The Genus Simple Template was adapted to the riscv_pipe design.

if {[file exists /proc/cpuinfo]} {
  sh grep "model name" /proc/cpuinfo
  sh grep "cpu MHz"    /proc/cpuinfo
}

puts "Hostname : [info hostname]"

set WORKAREA $env(WORKAREA)

##############################################################################
## Preset global variables and attributes
##############################################################################
set DESIGN riscv_v
set Timing_Libs_Path /CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045/timing/
set LEF_Libs_Path /CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045/lef/ 

# We are reading a Configuration Analysis mmmc file
#set Liberty_List {slow_vdd1v0_basicCells.lib}

# LEF libraries, I/O PADs included 
set LEF_List {gsclib045_tech.lef gsclib045_macro.lef gsclib045_multibitsDFF.lef 
    /users/iteso/iteso-s10004/models/riscv_v/scripts/genus/giolib045_crag.lef}

set GEN_EFF medium
set MAP_OPT_EFF high
set DATE [clock format [clock seconds] -format "%b%d-%T"] 

set RELEASE [lindex [get_db program_version] end]

set _OUTPUT_GENUS_PATH ${WORKAREA}/synthesis/genus

set _OUTPUTS_PATH $_OUTPUT_GENUS_PATH/outputs_${DATE}
set _REPORTS_PATH $_OUTPUT_GENUS_PATH/reports_${DATE}
set _LOG_PATH $_OUTPUT_GENUS_PATH/logs_${DATE}

# Variables used by Cadence training for RTL Codes and QRC files
#set RTL_LIST {pads_SS_s1vg.v full_adder.v Adders.v Adders_Pad_Frame.v }
set RTL_LIST {riscv_pkg.sv riscv_v_pkg.sv riscv_v_macros.svh 
              riscv_csr.sv
              adder_nbit.sv behavioral_adder.sv full_adder.sv half_adder.sv mul_array.sv mul_behavioral.sv mul128_behavioral.sv multiplier_2bit.sv mulvec_behavioral.sv ripple_carry_adder.sv riscv_v_adder_comb_loop.sv 
              riscv_v_adder_min_max_comb_loop.sv riscv_v_adder_wrapper.sv riscv_v_adder.sv riscv_v_arithmetic_alu.sv riscv_v_bitwise_and.sv riscv_v_bitwise_or.sv riscv_v_bitwise_xor.sv riscv_v_bw_and.sv riscv_v_bw_or.sv riscv_v_bw_xor.sv
              riscv_v_bypass.sv riscv_v_check_params.sv riscv_v_csr_ctrl.sv riscv_v_csr.sv riscv_v_ctrl.sv riscv_v_decode_element.sv riscv_v_decode.sv riscv_v_exe_alu.sv riscv_v_execute.sv riscv_v_extend.sv riscv_v_logic_ALU.sv riscv_v_mask_ALU.sv 
              riscv_v_mask_rf.sv riscv_v_memory.sv riscv_v_mul_wrapper.sv riscv_v_mul.sv riscv_v_permutation_ALU.sv riscv_v_reduct_src.sv riscv_v_rf_ctrl.sv riscv_v_rf.sv riscv_v_shifter_wrapper.sv riscv_v_shifter.sv riscv_v_shuffler.sv
              riscv_v_stage.sv riscv_v_swizzle.sv riscv_v_twos_comp_sel.sv riscv_v.sv shifter.sv twos_comp_sel.sv vedic_mul_unsigned.sv vedic_mul.sv}

set QRC_TECH_FILE {/CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045/qrc/qx/gpdk045.tch}


set_db init_lib_search_path "$Timing_Libs_Path $LEF_Libs_Path"

set script_search_path_list {}
lappend script_search_path_list ${WORKAREA}/scripts/genus/input_genus/input_genus

set_db / .script_search_path $script_search_path_list

set init_hdl_search_path_list {}
lappend init_hdl_search_path_list ${WORKAREA}/include ${WORKAREA}/include/if ${WORKAREA}/src/riscv ${WORKAREA}/src /CMC/kits/cadence/GPDK045/giolib045_v3.3/vlog

set_db / .init_hdl_search_path $init_hdl_search_path_list

set_db / .information_level 11 

set_db hdl_track_filename_row_col true 

set_db lp_power_unit mW 


###############################################################
## Library setup
###############################################################

## Reading Configuration Analysis in a MMMC  file
read_mmmc ${WORKAREA}/scripts/genus/input_genus/WC_BC_riscv_v_pipe_A_View.tcl

puts "Review log file for execution of read_mmmc command"
#suspend

# Reading LEF Libraries
read_physical -lef $LEF_List
# You can use the command
#	check_library -libcell physical_cells/*
# to see the physical cell that you have used in your RTL.
puts "Review log file for execution of read_physical command"
#suspend

set_db tns_opto true 

####################################################################
## Load Design
####################################################################
read_hdl -sv $RTL_LIST
elaborate $DESIGN
puts "Runtime & Memory after 'read_hdl'"
time_info Elaboration
check_design
puts "View check_design Report and RTL Schematic"
#suspend

init_design
time_info init_design
check_design -unresolved
puts "Review log file for execution of init_design: Reading CONSTRAINTS and check_design commands"
#suspend

####################################################################
## Constraints Setup
####################################################################

# To print the failed constraints 
puts "$::dc::sdc_failed_commands > failed.sdc"
puts "View no-applied constraints"
#suspend
# Timing Lint
check_timing_intent -verbose

report clocks
puts "Review Timing Lint Reporte and Clock reports"
#suspend

puts "The number of exceptions is [llength [vfind "design:$DESIGN" -exception *]]"
puts "Review Exceptions"
get_db exceptions
#suspend


###################################################################################
## Defining Cost Groups (clock-clock, clock-output, input-clock, input-output)
###################################################################################

if {[llength [all::all_seqs]] > 0} { 
  define_cost_group -name I2C -design $DESIGN
  define_cost_group -name C2O -design $DESIGN
  define_cost_group -name C2C -design $DESIGN
  define_cost_group -name I2O -design $DESIGN
 path_group -from [all::all_seqs] -to [all::all_seqs] -group C2C -name C2C -view view_riscv_v_pipe_slow
 path_group -from [all::all_seqs] -to [all_outputs]   -group C2O -name C2O -view view_riscv_v_pipe_slow
 path_group -from [all_inputs] 	  -to [all::all_seqs] -group I2C -name I2C -view view_riscv_v_pipe_slow
 path_group -from [all_inputs]    -to [all_outputs]   -group I2O -name I2O -view view_riscv_v_pipe_slow
}

get_db cost_groups

puts " Review Cost Group Creation"
#suspend

if {![file exists ${_OUTPUTS_PATH}]} {
  file mkdir ${_OUTPUTS_PATH}
  puts "Creating directory ${_OUTPUTS_PATH}"
}

if {![file exists ${_REPORTS_PATH}]} {
  file mkdir ${_REPORTS_PATH}
  puts "Creating directory ${_REPORTS_PATH}"
}

if {![file exists ${_LOG_PATH}]} {
  file mkdir ${_LOG_PATH}
  puts "Creating directory ${_LOG_PATH}"
}

report_timing -group {I2C C2O C2C I2O} > ${_REPORTS_PATH}/${DESIGN}_pretim.rpt

report_timing > ${_REPORTS_PATH}/${DESIGN}_pretim.rpt

puts "Check Pretimng Report"
#suspend

####################################################################################################
## Synthesizing to generic 
####################################################################################################
set_db / .syn_generic_effort $GEN_EFF
syn_generic
puts "Runtime & Memory after 'syn_generic'"
time_info GENERIC
report_dp > $_REPORTS_PATH/generic/${DESIGN}_datapath.rpt
write_snapshot -outdir $_REPORTS_PATH -tag generic
report_summary -directory $_REPORTS_PATH

# Generate Generic Netlist
write_hdl -generic > ${_OUTPUTS_PATH}/${DESIGN}_generic.v
puts "View Generic Schematic"
suspend
####################################################################################################
## Synthesizing to Gates (Maped)
####################################################################################################
set_db / .syn_map_effort $MAP_OPT_EFF
syn_map
puts "Runtime & Memory after 'syn_map'"
time_info MAPPED
write_snapshot -outdir $_REPORTS_PATH -tag map

# QoS Summary report final.rpt
report_summary -directory $_REPORTS_PATH
report_dp > $_REPORTS_PATH/map/${DESIGN}_datapath.rpt

# Generate Mapped Netlist
write_hdl -lec > ${_OUTPUTS_PATH}/${DESIGN}_intermediate.v

# LEC Do File RTL to Intermediate
write_do_lec -no_exit -revised_design ${_OUTPUTS_PATH}/${DESIGN}_intermediate.v -logfile ${_LOG_PATH}/rtl2intermediate.lec.log > ${_OUTPUTS_PATH}/rtl2intermediate.lec.do

puts "View Mapped Schematic"
suspend
#######################################################################################################
## Optimize Netlist
#######################################################################################################

set_db / .syn_opt_effort $MAP_OPT_EFF
syn_opt
write_snapshot -outdir $_REPORTS_PATH -tag syn_opt
report_summary -directory $_REPORTS_PATH
puts "Runtime & Memory after 'syn_opt'"
time_info OPT
write_snapshot -outdir $_REPORTS_PATH -tag final

report_summary -directory $_REPORTS_PATH
write_hdl  > ${_OUTPUTS_PATH}/${DESIGN}_hdl_opt.v
write_design -basename ${_OUTPUTS_PATH}/${DESIGN}_opt

write_sdc -version 1.1 -view view_riscv_v_pipe_slow $DESIGN > ${_OUTPUTS_PATH}/${DESIGN}_opt_WC.sdc
write_sdc -version 1.1 -view view_riscv_v_pipe_fast $DESIGN > ${_OUTPUTS_PATH}/${DESIGN}_opt_BC.sdc
puts "Review  Optimized reports and Schematic"
suspend
#################################
### write_do_lec
#################################
write_do_lec -golden_design ${_OUTPUTS_PATH}/${DESIGN}_intermediate.v -revised_design ${_OUTPUTS_PATH}/${DESIGN}_opt.v -logfile  ${_LOG_PATH}/intermediate2final.lec.log > ${_OUTPUTS_PATH}/intermediate2final.lec.do

##Uncomment if the RTL is to be compared with the final netlist..
write_do_lec -revised_design ${_OUTPUTS_PATH}/${DESIGN}_opt.v -logfile ${_LOG_PATH}/rtl2final.lec.log > ${_OUTPUTS_PATH}/rtl2final.lec.do

#suspend
puts "Final Runtime & Memory."
time_info FINAL

file copy [get_db / .stdout_log] ${_LOG_PATH}/.

puts "============================"
puts "Synthesis Finished ........."
puts "============================"

##quit
