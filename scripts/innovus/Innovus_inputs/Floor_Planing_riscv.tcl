# ITESO University
# Miguel Bucio 2022
# Floor planing script for riscv_pipeline
# Floor_Planing_riscv.tcl

# Defining process mode 
setDesignMode -process 45

# Defining floorplan
floorPlan -site CoreSite -b 0.0 0.0 1120.0 1120.0 290.0 290.0 830.0 830.0 304.0 304.16 816.0 816.81
fit
