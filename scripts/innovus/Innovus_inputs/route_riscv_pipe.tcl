# ITESO University
# Miguel Bucio

Puts "Routing the Design"
setNanoRouteMode -quiet -timingEngine {}
setNanoRouteMode -quiet -routeWithSiPostRouteFix 0
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven true
routeDesign -globalDetail

Puts "Timing the design after Route"
timeDesign -postRoute -prefix postRoute_setup
timeDesign -postRoute -prefix postRoute_hold  -hold


#### Exportar hacia Virtuoso
set nameGDS "riscv_pipe.gds";  #Editar nombre de ser necesario  

streamOut ../GDS/${nameGDS} -mapFile /media/Ext/libs/IBM_PDK/bicmos8hp/v.20171220/lef/bicmos8hp_soce2gds.map -libName DesignLib -merge { /media/Ext/libs/8HP_IP_CELL_AND_IO_Libs/BiCMOS8HP_Digital_Kit/ibm_cmos8hp/sc_1p2v_12t_rvt/v.20171220/gds2/BICMOS8HP_SC_1P2V_12T_RVT.gds /opt/libs/IBM_PDK/bicmos8hp/v.20160727/gds2/CMOS8HP_BASE_WB_IO_7LM.gds } -outputMacros -units 1000 -mode ALL
