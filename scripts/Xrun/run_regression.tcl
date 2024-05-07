set start_time [clock seconds]

set test_max_time 0
set test_max_time_name ""
set dut_max_time 0
set dut_max_time_name ""

########################Arguments########################################
if { $argc != 4 } {
    puts stderr "Error: Invalid number of arguments, arguments are"
    puts "  cov_mode  : Sets the coverage mode, valid values are"
    puts "      off        : Turn off coverage collection"
    puts "      Block      : Enables Block coverage"
    puts "      Expr       : Enables Expression coverage"
    puts "      FSM        : Enables FSM coverage"
    puts "      Toggle     : Enables Toggle Coverage"
    puts "      Functional : Enables Functional Coverage"
    puts "      All        : Enables All coverage"
    puts "  log_en : Enables or disables log messages"
    puts "  check_regression_en : Enables or disables check regression"
    puts "  analysis_coverage_en : Enables or disables coverage analysis"
    puts "Exiting"
    exit 1
}

set cov_mode [lindex $argv 0]
set log_en [lindex $argv 1]
set check_regression_en [lindex $argv 2]
set analysis_coverage_en [lindex $argv 3]

puts "cov_mode $cov_mode"
puts "log_en $log_en"
puts "check_regression_en $check_regression_en"
puts "analysis_coverage_en $analysis_coverage_en"

if {$cov_mode == "off" || $cov_mode == "Off" || $cov_mode == "OFF"} {
    set cov_mode "Off" 
    set cov_cmd ""
} else {
    set cov_cmd "-coverage $cov_mode"
}

if {$log_en == "True" || $log_en == "true" || $log_en == "TRUE"} {
    set log_en "True"
    set log_cmd ""
} else {
    set log_en "False"
    set log_cmd "-NOLOG"
}

if {$check_regression_en == "True" || $check_regression_en == "true" || $check_regression_en == "TRUE"} {
    set check_regression_en True
} else {
    set check_regression_en False
}

if {$analysis_coverage_en == "True" || $analysis_coverage_en == "true" || $analysis_coverage_en == "TRUE"} {
    set analysis_coverage_en True 
} else {
    set analysis_coverage_en False
}

puts "Starting run_regression"

#Check if WORKAREA is defined
if { ![info exists ::env(WORKAREA)] } {
    puts stderr "Error: WORKAREA not defined, exiting"
    exit 1
}

set WORKAREA $::env(WORKAREA)

puts "WORKAREA $WORKAREA"

#######################Init regression##################################

set REGRESSION_DIR ${WORKAREA}/regression_xcelium
puts "REGRESSION_DIR $REGRESSION_DIR"

#Define Duts
puts "Defining DUTS"
set DUTS {riscv_v_tb}

if { $DUTS == "" } {
    puts stderr "Error: DUTS is empty exiting"
    exit 1
}

puts "DUTS defined"

foreach DUT $DUTS {
    puts "$DUT"
}

#Define Tests
puts "Defining tests"
set riscv_v_tb_tests {riscv_v_cpu_vadd_test riscv_v_cpu_vadc_test}
puts "Tests Defined"

foreach DUT $DUTS {

    if { [set ${DUT}_tests] == "" } {
        puts stderr "Error: ${DUT}_tests is empty exiting"
        exit 1
    }

    foreach TEST [set ${DUT}_tests] {
        puts "DUT: $DUT, TEST: $TEST"
    }
}

#Create regression Folder
puts "Creating regression folder"
if { [file exist $REGRESSION_DIR] } {
    puts "Regression already exists, deleting regression"
    file delete -force $REGRESSION_DIR
}

file mkdir $REGRESSION_DIR
cd $REGRESSION_DIR
puts "Regression folder created"

set init_end_time [expr [clock seconds] - $start_time]
puts "Init Time elapsed: ${init_end_time}s"

#############################RUN TEST#################################

puts "Start run tests"
set run_tests_start_time [clock seconds]

foreach DUT $DUTS {

    set dut_start_time [clock seconds]
    puts "Running DUT: $DUT"

    file mkdir $DUT
    cd $DUT

    foreach TEST [set ${DUT}_tests] {

        set test_start_time [clock seconds]
        puts "Running TEST: $TEST"
        file mkdir $TEST
        cd $TEST

        exec xrun -f ${WORKAREA}/scripts/Xrun/xrun_regression.f -top $DUT +UVM_TESTNAME=$TEST $cov_cmd $log_cmd
        
        cd ../
        set test_end_time [expr [clock seconds] - $test_start_time]
        puts "Completed run TEST: $TEST, elapsed time: ${test_end_time}s"

        if { $test_end_time > $test_max_time } {
        set test_max_time $test_end_time
        set test_max_time_name $TEST
    }

    }

    cd ../
    set dut_end_time [expr [clock seconds] - $dut_start_time]
    puts "Completed run DUT: ${DUT}, elapsed time: ${dut_end_time}s"

    if { $dut_end_time > $dut_max_time } {
        set dut_max_time $dut_end_time
        set dut_max_time_name $DUT
    }

}

set run_tests_end_time [expr [clock seconds] - $run_tests_start_time]
puts "Completed run tests, Elapsed time: ${run_tests_end_time}s"

#############################CHECK REGRESSION#####################################

if {$check_regression_en == "True"} {
    if {$log_en != "True"} {
        puts stderr "Error: Can't analyze regression if log is not enabled"
    } else {
        puts "Checking regression"
        set check_regression_start_time [clock seconds]
        exec python3 ${WORKAREA}/scripts/Xrun/check_regression.py >@ stdout
        set check_regression_end_time [expr [clock seconds] - $check_regression_start_time]
        puts "Checking regression completed, Elapsed time: ${check_regression_end_time}s"
    }
}

#############################Coverage##############################################
#Coverage tool is not enabled for xcelium > 20
if {$analysis_coverage_en == "True"} {
    if {$cov_mode == "Off"} {
        puts stderr "Error: Coverage can't be analyzed if coverage mode is off"
    } else {
        puts stderr "Coverage tool is not enabled for xcelium > 20, can't analyze coverage"
    }
}

############################Completed run regression##############################
puts "DUT with most execution time:  $dut_max_time_name ${dut_max_time}s"
puts "Test with most execution time: $test_max_time_name ${test_max_time}s"

set end_time [expr [clock seconds] - $start_time]
puts "Run regression completed, Elapsed time: ${end_time}s"

