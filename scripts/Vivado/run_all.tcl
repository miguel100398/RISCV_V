source ../scripts/Vivado/init.tcl 
if { !($CODE_COVERAGE == 1)} {
    source ../scripts/Vivado/elaborate.tcl
}
source ../scripts/Vivado/run_all_tests.tcl
source ../scripts/Vivado/gen_cov.tcl