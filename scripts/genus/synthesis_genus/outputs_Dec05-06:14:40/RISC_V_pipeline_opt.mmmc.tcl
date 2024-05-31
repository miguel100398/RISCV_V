#################################################################################
#
# Created by Genus(TM) Synthesis Solution 20.11-s111_1 on Mon Dec 05 07:10:59 UTC 2022
#
#################################################################################

## library_sets
create_library_set -name LS_slow \
    -timing { /CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v0_basicCells.lib \
              /CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045/timing/slow_vdd1v0_multibitsDFF.lib \
              /users/iteso-s005/models/riscv_pipe/genus/synthesis_genus/../GPDK045_gio_lib/pads_SS_s1vg.lib }
create_library_set -name LS_fast \
    -timing { /CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045/timing/fast_vdd1v2_basicCells.lib \
              /CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045/timing/fast_vdd1v2_multibitsDFF.lib \
              /users/iteso-s005/models/riscv_pipe/genus/synthesis_genus/../GPDK045_gio_lib/pads_FF_s1vg.lib }

## opcond
create_opcond -name OC_riscv_pipe_slow \
    -process 1.0 \
    -voltage 0.9 \
    -temperature 125.0
create_opcond -name OC_riscv_pipe_fast \
    -process 1.0 \
    -voltage 1.32 \
    -temperature 0.0

## timing_condition
create_timing_condition -name TC_riscv_pipe_slow \
    -opcond OC_riscv_pipe_slow \
    -library_sets { LS_slow }
create_timing_condition -name TC_riscv_pipe_fast \
    -opcond OC_riscv_pipe_fast \
    -library_sets { LS_fast }

## rc_corner
create_rc_corner -name default_emulate_rc_corner \
    -temperature 125.0 \
    -pre_route_res 1.0 \
    -pre_route_cap 1.0 \
    -pre_route_clock_res 0.0 \
    -pre_route_clock_cap 0.0 \
    -post_route_res {1.0 1.0 1.0} \
    -post_route_cap {1.0 1.0 1.0} \
    -post_route_cross_cap {1.0 1.0 1.0} \
    -post_route_clock_res {1.0 1.0 1.0} \
    -post_route_clock_cap {1.0 1.0 1.0}

## delay_corner
create_delay_corner -name DC_riscv_pipe_slow \
    -early_timing_condition { TC_riscv_pipe_slow } \
    -late_timing_condition { TC_riscv_pipe_slow } \
    -early_rc_corner default_emulate_rc_corner \
    -late_rc_corner default_emulate_rc_corner
create_delay_corner -name DC_riscv_pipe_fast \
    -early_timing_condition { TC_riscv_pipe_fast } \
    -late_timing_condition { TC_riscv_pipe_fast } \
    -early_rc_corner default_emulate_rc_corner \
    -late_rc_corner default_emulate_rc_corner

## constraint_mode
create_constraint_mode -name CM_riscv_pipe_slow \
    -sdc_files { outputs_Dec05-06:14:40/RISC_V_pipeline_opt.CM_riscv_pipe_slow.sdc }
create_constraint_mode -name CM_riscv_pipe_fast \
    -sdc_files { outputs_Dec05-06:14:40/RISC_V_pipeline_opt.CM_riscv_pipe_fast.sdc }

## analysis_view
create_analysis_view -name view_riscv_pipe_slow \
    -constraint_mode CM_riscv_pipe_slow \
    -delay_corner DC_riscv_pipe_slow
create_analysis_view -name view_riscv_pipe_fast \
    -constraint_mode CM_riscv_pipe_fast \
    -delay_corner DC_riscv_pipe_fast

## set_analysis_view
set_analysis_view -setup { view_riscv_pipe_slow } \
                  -hold { view_riscv_pipe_fast }
