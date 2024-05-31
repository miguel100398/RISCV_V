################################################################################
#
# Init setup file
# Created by Genus(TM) Synthesis Solution on 12/05/2022 07:11:02
#
################################################################################

      if { ![is_common_ui_mode] } {
        error "This script must be loaded into an 'innovus -stylus' session."
      }
    


read_mmmc outputs_Dec05-06:14:40/RISC_V_pipeline_opt.mmmc.tcl

read_physical -lef {/CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045/lef//gsclib045_tech.lef /CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045/lef//gsclib045_macro.lef /CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045/lef//gsclib045_multibitsDFF.lef /users/iteso-s005/models/riscv_pipe/genus/giolib045_crag.lef}

read_netlist outputs_Dec05-06:14:40/RISC_V_pipeline_opt.v

init_design -skip_sdc_read
