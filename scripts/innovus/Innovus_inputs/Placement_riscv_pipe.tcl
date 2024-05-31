# ITESO University
# Miguel Bucio
# Placement script
#
Puts "Starting to do Design Placement..."

#dbDeleteTrialRoute

#setPlaceMode -reset
setPlaceMode -congEffort high -timingDriven 1 -clkGateAware 1 -powerDriven 0 -ignoreScan 1 -reorderScan 1 -ignoreSpare 0 -placeIOPins 0 -moduleAwareSpare 0 -preserveRouting 1 -rmAffectedRouting 1 -checkRoute 1 -honorSoftBlockage true -swapEEQ 0
setPlaceMode -fp false
place_design

checkPlace
checkPinAssignment -report_violating_pin


Puts "... finished Design Placement"
