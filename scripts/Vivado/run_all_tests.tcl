#Run all Testbench
foreach tb $DUTS {
    set TB $tb
    puts "Running TB: $dut"
    foreach test [set ${tb}_tests] {
        set TEST $test
        puts "Runnint test: $test"
        if {$CODE_COVERAGE == 1} {
            source ${WORK_AREA}/../scripts/Vivado/elaborate.tcl
            source ${WORK_AREA}/../scripts/Vivado/run_test_code_cov.tcl
        } else {
            source ${WORK_AREA}/../scripts/Vivado/run_test.tcl
        }
        
    }
}