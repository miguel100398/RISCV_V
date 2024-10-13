#Check arguments
if {$TB == ""} {
    puts stderr "TestBench is null"
    return 1
}
if {$TEST == ""} {
    puts stderr "Test is null"
    return 1
}

puts "TB is $TB"
puts "Test is $TEST"

#Launch simulation
cd ${WORK_AREA}/riscv_v.sim/sim_1/behav/xsim/


xsim ${TB}_behav -key {Behavioral:sim_1:Functional:$tb} -testplusarg UVM_TESTNAME=$TEST -wdb waves -cov_db_dir functional_cov -cov_db_name ${TEST}_cov_db

#Get Waves
if {$WAVES == 1} {
    set curr_wave [current_wave_config]
    if { [string length $curr_wave] == 0 } {
    if { [llength [get_objects]] > 0} {
        add_wave /
        set_property needs_save false [current_wave_config]
    } else {
        send_msg_id Add_Wave-1 WARNING "No top level signals found. Simulator will start without a wave window. If you want to open a wave window go to 'File->New Waveform Configuration' or type 'create_wave_config' in the TCL console."
    }
    }
}

#Run test
run all > ${TEST}.testlog

#Close sim
if {$CLOSE_WAVES == 1} {
    close_sim
}

#Generate Coverage
#exec xcrg -report_format html -dir ./cov/xsim.covdb -report_dir cov_report
#exec xcrg -report_format html -dir ./cov_merge/functional/xsim.covdb/ -report_dir ./cov_reports/functional/

#Copy coverage data bases to Merge coverage folder
file copy -force ./functional_cov/xsim.covdb/${TEST}_cov_db ${COV_MERGE}/functional/xsim.covdb/
file copy -force ./code_cov/xsim.codeCov/code_cov_db/ ${COV_MERGE}/code/xsim.codeCov/
file rename -force ${COV_MERGE}/code/xsim.codeCov/code_cov_db ${COV_MERGE}/code/xsim.codeCov/${TEST}_code_db

#Delete files to force recompilation needed to generate new code coverage data base
file delete -force ./code_cov/
file delete -force ./xsim.dir

cd $WORK_AREA