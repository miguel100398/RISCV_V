################################################################################
#
# Init setup file
# Created by Genus(TM) Synthesis Solution on 12/01/2022 23:55:24
#
################################################################################

      if { ![is_common_ui_mode] } {
        error "This script must be loaded into an 'innovus -stylus' session."
      }
    


read_mmmc outputs_Dec01-23:19:04/RISC_V_pipeline_opt.mmmc.tcl

read_physical -lef {/CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045/lef//gsclib045_tech.lef /CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045/lef//gsclib045_macro.lef /CMC/kits/cadence/GPDK045/gsclib045_all_v4.4/gsclib045/lef//gsclib045_multibitsDFF.lef /users/iteso-s005/models/riscv_pipe/genus/giolib045_crag.lef}

read_netlist outputs_Dec01-23:19:04/RISC_V_pipeline_opt.v

init_design -skip_sdc_read
