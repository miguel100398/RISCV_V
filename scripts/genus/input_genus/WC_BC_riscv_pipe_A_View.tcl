# ANALYSIS CONFIGURATION MMMC FILE 
# RISC_V_pipeline MMMC FILE
# File Name: WC_BC_riscv_pipe_A_View.tcl
# The gio.lib are in the design folder
# ITESO
# Miguel Bucio

# LIBRARY SET DEFINITIONS Functional Verilog are added
create_library_set -name LS_slow -timing { 
/CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v0_basicCells.lib  \ 
/CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v0_multibitsDFF.lib \
../GPDK045_gio_lib/pads_SS_s1vg.lib }

# TIMING LIBRARIES INCLUDING I/O Blocks .lib
create_library_set -name LS_fast -timing {
/CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045/timing/fast_vdd1v2_basicCells.lib \
/CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045/timing/fast_vdd1v2_multibitsDFF.lib\
../GPDK045_gio_lib/pads_FF_s1vg.lib }

# create_library_set -name LS_typ  -timing { }

# OPERATION CONDITIONS (PVT) 
create_opcond -name OC_riscv_pipe_slow	-process 1 -voltage 0.9  -temperature 125
create_opcond -name OC_riscv_pipe_fast	-process 1 -voltage 1.32 -temperature 0
# create_opcond -name OC_riscv_pipe_typ	-process 1 -voltage 1.2  -temperature 25

# TIMING CONDITIONS
create_timing_condition -name TC_riscv_pipe_slow    -opcond OC_riscv_pipe_slow  -library_sets { LS_slow }
create_timing_condition -name TC_riscv_pipe_fast    -opcond OC_riscv_pipe_fast  -library_sets { LS_fast }

# DELAY CORNERS
create_delay_corner -name DC_riscv_pipe_slow -early_timing_condition TC_riscv_pipe_slow \
                    -late_timing_condition TC_riscv_pipe_slow 

create_delay_corner -name DC_riscv_pipe_fast -early_timing_condition TC_riscv_pipe_fast \
                    -late_timing_condition TC_riscv_pipe_fast

# CONSTRAINTS MODES 
create_constraint_mode -name CM_riscv_pipe_slow -sdc_files { \
   ../input_genus/constraints_riscv_pipe_slow_sdc.tcl
}

create_constraint_mode -name CM_riscv_pipe_fast -sdc_files { \
   ../input_genus/constraints_riscv_pipe_fast_sdc.tcl
}

# ANALISIS VIEW DEFINITIONS
create_analysis_view -name view_riscv_pipe_slow -constraint_mode CM_riscv_pipe_slow -delay_corner  DC_riscv_pipe_slow
create_analysis_view -name view_riscv_pipe_fast -constraint_mode CM_riscv_pipe_fast -delay_corner  DC_riscv_pipe_fast

# SETTING OF ANALYSIS VIEW
set_analysis_view -setup { view_riscv_pipe_slow } -hold { view_riscv_pipe_fast }

