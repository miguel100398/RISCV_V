#!

#tclsh scripts/run_regression.tcl Xcelium off True True False regression/xcelium | & tee xcelieum_regression.log
#tclsh scripts/run_regression.tcl Incisive all False False True regression/incisive | & tee incisive_regression.log

set start_time [clock seconds]

set test_max_time 0
set test_max_time_name ""
set dut_max_time 0
set dut_max_time_name ""

set init_end_time 0
set run_tests_end_time 0
set check_regression_end_time 0
set cov_end_time 0

set cov_files ""
puts "#######################################################################"

puts "########################Arguments######################################"
if { $argc != 7 } {
    puts stderr "Error: Invalid number of arguments, arguments are"
    puts "  tool      : Defines tool to run regression, valid tools are:"
    puts "      Xcelium"
    puts "      Incisive"
    puts "  cov_mode  : Sets the coverage mode, valid values are:"
    puts "      off        : Turn off coverage collection"
    puts "      Block      : Enables Block coverage"
    puts "      Expr       : Enables Expression coverage"
    puts "      FSM        : Enables FSM coverage"
    puts "      Toggle     : Enables Toggle Coverage"
    puts "      Functional : Enables Functional Coverage"
    puts "      All        : Enables All coverage"
    puts "  log_en : Enables or disables log messages"
    puts "  check_regression_en  : Enables or disables check regression"
    puts "  analysis_coverage_en : Enables or disables coverage analysis"
    puts "  output_dir     : Directory to save regression results"
    puts "  test_list_dir  : Regression Test list directory to be executed"
    puts "Exiting"
    exit 1
}

#Check if WORKAREA is defined
if { ![info exists ::env(WORKAREA)] } {
    puts stderr "Error: WORKAREA not defined, exiting"
    exit 1
}

set WORKAREA $::env(WORKAREA)


set tool [lindex $argv 0]
set cov_mode [lindex $argv 1]
set log_en [lindex $argv 2]
set check_regression_en [lindex $argv 3]
set analysis_coverage_en [lindex $argv 4]
set output_dir [lindex $argv 5]
set test_list [lindex $argv 6]

puts "WORKAREA:             $WORKAREA"
puts "tool:                 $tool"
puts "cov_mode:             $cov_mode"
puts "log_en:               $log_en"
puts "check_regression_en:  $check_regression_en"
puts "analysis_coverage_en: $analysis_coverage_en"
puts "output_dir:           $output_dir"
puts "test_list_dir:        $test_list"


if {$tool == "Xcelium" || $tool == "xcelium" || $tool == "XCELIUM"} {
    set tool Xcelium
    set run_tool xrun
    set REGRESSION_ARGUMENTS_F ${WORKAREA}/scripts/Xrun/xrun_regression.f
    set log_name xrun.log
} elseif {$tool == "Incisive" || $tool == "incisive" || $tool == "INCISIVE"} {
    set tool Incisive
    set run_tool irun
    set REGRESSION_ARGUMENTS_F ${WORKAREA}/scripts/Irun/irun_regression.f
    set log_name irun.log
} else {
    puts stderr "Error, tool: $tool not supported, exiting"
    exit 1
}

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

if {$output_dir == ""} {
    puts stderr "Error: Output directory can't be empty, exiting"
    exit 1
}

if {$test_list == ""} {
    puts stderr "Error: Test List can't be empty, exiting"
    exit 1
}

set TEST_LIST_DIR ${WORKAREA}/$test_list

if { ![file exist $TEST_LIST_DIR] } {
    puts stderr "Error Test list doesn't exist, exiting"
    exit 1
}

set REGRESSION_DIR ${WORKAREA}/${output_dir}/
puts "REGRESSION_DIR:       $REGRESSION_DIR"
puts "TEST_LIST_DIR:        $TEST_LIST_DIR"

puts "Starting run_regression"

puts "#######################Init regression##################################"

#Define Duts
puts "Reading DUTS Test List"

if { ![file exist ${TEST_LIST_DIR}/DUTS.list] } {
    puts stderr "Error ${TEST_LIST_DIR}/DUTS.list doesn't exist, exiting"
    exit 1
}

set test_list_f [open ${TEST_LIST_DIR}/DUTS.list r]
set lines_duts [split [read $test_list_f] "\n"]
close $test_list_f

foreach line_dut $lines_duts {
    lappend DUTS $line_dut
}


if { $DUTS == "" } {
    puts stderr "Error: DUTS is empty exiting"
    exit 1
}

#Define Tests
puts "Reading TESTS Test List"
foreach DUT $DUTS {

    if { ![file exist ${TEST_LIST_DIR}/${DUT}_TESTS.list] } {
        puts stderr "Error ${TEST_LIST_DIR}/${DUT}_TESTS.list doesn't exist, exiting"
        exit 1
    }

    set test_list_f [open ${TEST_LIST_DIR}/${DUT}_TESTS.list r]
    set lines_tests [split [read $test_list_f] "\n"]
    close $test_list_f

    foreach line_dut $lines_duts {
        lappend ${DUT}_tests $lines_tests
    }

}

puts "DUTS and tests defined"

foreach DUT $DUTS {
    puts "  $DUT"
    if { [set ${DUT}_tests] == "" } {
        puts stderr "Error: ${DUT}_tests is empty exiting"
        exit 1
    }

    foreach TEST [set ${DUT}_tests] {
        puts "      $TEST"
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

puts "#############################RUN TEST###################################"

puts "Start run tests"
set run_tests_start_time [clock seconds]

foreach DUT $DUTS {

    set dut_start_time [clock seconds]
    puts "  Running DUT: $DUT"

    file mkdir $DUT
    cd $DUT

    foreach TEST [set ${DUT}_tests] {

        set test_start_time [clock seconds]
        puts "      Running TEST: $TEST"
        file mkdir $TEST
        cd $TEST

        if {[catch {exec $run_tool -f $REGRESSION_ARGUMENTS_F -top $DUT +UVM_TESTNAME=$TEST $cov_cmd $log_cmd} result] != 0} { 
            puts "$result"
            puts stderr         "Error: Run Test didn't complete succesfully, exiting"
            exit 1
        }

        if { $cov_mode != "Off" } {
            lappend cov_files ${REGRESSION_DIR}${DUT}/${TEST}/cov_work/scope/test
        }

        cd ../
        set test_end_time [expr [clock seconds] - $test_start_time]
        puts "      Completed run TEST: $TEST, elapsed time: ${test_end_time}s"

        if { $test_end_time > $test_max_time } {
        set test_max_time $test_end_time
        set test_max_time_name $TEST
    }

    }

    cd ../
    set dut_end_time [expr [clock seconds] - $dut_start_time]
    puts "  Completed run DUT: ${DUT}, elapsed time: ${dut_end_time}s"

    if { $dut_end_time > $dut_max_time } {
        set dut_max_time $dut_end_time
        set dut_max_time_name $DUT
    }

}

set run_tests_end_time [expr [clock seconds] - $run_tests_start_time]
puts "Completed run tests, Elapsed time: ${run_tests_end_time}s"

puts "###########################CHECK REGRESSION#################################"

if {$check_regression_en == "True"} {
    if {$log_en != "True"} {
        puts stderr "Error: Can't analyze regression if log is not enabled"
    } else {
        puts "Checking regression"
        set check_regression_start_time [clock seconds]
        if {[catch {exec python3 ${WORKAREA}/scripts/check_regression.py $output_dir $log_name >@ stdout} result] != 0} { 
            puts stderr "Error: check_regression didn't complete succesfully"
        }
        set check_regression_end_time [expr [clock seconds] - $check_regression_start_time]
        puts "Checking regression completed, Elapsed time: ${check_regression_end_time}s"
    }
} else {
    puts "Check Regression disabled, skiping this part"
}

puts "###########################Coverage#########################################"
#Coverage tool is not enabled for xcelium > 20
if {$analysis_coverage_en == "True"} {
    if {$cov_mode == "Off"} {
        puts stderr "Error: Coverage can't be analyzed if coverage mode is off"
    } elseif {$tool == "Xcelium"} {
        puts stderr "Coverage tool is not enabled for xcelium > 20, can't analyze coverage"
    } else {
        puts "Starting coverage analyze"

        set cov_start_time [clock seconds]
        
        file mkdir cov_merge
        cd cov_merge

        #Write coverate runfile
        if { [file exist "merge_cov_list.txt"] } {
            puts "Merge cov list already exists, removing file"
        }

        set merge_cov_list [open "merge_cov_list.txt" w+]

        foreach file $cov_files {
            puts $merge_cov_list $file
        }
        
        close $merge_cov_list
        puts "Merge_cov_list created"

        puts "Executing IMC"
        if {[catch {exec imc -exec ${WORKAREA}/scripts/cov_merge.tcl >@ stdout} result] == 0} { 
            puts $result
            puts stderr "Error: coverage analysis didn't complete succesfully"
        }
        puts "IMC Executed"

        cd ../

        set cov_end_time [expr [clock seconds] - $cov_start_time]
        puts "Coverage analyzed, elapsed time: ${cov_end_time}s"

    }
} else {
    puts "Coverage analysis disabled, skiping this part"
}

puts "##########################Completed run regression######################"
puts "SUMMARY"
puts "Init Time elapsed: ${init_end_time}s"
puts "Run tests Time Elapsed: ${run_tests_end_time}s"
puts "Checking regression Time Elapsed: ${check_regression_end_time}s"
puts "Coverage analyzed Time Elapsed: ${cov_end_time}s"
puts "DUT with most execution time:  $dut_max_time_name ${dut_max_time}s"
puts "Test with most execution time: $test_max_time_name ${test_max_time}s"

set end_time [expr [clock seconds] - $start_time]
puts "Run regression completed, Elapsed time: ${end_time}s"

puts "#######################################################################"