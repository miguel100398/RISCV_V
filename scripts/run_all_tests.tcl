#Run all Testbench
foreach tb $DUTS {
    set TB $tb
    puts "Running TB: $dut"
    foreach test [set ${tb}_tests] {
        set TEST $test
        puts "Runnint test: $test"
        source ${WORK_AREA}/../scripts/run_test.tcl
        
    }
}