# ITESO University
# Miguel Bucio 2022
# Power grid script for riscv_pipeline
# PowerGrid_riscv_pipe.tcl

# Defining global nets
#	clearGlobalNets
#	globalNetConnect VDD -type pgpin -pin VDD -inst * -module {} -verbose
#	globalNetConnect VSS -type pgpin -pin VSS -inst * -module {} -verbose
# The correct syntax for TIEHI Y TIELO

#	globalNetConnect VDD -type tiehi -inst * -verbose
#	globalNetConnect VSS -type tielo -inst * -verbose

# Innovus Global Nets
clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -instanceBasename * -hierarchicalInstance {} -verbose
globalNetConnect VSS -type pgpin -pin VSS -instanceBasename * -hierarchicalInstance {} -verbose
# Check Syntax  for TIEHI & TIELO
globalNetConnect VDD -type tiehi -pin VDD -instanceBasename * -hierarchicalInstance {} -verbose
globalNetConnect VSS -type tielo -pin VSS -instanceBasename * -hierarchicalInstance {} -verbose
# VDD_IO and VSS_IO
# The following line produces an error
globalNetConnect VDDIOR -type pgpin -pin VDDIOR -inst * -module {} -verbose
globalNetConnect VSSIOR -type pgpin -pin VSSIOR -inst * -module {} -verbose

##FIllers
addIoFiller -cell padIORINGFEED1 -prefix FILLER -side n
addIoFiller -cell padIORINGFEED1 -prefix FILLER -side e
addIoFiller -cell padIORINGFEED1 -prefix FILLER -side s
addIoFiller -cell padIORINGFEED1 -prefix FILLER -side w



# Creating Power Rins
setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer Metal11 -stacked_via_bottom_layer Metal1 -via_using_exact_crossover_size 1 -orthogonal_only true -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
addRing -nets {VDD VSS} -type core_rings -follow core -layer {top Metal1 bottom Metal1 left Metal10 right Metal10} -width {top 4 bottom 4 left 4 right 4} -spacing {top 2 bottom 2 left 2 right 2} -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} -center 1 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None
fit

# Adding horizontal stripes
setSrouteMode -viaConnectToShape { noshape }
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { Metal1(1) Metal11(11) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { Metal1(1) Metal11(11) } -nets { VDD VSS } -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { Metal1(1) Metal11(11) }


# Adding vertical stripes

setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer Metal11 -stacked_via_bottom_layer Metal1 -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog { padcore_ring  block_ring } -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape   }
addStripe -nets {VDD VSS} -layer Metal10 -direction vertical -width 3 -spacing 1.5 -number_of_sets 8 -start_from left -start_offset 45 -stop_offset 45 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit Metal11 -padcore_ring_bottom_layer_limit Metal1 -block_ring_top_layer_limit Metal11 -block_ring_bottom_layer_limit Metal1 -use_wire_group 0 -snap_wire_center_to_grid None

#Route IO power ring
setSrouteMode -viaConnectToShape { noshape }
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { Metal1(1) Metal11(11) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { Metal1(1) Metal11(11) } -nets { VDD VDD1 VDD2 VDDIOR VSS VSS1 VSS2 VSS3 VSSIOR } -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { Metal1(1) Metal11(11) }

#Check connectivity
verifyConnectivity -type all -error 1000 -warning 50

#Remove false connectivity violations
violationBrowserMarkFalse -tool Verify -violation 
violationBrowser -all -no_display_false -displayByLayer
violationBrowserClose
